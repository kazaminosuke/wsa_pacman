using System.Runtime.InteropServices;
using WsaPacman.Services.Core;

namespace WsaPacman.Services;

/// <summary>内部処理設計書 §2.6. WsaClient.exe の起動系（ShellExecuteW 直呼び）。</summary>
public interface IWsaClientService
{
    bool Launch(string? param = null);
    bool LaunchApp(string package);
    bool LaunchSettings();
    bool LaunchDeveloperSettings();
    bool Shutdown();
    Task<ProcessResult> KillClientAsync();
}

public sealed class WsaClientService(IWsaEnvironment environment, IProcessRunner processRunner) : IWsaClientService
{
    private const int SW_SHOWNORMAL = 1;

    [DllImport("shell32.dll", CharSet = CharSet.Unicode, SetLastError = true)]
    private static extern IntPtr ShellExecuteW(
        IntPtr hwnd, string? lpOperation, string lpFile,
        string? lpParameters, string? lpDirectory, int nShowCmd);

    public bool Launch(string? param = null)
    {
        var target = $@"shell:appsFolder\{environment.WsaFamilyName}!{environment.WsaClientAppId}";
        var result = ShellExecuteW(IntPtr.Zero, "open", target, param, null, SW_SHOWNORMAL);
        // Per ShellExecute convention, values > 32 indicate success.
        return result.ToInt64() > 32;
    }

    public bool LaunchApp(string package) => Launch($"/launch wsa://{package}");

    public bool LaunchSettings() => LaunchApp("com.android.settings");

    public bool LaunchDeveloperSettings() => Launch("/deeplink wsa-client://developer-settings");

    public bool Shutdown() => Launch("/shutdown");

    public Task<ProcessResult> KillClientAsync() =>
        processRunner.RunAsync("taskkill", ["/F", "/IM", "WsaClient.exe"]);
}
