using System.Xml.Linq;
using Microsoft.Win32;
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

    private readonly Lazy<string> _wsaSystemPath;
    public string WsaSystemPath => _wsaSystemPath.Value;

    public bool IsWsaInstalled => File.Exists(Path.Combine(WsaSystemPath, "AppxManifest.xml"));

    private readonly Lazy<string> _wsaFamilyName;
    public string WsaFamilyName => _wsaFamilyName.Value;

    private readonly Lazy<string> _wsaClientAppId;
    public string WsaClientAppId => _wsaClientAppId.Value;

    public bool IsWindows11OrGreater => Environment.OSVersion.Version.Build >= 22000;

    public WsaEnvironment()
    {
        _toolsDir = new Lazy<string>(ResolveToolsDir);
        _adbPath = new Lazy<string>(() => Path.Combine(ToolsDir, "adb.exe"));
        _wsaSystemPath = new Lazy<string>(ResolveWsaSystemPath);
        _wsaFamilyName = new Lazy<string>(ResolveFamilyName);
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

    private static string ResolveWsaSystemPath()
    {
        try
        {
            using var key = Registry.LocalMachine.OpenSubKey(
                @"SYSTEM\CurrentControlSet\Services\WsaService");
            var imagePath = key?.GetValue("ImagePath") as string;
            if (!string.IsNullOrEmpty(imagePath))
            {
                var exeDir = Path.GetDirectoryName(imagePath.Trim('"'));
                // Strip two more path segments to reach the WSA package install root.
                var systemRoot = Directory.GetParent(exeDir ?? "")?.Parent?.FullName;
                if (!string.IsNullOrEmpty(systemRoot)) return systemRoot;
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

    private static string ResolveFamilyName()
    {
        try
        {
            var pm = new PackageManager();
            var pkg = pm.FindPackagesForUser(string.Empty)
                .FirstOrDefault(p => p.Id.Name.Contains(
                    "WindowsSubsystemForAndroid", StringComparison.OrdinalIgnoreCase));
            return pkg?.Id.FamilyName ?? KnownFamilyName;
        }
        catch
        {
            return KnownFamilyName;
        }
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
