using WsaPacman.Models;

namespace WsaPacman.Services;

/// <summary>内部処理設計書 §2.10. インストール済みアプリのスキャン（レジストリ + adb pm list）。</summary>
public interface IInstalledAppsService
{
    /// <summary>レジストリスキャン + adb `pm list packages -3` をマージ（重複はレジストリ優先）。</summary>
    Task<IReadOnlyList<InstalledApp>> ScanAsync(CancellationToken ct = default);
}

public sealed class InstalledAppsService(IRegistryService registry, IAdbService adb, ISettingsService settings)
    : IInstalledAppsService
{
    public async Task<IReadOnlyList<InstalledApp>> ScanAsync(CancellationToken ct = default)
    {
        var results = new List<InstalledApp>();
        var knownPackages = new HashSet<string>();

        foreach (var entry in registry.EnumerateWsaEntries())
        {
            knownPackages.Add(entry.Package);
            results.Add(new InstalledApp(
                entry.Package,
                string.IsNullOrEmpty(entry.DisplayName) ? entry.Package : entry.DisplayName,
                InstalledAppSource.Registry,
                entry.UninstallString,
                entry.DisplayIcon));
        }

        try
        {
            var ip = settings.Current.IpAddress;
            var port = settings.Current.Port;
            var pmResult = await adb.ShellAsync(ip, port, "pm list packages -3", ct: ct).ConfigureAwait(false);
            if (pmResult.ExitCode == 0)
            {
                foreach (var line in pmResult.StdOut.Split('\n'))
                {
                    var trimmed = line.Trim();
                    if (!trimmed.StartsWith("package:")) continue;
                    var package = trimmed["package:".Length..].Trim();
                    if (package.Length == 0 || knownPackages.Contains(package)) continue;

                    results.Add(new InstalledApp(package, package, InstalledAppSource.AdbOnly, null, null));
                }
            }
        }
        catch
        {
            // adb失敗時はレジストリ結果のみ返す（Flutter版 app_manager.dart 踏襲）。
        }

        return results;
    }
}
