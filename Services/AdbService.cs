using WsaPacman.Services.Core;

namespace WsaPacman.Services;

/// <summary>内部処理設計書 §2.5. adb.exe ラッパー。全経路で埋め込みadb（WsaEnvironment.AdbPath）を使用する。</summary>
public interface IAdbService
{
    string DeviceName { get; }

    Task<ProcessResult> DevicesAsync(CancellationToken ct = default);
    Task<ProcessResult> ConnectAsync(string ipAddress, int port, TimeSpan? timeout = null, CancellationToken ct = default);
    Task<ProcessResult> DisconnectAsync(string ipAddress, int port, CancellationToken ct = default);
    Task<ProcessResult> ShellAsync(string ipAddress, int port, string command, TimeSpan? timeout = null, CancellationToken ct = default);
    Task<ProcessResult> InstallAsync(string ipAddress, int port, string apkPath, bool downgrade = false, TimeSpan? timeout = null, CancellationToken ct = default);
    Task<ProcessResult> InstallMultipleAsync(string ipAddress, int port, IReadOnlyList<string> apkPaths, bool downgrade = false, TimeSpan? timeout = null, CancellationToken ct = default);
    Task<ProcessResult> UninstallAsync(string ipAddress, int port, string package, TimeSpan? timeout = null, CancellationToken ct = default);
    Task<ProcessResult> PushAsync(string ipAddress, int port, string localPath, string remotePath, CancellationToken ct = default);
    Task<ProcessResult> KillServerAsync(CancellationToken ct = default);

    /// <summary>
    /// pm生存確認によるboot完了待機（§4.1 STEP 3 のループを共通化）。
    /// 2秒間隔 × 60回 = 120秒。各試行は 5秒タイムアウト。
    /// </summary>
    Task<bool> WaitForBootCompletedAsync(string ipAddress, int port,
        bool checkBootProp,
        IProgress<int>? attemptProgress = null, CancellationToken ct = default);
}

public sealed class AdbService(IProcessRunner processRunner, IWsaEnvironment environment, ISettingsService settings)
    : IAdbService
{
    private static readonly TimeSpan AttemptTimeout = TimeSpan.FromSeconds(5);
    private static readonly TimeSpan RetryInterval = TimeSpan.FromSeconds(2);
    private const int MaxBootAttempts = 60; // 60 * 2s = 120s

    public string DeviceName => $"{settings.Current.IpAddress}:{settings.Current.Port}";

    public Task<ProcessResult> DevicesAsync(CancellationToken ct = default) =>
        processRunner.RunAsync(environment.AdbPath, ["devices"], ct: ct);

    public Task<ProcessResult> ConnectAsync(string ipAddress, int port, TimeSpan? timeout = null, CancellationToken ct = default) =>
        processRunner.RunAsync(environment.AdbPath, ["connect", $"{ipAddress}:{port}"], timeout, ct: ct);

    public Task<ProcessResult> DisconnectAsync(string ipAddress, int port, CancellationToken ct = default) =>
        processRunner.RunAsync(environment.AdbPath, ["disconnect", $"{ipAddress}:{port}"], ct: ct);

    public Task<ProcessResult> ShellAsync(string ipAddress, int port, string command, TimeSpan? timeout = null, CancellationToken ct = default)
    {
        var args = new List<string> { "-s", $"{ipAddress}:{port}", "shell" };
        args.AddRange(command.Split(' ', StringSplitOptions.RemoveEmptyEntries));
        return processRunner.RunAsync(environment.AdbPath, args, timeout, ct: ct);
    }

    public Task<ProcessResult> InstallAsync(string ipAddress, int port, string apkPath, bool downgrade = false, TimeSpan? timeout = null, CancellationToken ct = default)
    {
        var args = new List<string> { "-s", $"{ipAddress}:{port}", "install" };
        if (downgrade) args.AddRange(["-r", "-d"]);
        args.Add(apkPath);
        return processRunner.RunAsync(environment.AdbPath, args, timeout, ct: ct);
    }

    public Task<ProcessResult> InstallMultipleAsync(string ipAddress, int port, IReadOnlyList<string> apkPaths, bool downgrade = false, TimeSpan? timeout = null, CancellationToken ct = default)
    {
        var args = new List<string> { "-s", $"{ipAddress}:{port}", "install-multiple" };
        if (downgrade) args.AddRange(["-r", "-d"]);
        args.AddRange(apkPaths);
        return processRunner.RunAsync(environment.AdbPath, args, timeout, ct: ct);
    }

    public Task<ProcessResult> UninstallAsync(string ipAddress, int port, string package, TimeSpan? timeout = null, CancellationToken ct = default) =>
        processRunner.RunAsync(environment.AdbPath, ["-s", $"{ipAddress}:{port}", "uninstall", package], timeout, ct: ct);

    public Task<ProcessResult> PushAsync(string ipAddress, int port, string localPath, string remotePath, CancellationToken ct = default) =>
        processRunner.RunAsync(environment.AdbPath, ["-s", $"{ipAddress}:{port}", "push", localPath, remotePath], ct: ct);

    public Task<ProcessResult> KillServerAsync(CancellationToken ct = default) =>
        processRunner.RunAsync(environment.AdbPath, ["kill-server"], ct: ct);

    public async Task<bool> WaitForBootCompletedAsync(string ipAddress, int port,
        bool checkBootProp,
        IProgress<int>? attemptProgress = null, CancellationToken ct = default)
    {
        for (var attempt = 1; attempt <= MaxBootAttempts; attempt++)
        {
            ct.ThrowIfCancellationRequested();
            attemptProgress?.Report(attempt);

            if (checkBootProp)
            {
                var bootProp = await ShellAsync(ipAddress, port, "getprop sys.boot_completed", AttemptTimeout, ct)
                    .ConfigureAwait(false);
                if (bootProp.ExitCode != 0 || bootProp.StdOut.Trim() != "1")
                {
                    await Task.Delay(RetryInterval, ct).ConfigureAwait(false);
                    continue;
                }
            }

            var pmPath = await ShellAsync(ipAddress, port, "pm path android", AttemptTimeout, ct)
                .ConfigureAwait(false);
            if (pmPath.ExitCode == 0 && pmPath.StdOut.Contains("package:"))
            {
                return true;
            }

            await Task.Delay(RetryInterval, ct).ConfigureAwait(false);
        }
        return false;
    }
}
