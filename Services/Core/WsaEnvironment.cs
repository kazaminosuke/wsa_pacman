using System.Xml.Linq;
using Microsoft.Win32;
using Windows.ApplicationModel;
using Windows.Management.Deployment;

namespace WsaPacman.Services.Core;

/// <summary>内部処理設計書 §2.2. WSAパッケージ情報・パス類の遅延初期化キャッシュ。</summary>
public interface IWsaEnvironment
{
    string ExecDir { get; }
    string ToolsDir { get; }
    string AdbPath { get; }
    string WsaSystemPath { get; }
    bool IsWsaInstalled { get; }
    string WsaFamilyName { get; }
    string WsaClientAppId { get; }
    bool IsWindows11OrGreater { get; }
}

public sealed class WsaEnvironment : IWsaEnvironment
{
    // Fallback used when PackageManager lookup fails (registry unreadable, package absent, etc.)
    private const string KnownFamilyName =
        "MicrosoftCorporationII.WindowsSubsystemForAndroid_8wekyb3d8bbwe";

    public string ExecDir { get; } = AppContext.BaseDirectory;

    private readonly Lazy<string> _toolsDir;
    public string ToolsDir => _toolsDir.Value;

    private readonly Lazy<string> _adbPath;
    public string AdbPath => _adbPath.Value;

    // PackageManagerでの照会が「インストール有無」の一次情報源。WSAの着脱は常に
    // プロセス外（Store/PowerShell経由）で行われるため、プロセス寿命内でのキャッシュでよい。
    private readonly Lazy<Package?> _wsaPackage;

    private readonly Lazy<string> _wsaSystemPath;
    public string WsaSystemPath => _wsaSystemPath.Value;

    public bool IsWsaInstalled => _wsaPackage.Value is not null;

    private readonly Lazy<string> _wsaFamilyName;
    public string WsaFamilyName => _wsaFamilyName.Value;

    private readonly Lazy<string> _wsaClientAppId;
    public string WsaClientAppId => _wsaClientAppId.Value;

    public bool IsWindows11OrGreater => Environment.OSVersion.Version.Build >= 22000;

    public WsaEnvironment()
    {
        _toolsDir = new Lazy<string>(ResolveToolsDir);
        _adbPath = new Lazy<string>(() => Path.Combine(ToolsDir, "adb.exe"));
        _wsaPackage = new Lazy<Package?>(FindWsaPackage);
        _wsaSystemPath = new Lazy<string>(ResolveWsaSystemPath);
        _wsaFamilyName = new Lazy<string>(() => _wsaPackage.Value?.Id.FamilyName ?? KnownFamilyName);
        _wsaClientAppId = new Lazy<string>(ResolveClientAppId);
    }

    private string ResolveToolsDir()
    {
        const string dirName = "embedded-tools";
        var direct = Path.Combine(ExecDir, dirName);
        if (Directory.Exists(direct)) return direct;

        // Development fallback: walk up from the build output looking for a
        // repo-level embedded-tools folder (e.g. bin\Debug\net10.0-...\win-x64).
        var dir = new DirectoryInfo(ExecDir);
        for (var i = 0; i < 6 && dir is not null; i++, dir = dir.Parent)
        {
            var candidate = Path.Combine(dir.FullName, dirName);
            if (Directory.Exists(candidate)) return candidate;
        }
        return direct;
    }

    private static Package? FindWsaPackage()
    {
        try
        {
            var pm = new PackageManager();
            return pm.FindPackagesForUser(string.Empty)
                .FirstOrDefault(p => p.Id.Name.Contains(
                    "WindowsSubsystemForAndroid", StringComparison.OrdinalIgnoreCase));
        }
        catch
        {
            return null;
        }
    }

    private string ResolveWsaSystemPath()
    {
        // Package.InstalledLocation is the package root (directly contains
        // AppxManifest.xml) — authoritative, unlike guessing folder depth from
        // the WsaService registry ImagePath.
        try
        {
            if (_wsaPackage.Value?.InstalledLocation is { } location && !string.IsNullOrEmpty(location.Path))
            {
                return location.Path;
            }
        }
        catch { /* fall through to the registry-based fallback below */ }

        try
        {
            using var key = Registry.LocalMachine.OpenSubKey(
                @"SYSTEM\CurrentControlSet\Services\WsaService");
            var imagePath = key?.GetValue("ImagePath") as string;
            if (!string.IsNullOrEmpty(imagePath))
            {
                var dir = Path.GetDirectoryName(imagePath.Trim('"'));
                if (!string.IsNullOrEmpty(dir)) return dir;
            }
        }
        catch { /* fall through to the App Paths fallback */ }

        try
        {
            using var appPathKey = Registry.CurrentUser.OpenSubKey(
                @"SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WsaClient.exe");
            var clientExePath = appPathKey?.GetValue(null) as string;
            if (!string.IsNullOrEmpty(clientExePath))
            {
                return Path.GetDirectoryName(clientExePath.Trim('"')) ?? "";
            }
        }
        catch { /* WSA not installed */ }

        return "";
    }

    private string ResolveClientAppId()
    {
        try
        {
            var manifestPath = Path.Combine(WsaSystemPath, "AppxManifest.xml");
            if (!File.Exists(manifestPath)) return "App";

            var doc = XDocument.Load(manifestPath);
            var app = doc.Descendants()
                .Where(e => e.Name.LocalName == "Application")
                .FirstOrDefault(e => (e.Attribute("Executable")?.Value ?? "")
                    .EndsWith("WsaClient.exe", StringComparison.OrdinalIgnoreCase));
            return app?.Attribute("Id")?.Value ?? "App";
        }
        catch
        {
            return "App";
        }
    }
}
