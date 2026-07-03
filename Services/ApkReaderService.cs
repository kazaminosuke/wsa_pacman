using System.IO.Compression;
using System.Text.RegularExpressions;
using WsaPacman.Models;
using WsaPacman.Services.Core;

namespace WsaPacman.Services;

/// <summary>
/// APKメタデータ抽出（ユーザー承認方針: 本格的なAndroidマニフェスト/ARSCパーサーの自前実装はせず、
/// Flutter版 reader_apk.dart と同じく embedded-tools\aapt.exe を外部プロセスとして呼び出す）。
/// パッケージ名・バージョン・表示名・パーミッション一覧・アイコン画像を取得する。
/// アイコンは aapt が解決済みの application-icon-&lt;dpi&gt; ラスター画像のみを対象とし、
/// アダプティブアイコン(XML)やresources.arscの解決は範囲外（設計書§7-12）。
/// </summary>
public interface IApkReaderService
{
    Task<ApkInfo> ReadAsync(string apkPath, CancellationToken ct = default);
}

public sealed class ApkReaderService(IProcessRunner processRunner, IWsaEnvironment environment) : IApkReaderService
{
    private static readonly TimeSpan AaptTimeout = TimeSpan.FromSeconds(30);

    private static readonly Regex VersionCodeRegex = new(@"versionCode='(\d+)'");
    private static readonly Regex VersionNameRegex = new(@"versionName='([^']*)'");
    private static readonly Regex PackageNameRegex = new(@"name='([^']*)'");
    private static readonly Regex LabelRegex = new(@"label='([^']*)'");
    private static readonly Regex IconRegex = new(@"icon='([^']*)'");
    private static readonly Regex ApplicationLabelRegex = new(@"application-label:'([^']*)'");
    private static readonly Regex DensityIconRegex = new(@"application-icon-(\d+):'([^']*)'");
    private static readonly Regex PermissionRegex =
        new(@"uses-permission(?:-[\w-]*)?:\s*name=['""]([^'""]*)['""]");

    public async Task<ApkInfo> ReadAsync(string apkPath, CancellationToken ct = default)
    {
        var result = await processRunner
            .RunAsync(environment.AaptPath, ["dump", "badging", apkPath], AaptTimeout, ct: ct)
            .ConfigureAwait(false);
        if (result.IsTimeout)
        {
            throw new ApkReadException("AAPT_TIMEOUT", "APK情報の解析がタイムアウトしました。");
        }
        if (result.ExitCode != 0)
        {
            var message = string.IsNullOrWhiteSpace(result.StdErr)
                ? $"aapt dump badging failed (exit {result.ExitCode})"
                : result.StdErr.Trim();
            throw new ApkReadException($"AAPT_ERR ({result.ExitCode})", message);
        }

        var dump = result.StdOut;
        var lines = dump.Split('\n');

        var packageLine = lines.FirstOrDefault(l => l.TrimStart().StartsWith("package:")) ?? "";
        var package = PackageNameRegex.Match(packageLine) is { Success: true } pm ? pm.Groups[1].Value : "";
        if (string.IsNullOrEmpty(package))
        {
            throw new ApkReadException("EMPTY_PKG", "APK内にパッケージ情報が見つかりませんでした。");
        }
        var versionCode = VersionCodeRegex.Match(packageLine) is { Success: true } vcm
            ? int.Parse(vcm.Groups[1].Value) : 0;
        var versionName = VersionNameRegex.Match(packageLine) is { Success: true } vnm
            ? vnm.Groups[1].Value : "";

        var applicationLine = lines.FirstOrDefault(l => l.TrimStart().StartsWith("application:")) ?? "";
        var label = LabelRegex.Match(applicationLine) is { Success: true } lm ? lm.Groups[1].Value : "";
        if (string.IsNullOrEmpty(label))
        {
            var appLabelLine = lines.FirstOrDefault(l => l.TrimStart().StartsWith("application-label:")) ?? "";
            label = ApplicationLabelRegex.Match(appLabelLine) is { Success: true } alm ? alm.Groups[1].Value : "";
        }
        if (string.IsNullOrEmpty(label)) label = Path.GetFileNameWithoutExtension(apkPath);

        var permissionNames = PermissionRegex.Matches(dump).Select(m => m.Groups[1].Value);
        var permissions = AndroidPermissionMap.FromNames(permissionNames);

        byte[]? icon;
        try
        {
            icon = ExtractIcon(lines, applicationLine, apkPath);
        }
        catch
        {
            // Best effort — a missing/unreadable icon falls back to the placeholder glyph already in the XAML.
            icon = null;
        }

        return new ApkInfo(package, versionCode, versionName, label, permissions, icon);
    }

    private static byte[]? ExtractIcon(string[] lines, string applicationLine, string apkPath)
    {
        // Prefer aapt's per-density resolved raster paths, skipping the adaptive-icon XML entry
        // (usually reported at the "anydpi" pseudo-density) — resolving @mipmap/@drawable via
        // resources.arsc is intentionally out of scope.
        var bestRaster = lines
            .Select(l => DensityIconRegex.Match(l))
            .Where(m => m.Success && !m.Groups[2].Value.EndsWith(".xml", StringComparison.OrdinalIgnoreCase))
            .Select(m => (Density: int.Parse(m.Groups[1].Value), Path: m.Groups[2].Value))
            .OrderByDescending(c => c.Density)
            .Select(c => c.Path)
            .FirstOrDefault();

        var iconPath = bestRaster;
        if (string.IsNullOrEmpty(iconPath))
        {
            var fallback = IconRegex.Match(applicationLine) is { Success: true } im ? im.Groups[1].Value : "";
            if (!fallback.EndsWith(".xml", StringComparison.OrdinalIgnoreCase)) iconPath = fallback;
        }
        if (string.IsNullOrEmpty(iconPath)) return null;

        using var archive = ZipFile.OpenRead(apkPath);
        var entry = archive.GetEntry(iconPath);
        if (entry is null) return null;

        using var stream = entry.Open();
        using var buffer = new MemoryStream();
        stream.CopyTo(buffer);
        return buffer.ToArray();
    }
}
