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
}
