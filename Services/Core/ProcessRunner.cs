using System.Diagnostics;
using System.Text;

namespace WsaPacman.Services.Core;

/// <summary>内部処理設計書 §2.1.</summary>
public sealed record ProcessResult(int ExitCode, string StdOut, string StdErr, bool IsTimeout)
{
    public static ProcessResult Timeout { get; } = new(-1, "TIMEOUT", "TIMEOUT", true);

    /// <summary>Flutter版 defaultError() 相当 — 起動自体に失敗した場合（exe不在等）。</summary>
    public static ProcessResult Error { get; } = new(-1, "", "", false);
}

public interface IProcessRunner
{
    /// <summary>
    /// 非表示（CreateNoWindow）で実行し、タイムアウト時は <see cref="ProcessResult.Timeout"/> を返す。
    /// 起動時例外（exe不在等）は throw せず <see cref="ProcessResult.Error"/> を返す。
    /// <paramref name="ct"/> によるキャンセルは通常どおり <see cref="OperationCanceledException"/> を送出する。
    /// </summary>
    Task<ProcessResult> RunAsync(
        string fileName, IReadOnlyList<string> arguments,
        TimeSpan? timeout = null, string? workingDirectory = null,
        CancellationToken ct = default);
}

public sealed class ProcessRunner : IProcessRunner
{
    public async Task<ProcessResult> RunAsync(
        string fileName, IReadOnlyList<string> arguments,
        TimeSpan? timeout = null, string? workingDirectory = null,
        CancellationToken ct = default)
    {
        var startInfo = new ProcessStartInfo
        {
            FileName = fileName,
            CreateNoWindow = true,
            UseShellExecute = false,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            StandardOutputEncoding = Encoding.UTF8,
            StandardErrorEncoding = Encoding.UTF8,
            WorkingDirectory = workingDirectory ?? string.Empty,
        };
        foreach (var arg in arguments) startInfo.ArgumentList.Add(arg);

        using var process = new Process { StartInfo = startInfo, EnableRaisingEvents = true };

        try
        {
            if (!process.Start()) return ProcessResult.Error;
        }
        catch
        {
            // exe not found, access denied, etc. — Flutter版 defaultError() 相当
            return ProcessResult.Error;
        }

        var stdOutTask = process.StandardOutput.ReadToEndAsync(ct);
        var stdErrTask = process.StandardError.ReadToEndAsync(ct);

        using var timeoutCts = timeout is { } t ? new CancellationTokenSource(t) : null;
        using var linkedCts = timeoutCts is null
            ? null
            : CancellationTokenSource.CreateLinkedTokenSource(ct, timeoutCts.Token);
        var waitToken = linkedCts?.Token ?? ct;

        try
        {
            await process.WaitForExitAsync(waitToken).ConfigureAwait(false);
        }
        catch (OperationCanceledException)
        {
            KillProcessTree(process);
            if (timeoutCts?.IsCancellationRequested == true) return ProcessResult.Timeout;
            throw; // caller-supplied ct cancellation propagates as-is
        }

        var stdOut = await stdOutTask.ConfigureAwait(false);
        var stdErr = await stdErrTask.ConfigureAwait(false);
        return new ProcessResult(process.ExitCode, stdOut, stdErr, false);
    }

    private static void KillProcessTree(Process process)
    {
        try { process.Kill(entireProcessTree: true); }
        catch { /* process may have already exited */ }
    }
}
