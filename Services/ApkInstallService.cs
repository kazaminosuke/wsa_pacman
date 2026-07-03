using System.Text.RegularExpressions;
using WsaPacman.Models;
using WsaPacman.Services.Core;

namespace WsaPacman.Services;

/// <summary>内部処理設計書 §2.11 / §4.1. APKインストールのフルフロー（Flutter版 ApkInstaller.installApk 完全踏襲）。</summary>
public sealed record InstallProgress(InstallState State, string? ErrorCode = null, string? ErrorDescription = null);

public interface IApkInstallService
{
    Task<InstallProgress> InstallAsync(
        string apkPath, string package, string displayName,
        bool downgrade, IProgress<InstallProgress>? progress = null,
        CancellationToken ct = default);
}

public sealed class ApkInstallService(
    IAdbService adb, IWsaClientService wsaClient, IWsaStatusService wsaStatus,
    ISettingsService settings, IRegistryService registry) : IApkInstallService
{
    private static readonly TimeSpan InstallTimeout = TimeSpan.FromSeconds(300);
    private static readonly Regex InstallFailureRegex = new(
        @"adb:\s+failed\s+to\s+install\s+.*:\s+Failure\s+\[([^:]*):\s*(.+?)\s*\]",
        RegexOptions.Singleline);

    public async Task<InstallProgress> InstallAsync(
        string apkPath, string package, string displayName,
        bool downgrade, IProgress<InstallProgress>? progress = null,
        CancellationToken ct = default)
    {
        // STEP 0
        progress?.Report(new InstallProgress(InstallState.Installing));

        // STEP 1
        if (wsaStatus.Current.Status != ConnectionStatus.Connected)
        {
            wsaClient.Launch();
            wsaStatus.NotifyWsaStartRequested();
        }

        // STEP 2
        var ip = settings.Current.IpAddress;
        var port = settings.Current.Port;

        // STEP 3
        var bootCompleted = await adb
            .WaitForBootCompletedAsync(ip, port, checkBootProp: true, ct: ct)
            .ConfigureAwait(false);
        if (!bootCompleted)
        {
            var timeoutResult = new InstallProgress(
                InstallState.Error, "WSA_BOOT_TIMEOUT", LocalizedStrings.Instance.installer_error_boot_timeout);
            progress?.Report(timeoutResult);
            return timeoutResult;
        }

        // STEP 4
        var installResult = await adb
            .InstallAsync(ip, port, apkPath, downgrade, InstallTimeout, ct)
            .ConfigureAwait(false);

        // STEP 5
        InstallProgress result;
        if (installResult.ExitCode == 0)
        {
            result = new InstallProgress(InstallState.Success);
            try
            {
                registry.RegisterUninstallEntry(
                    package, displayName, $"\"{Environment.ProcessPath}\" --uninstall \"{package}\"");
            }
            catch
            {
                // Registration failure is swallowed — the install itself already succeeded (Flutter版踏襲).
            }
        }
        else if (installResult.IsTimeout)
        {
            result = new InstallProgress(
                InstallState.Timeout, "TIMEOUT", LocalizedStrings.Instance.installer_error_timeout);
        }
        else
        {
            var match = InstallFailureRegex.Match(installResult.StdErr);
            if (match.Success)
            {
                var errorCode = match.Groups[1].Value;
                var errorDesc = match.Groups[2].Value;
                result = new InstallProgress(
                    InstallState.Error,
                    string.IsNullOrEmpty(errorCode) ? "UNKNOWN_ERROR" : errorCode,
                    string.IsNullOrEmpty(errorDesc) ? LocalizedStrings.Instance.installer_error_nomsg : errorDesc);
            }
            else
            {
                var stderr = installResult.StdErr.Trim();
                result = new InstallProgress(
                    InstallState.Error,
                    $"INSTALL_ERROR (Exit: {installResult.ExitCode})",
                    stderr.Length > 0 ? stderr : LocalizedStrings.Instance.installer_error_nomsg);
            }
        }

        progress?.Report(result);
        return result;
    }
}
