using Microsoft.UI.Xaml;
using WsaPacman.Models;

namespace WsaPacman.Services;

/// <summary>7段階のアクセントパレット（theme.dart のグラデーション生成を踏襲）。</summary>
public sealed record AccentPalette(
    Windows.UI.Color Lightest,
    Windows.UI.Color Lighter,
    Windows.UI.Color Light,
    Windows.UI.Color Normal,
    Windows.UI.Color Dark,
    Windows.UI.Color Darker,
    Windows.UI.Color Darkest);

/// <summary>内部処理設計書 §2.4. アクセントカラー算出・テーマ切替の通知（永続化はSettingsServiceに委譲）。</summary>
public interface IThemeService
{
    ElementTheme CurrentTheme { get; }
    Windows.UI.Color? CustomAccentColor { get; }
    event EventHandler? ThemeChanged;

    void SetTheme(AppTheme theme);
    void SetAccentColor(Windows.UI.Color? color);
    AccentPalette BuildPalette(Windows.UI.Color baseColor);
    Windows.UI.Color GetSystemAccentColor();

    /// <summary>
    /// 実際に適用すべきアクセント色。CustomAccentColorがあればそれを、
    /// 無ければ既定色 Alpine Landing（Dark: #167C80 / Light: #1C9EA0）を返す。
    /// IThemeServiceのシグネチャ案（§2.4）には無いが、適用側で毎回同じ既定色分岐を
    /// 書かずに済むよう追加した小さなヘルパー。
    /// </summary>
    Windows.UI.Color GetEffectiveAccentColor(ElementTheme resolvedTheme);
}

public sealed class ThemeService : IThemeService
{
    // Alpine Landing（theme.dart踏襲）
    private static readonly Windows.UI.Color DefaultAccentDark = Windows.UI.Color.FromArgb(0xFF, 0x16, 0x7C, 0x80);
    private static readonly Windows.UI.Color DefaultAccentLight = Windows.UI.Color.FromArgb(0xFF, 0x1C, 0x9E, 0xA0);

    private readonly ISettingsService _settings;

    public event EventHandler? ThemeChanged;

    public ThemeService(ISettingsService settings)
    {
        _settings = settings;
        // Mica等ThemeService経由でない設定変更も含め、可視化に関わる変更は
        // すべてここを起点にWindow側へ通知する（§6.5「ThemeService.ThemeChangedを各Windowが購読」）。
        _settings.SettingsChanged += (_, _) => ThemeChanged?.Invoke(this, EventArgs.Empty);
    }

    public ElementTheme CurrentTheme => _settings.Current.Theme switch
    {
        AppTheme.Light => ElementTheme.Light,
        AppTheme.Dark => ElementTheme.Dark,
        _ => ElementTheme.Default,
    };

    public Windows.UI.Color? CustomAccentColor => ParseHexColor(_settings.Current.AccentColor);

    public void SetTheme(AppTheme theme) => _settings.Update(s => s.Theme = theme);

    public void SetAccentColor(Windows.UI.Color? color) =>
        _settings.Update(s => s.AccentColor = color is { } c ? ToHexColor(c) : null);

    public Windows.UI.Color GetSystemAccentColor() =>
        new Windows.UI.ViewManagement.UISettings().GetColorValue(Windows.UI.ViewManagement.UIColorType.Accent);

    public Windows.UI.Color GetEffectiveAccentColor(ElementTheme resolvedTheme) =>
        CustomAccentColor ?? (resolvedTheme == ElementTheme.Light ? DefaultAccentLight : DefaultAccentDark);

    public AccentPalette BuildPalette(Windows.UI.Color baseColor)
    {
        var (h, s, v) = RgbToHsv(baseColor);
        Windows.UI.Color Shift(double dv) => HsvToRgb(h, s, Math.Clamp(v + dv, 0, 1), baseColor.A);

        return new AccentPalette(
            Lightest: Shift(0.3),
            Lighter: Shift(0.2),
            Light: Shift(0.1),
            Normal: baseColor,
            Dark: Shift(-0.1),
            Darker: Shift(-0.2),
            Darkest: Shift(-0.3));
    }

    private static string ToHexColor(Windows.UI.Color c) => $"#{c.A:X2}{c.R:X2}{c.G:X2}{c.B:X2}";

    private static Windows.UI.Color? ParseHexColor(string? hex)
    {
        if (string.IsNullOrEmpty(hex)) return null;
        var s = hex.TrimStart('#');
        if (s.Length != 8 || !uint.TryParse(s, System.Globalization.NumberStyles.HexNumber, null, out var argb))
        {
            return null;
        }
        return Windows.UI.Color.FromArgb(
            (byte)(argb >> 24), (byte)(argb >> 16), (byte)(argb >> 8), (byte)argb);
    }

    private static (double H, double S, double V) RgbToHsv(Windows.UI.Color c)
    {
        double r = c.R / 255.0, g = c.G / 255.0, b = c.B / 255.0;
        double max = Math.Max(r, Math.Max(g, b));
        double min = Math.Min(r, Math.Min(g, b));
        double delta = max - min;

        double h = 0;
        if (delta > 0)
        {
            if (max == r) h = 60 * (((g - b) / delta) % 6);
            else if (max == g) h = 60 * (((b - r) / delta) + 2);
            else h = 60 * (((r - g) / delta) + 4);
            if (h < 0) h += 360;
        }

        var s = max <= 0 ? 0 : delta / max;
        return (h, s, max);
    }

    private static Windows.UI.Color HsvToRgb(double h, double s, double v, byte alpha)
    {
        var c = v * s;
        var x = c * (1 - Math.Abs(h / 60.0 % 2 - 1));
        var m = v - c;
        var (r1, g1, b1) = h switch
        {
            < 60 => (c, x, 0.0),
            < 120 => (x, c, 0.0),
            < 180 => (0.0, c, x),
            < 240 => (0.0, x, c),
            < 300 => (x, 0.0, c),
            _ => (c, 0.0, x),
        };
        return Windows.UI.Color.FromArgb(
            alpha,
            (byte)Math.Round((r1 + m) * 255),
            (byte)Math.Round((g1 + m) * 255),
            (byte)Math.Round((b1 + m) * 255));
    }
}
