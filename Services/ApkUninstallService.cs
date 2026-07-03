namespace WsaPacman.Services;

/// <summary>内部処理設計書 §2.11 / §4.2. アンインストールのフルフロー（Flutter版 _uninstallApp 完全踏襲）。</summary>
public enum UninstallPhase { BackingUp, StartingWsa, WaitingBoot, Uninstalling, CleaningRegistry, RemovingShortcuts, Done, Failed }

public sealed record UninstallProgress(UninstallPhase Phase, string? Message = null);

public interface IApkUninstallService
{
    /// <summary>確認画面表示用（DisplayName / DisplayIcon）。</summary>
    Task<UninstallEntry?> GetAppInfoAsync(string package);

    Task<bool> UninstallAsync(
        string package, string displayName,
        IProgress<UninstallProgress>? progress = null, CancellationToken ct = default);
}

public sealed class ApkUninstallService(
    IAdbService adb, IWsaClientService wsaClient, IWsaStatusService wsaStatus,
    ISettingsService settings, IRegistryService registry, IShortcutService shortcut) : IApkUninstallService
{
    private static readonly TimeSpan UninstallTimeout = TimeSpan.FromSeconds(30);

    public Task<UninstallEntry?> GetAppInfoAsync(string package) =>
        Task.FromResult(registry.GetUninstallEntry(package));

    public async Task<bool> UninstallAsync(
        string package, string displayName,
        IProgress<UninstallProgress>? progress = null, CancellationToken ct = default)
    {
        // STEP 0: レジストリバックアップ
        progress?.Report(new UninstallProgress(UninstallPhase.BackingUp));
        if (settings.Current.AutoBackupRegistry)
        {
            await BackupRegistryAsync(package, ct).ConfigureAwait(false);
        }

        // STEP 1: WSA起動
        progress?.Report(new UninstallProgress(UninstallPhase.StartingWsa));
        wsaClient.Launch();
        wsaStatus.NotifyWsaStartRequested();

        // STEP 2
        var ip = settings.Current.IpAddress;
        var port = settings.Current.Port;

        // STEP 3: ブート完了待機（installと異なりgetprop確認はしない、pmのみ — §7-9）
        progress?.Report(new UninstallProgress(UninstallPhase.WaitingBoot));
        var bootCompleted = await adb
            .WaitForBootCompletedAsync(ip, port, checkBootProp: false, ct: ct)
            .ConfigureAwait(false);
        if (!bootCompleted)
        {
            progress?.Report(new UninstallProgress(
                UninstallPhase.Failed, LocalizedStrings.Instance.installer_error_boot_timeout));
            return false;
        }

        // STEP 4: ADBアンインストール（失敗してもSTEP5-6は必ず実行する）
        progress?.Report(new UninstallProgress(UninstallPhase.Uninstalling));
        var uninstallResult = await adb
            .UninstallAsync(ip, port, package, UninstallTimeout, ct)
            .ConfigureAwait(false);

        // STEP 5: レジストリ削除
        progress?.Report(new UninstallProgress(UninstallPhase.CleaningRegistry));
        registry.DeleteUninstallEntry(package);

        // STEP 6: ショートカット削除
        progress?.Report(new UninstallProgress(UninstallPhase.RemovingShortcuts));
        shortcut.DeleteStartMenuShortcuts(displayName);

        // STEP 7
        var success = uninstallResult.ExitCode == 0;
        progress?.Report(new UninstallProgress(
            UninstallPhase.Done,
            success ? LocalizedStrings.Instance.uninstaller_status_success : LocalizedStrings.Instance.uninstaller_status_errors));
        return success;
    }

    private async Task BackupRegistryAsync(string package, CancellationToken ct)
    {
        var savedDir = settings.Current.BackupDirectory;
        if (string.IsNullOrWhiteSpace(savedDir) || !Directory.Exists(savedDir))
        {
            savedDir = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
        }

        var timestamp = DateTime.Now.ToString("yyyyMMdd_HHmmss");
        var backupPath = Path.Combine(savedDir, $"wsa_pacman_{package}_backup_{timestamp}.reg");
        try
        {
            await registry.ExportKeyAsync(package, backupPath, ct).ConfigureAwait(false);
        }
        catch
        {
            // Best effort — a failed backup must not block the uninstall itself.
        }
    }
}
