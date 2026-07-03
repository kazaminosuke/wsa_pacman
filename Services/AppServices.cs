using WsaPacman.Services.Core;

namespace WsaPacman.Services;

/// <summary>
/// プロセス内シングルトンの集約点。プロジェクトはDIコンテナを使わず
/// 既存の LocalizedStrings.Instance パターンに合わせているため、
/// この静的クラスが簡易的な合成ルートを兼ねる。
/// </summary>
public static class AppServices
{
    public static ISettingsService Settings { get; } = new SettingsService();
    public static IThemeService Theme { get; } = new ThemeService(Settings);
    public static IWsaEnvironment WsaEnvironment { get; } = new WsaEnvironment();

    private static readonly IProcessRunner ProcessRunner = new ProcessRunner();

    public static IAdbService Adb { get; } = new AdbService(ProcessRunner, WsaEnvironment, Settings);
    public static IWsaClientService WsaClient { get; } = new WsaClientService(WsaEnvironment, ProcessRunner);
    public static IWsaStatusService WsaStatus { get; } = new WsaStatusService(Adb, WsaEnvironment, Settings);
    public static IRegistryService Registry { get; } = new RegistryService(ProcessRunner);
    public static IShortcutService Shortcut { get; } = new ShortcutService(WsaEnvironment);
    public static IAppSyncService AppSync { get; } = new AppSyncService(Registry, WsaEnvironment);
    public static IApkReaderService ApkReader { get; } = new ApkReaderService(ProcessRunner, WsaEnvironment);
    public static IApkInstallService ApkInstall { get; } =
        new ApkInstallService(Adb, WsaClient, WsaStatus, Settings, Registry);
    public static IApkUninstallService ApkUninstall { get; } =
        new ApkUninstallService(Adb, WsaClient, WsaStatus, Settings, Registry, Shortcut);
}
