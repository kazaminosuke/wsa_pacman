using System.Text.RegularExpressions;
using Microsoft.Win32;
using WsaPacman.Services.Core;

namespace WsaPacman.Services;

/// <summary>内部処理設計書 §2.8. HKCU Uninstallキーの読み書き・列挙・.regエクスポート。</summary>
public sealed record UninstallEntry(
    string Package, string? DisplayName, string? DisplayIcon,
    string? UninstallString, string? QuietUninstallString, string? ModifyPath);

public interface IRegistryService
{
    void RegisterUninstallEntry(string package, string displayName, string uninstallCommand);
    void SetUninstallStrings(string package, string command);
    UninstallEntry? GetUninstallEntry(string package);
    void DeleteUninstallEntry(string package);
    IReadOnlyList<UninstallEntry> EnumerateWsaEntries();
    IReadOnlyList<UninstallEntry> EnumeratePacmanEntries();

    Task<ProcessResult> ExportKeyAsync(string package, string outputRegPath, CancellationToken ct = default);
    Task<ProcessResult> ExportAllUninstallAsync(string outputRegPath, CancellationToken ct = default);
}

public sealed class RegistryService(IProcessRunner processRunner) : IRegistryService
{
    private const string UninstallRoot = @"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall";

    // sync_apps.dart / app_manager.dart 踏襲の検出条件（正規表現）
    private static readonly Regex WsaClientExeRegex =
        new(@"WsaClient\.exe", RegexOptions.IgnoreCase);
    private static readonly Regex WsaPublisherRegex =
        new("Windows Subsystem for Android", RegexOptions.IgnoreCase);
    private static readonly Regex WsaFamilyRegex =
        new(@"MicrosoftCorporationII\.WindowsSubsystemForAndroid", RegexOptions.IgnoreCase);
    private static readonly Regex PacmanExeRegex =
        new(@"WSA-pacman\.exe", RegexOptions.IgnoreCase);

    public void RegisterUninstallEntry(string package, string displayName, string uninstallCommand)
    {
        using var key = Registry.CurrentUser.CreateSubKey($@"{UninstallRoot}\{package}");
        key.SetValue("DisplayName", displayName, RegistryValueKind.String);
        key.SetValue("UninstallString", uninstallCommand, RegistryValueKind.String);
        key.SetValue("QuietUninstallString", uninstallCommand, RegistryValueKind.String);
    }

    public void SetUninstallStrings(string package, string command)
    {
        using var key = Registry.CurrentUser.CreateSubKey($@"{UninstallRoot}\{package}");
        key.SetValue("UninstallString", command, RegistryValueKind.String);
        key.SetValue("QuietUninstallString", command, RegistryValueKind.String);
    }

    public UninstallEntry? GetUninstallEntry(string package)
    {
        using var key = Registry.CurrentUser.OpenSubKey($@"{UninstallRoot}\{package}");
        return key is null ? null : ReadEntry(package, key);
    }

    public void DeleteUninstallEntry(string package) =>
        Registry.CurrentUser.DeleteSubKeyTree($@"{UninstallRoot}\{package}", throwOnMissingSubKey: false);

    public IReadOnlyList<UninstallEntry> EnumerateWsaEntries() =>
        EnumerateFiltered(key =>
            WsaClientExeRegex.IsMatch(key.GetValue("UninstallString") as string ?? "")
            || WsaPublisherRegex.IsMatch(key.GetValue("Publisher") as string ?? "")
            || WsaFamilyRegex.IsMatch(key.GetValue("DisplayIcon") as string ?? ""));

    public IReadOnlyList<UninstallEntry> EnumeratePacmanEntries() =>
        EnumerateFiltered(key =>
            PacmanExeRegex.IsMatch(key.GetValue("UninstallString") as string ?? "")
            || PacmanExeRegex.IsMatch(key.GetValue("QuietUninstallString") as string ?? ""));

    private static IReadOnlyList<UninstallEntry> EnumerateFiltered(Func<RegistryKey, bool> predicate)
    {
        using var root = Registry.CurrentUser.OpenSubKey(UninstallRoot);
        if (root is null) return [];

        var results = new List<UninstallEntry>();
        foreach (var package in root.GetSubKeyNames())
        {
            using var key = root.OpenSubKey(package);
            if (key is null) continue;
            try
            {
                if (predicate(key)) results.Add(ReadEntry(package, key));
            }
            catch
            {
                // A single unreadable/malformed subkey must not abort the whole scan.
            }
        }
        return results;
    }

    private static UninstallEntry ReadEntry(string package, RegistryKey key) => new(
        package,
        key.GetValue("DisplayName") as string,
        key.GetValue("DisplayIcon") as string,
        key.GetValue("UninstallString") as string,
        key.GetValue("QuietUninstallString") as string,
        key.GetValue("ModifyPath") as string);

    public Task<ProcessResult> ExportKeyAsync(string package, string outputRegPath, CancellationToken ct = default) =>
        processRunner.RunAsync("reg.exe", ["export", $@"HKCU\{UninstallRoot}\{package}", outputRegPath, "/y"], ct: ct);

    public Task<ProcessResult> ExportAllUninstallAsync(string outputRegPath, CancellationToken ct = default) =>
        processRunner.RunAsync("reg.exe", ["export", $@"HKCU\{UninstallRoot}", outputRegPath, "/y"], ct: ct);
}
