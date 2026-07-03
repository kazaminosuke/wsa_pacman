using Microsoft.UI.Composition.SystemBackdrops;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Media;
using WsaPacman.Models;
using WsaPacman.Services;

namespace WsaPacman;

/// <summary>
/// MainWindow / InstallerWindow / UninstallerWindow の各Windowへ、現在の設定
/// （テーマモード・Mica・アクセントカラー）を反映する共通処理。
/// 内部処理設計書 §6.5「テーマ/Mica/アクセント変更はThemeService.ThemeChangedを
/// 各Windowが購読し、ElementThemeの切替とDWMバックドロップの再適用を行う」に対応。
/// </summary>
internal static class WindowThemeHelper
{
    public static void Apply(Window window)
    {
        var theme = AppServices.Theme.CurrentTheme;

        // Reassigning RequestedTheme / SystemBackdrop even to an unchanged value still
        // forces a re-template pass, which has been observed to reset NavigationView's
        // SelectedItem back to its XAML-declared default. Skip the write when nothing
        // actually changed so unrelated settings changes (e.g. accent color) don't
        // disturb navigation state.
        if (window.Content is FrameworkElement root && root.RequestedTheme != theme)
        {
            root.RequestedTheme = theme;
        }

        // Flutter版のmica_helper.dartはPartialをFullと全く同じ扱いにしている
        // （micaAltフラグのみが分岐点で、Partial専用の処理経路は存在しない）ため、
        // 同じ挙動をそのまま踏襲する。
        var desiredKind = AppServices.Settings.Current.Mica switch
        {
            MicaMode.Disabled => (MicaKind?)null,
            MicaMode.Alt => MicaKind.BaseAlt,
            _ => MicaKind.Base,
        };
        var currentKind = (window.SystemBackdrop as MicaBackdrop)?.Kind;
        var currentlyDisabled = window.SystemBackdrop is null;
        var isUnchanged = desiredKind is null ? currentlyDisabled : currentKind == desiredKind;
        if (!isUnchanged)
        {
            window.SystemBackdrop = desiredKind is { } kind ? new MicaBackdrop { Kind = kind } : null;
        }

        ApplyAccentColor(theme);
    }

    private static void ApplyAccentColor(ElementTheme resolvedTheme)
    {
        var effectiveTheme = resolvedTheme switch
        {
            ElementTheme.Light => ElementTheme.Light,
            ElementTheme.Dark => ElementTheme.Dark,
            _ => IsSystemInDarkMode() ? ElementTheme.Dark : ElementTheme.Light,
        };

        var baseColor = AppServices.Theme.GetEffectiveAccentColor(effectiveTheme);
        var palette = AppServices.Theme.BuildPalette(baseColor);

        var res = Application.Current.Resources;
        if (res.TryGetValue("SystemAccentColor", out var current)
            && current is Windows.UI.Color currentColor && currentColor == palette.Normal)
        {
            return; // already applied; skip the redundant resource-dictionary churn
        }

        res["SystemAccentColor"] = palette.Normal;
        res["SystemAccentColorLight1"] = palette.Light;
        res["SystemAccentColorLight2"] = palette.Lighter;
        res["SystemAccentColorLight3"] = palette.Lightest;
        res["SystemAccentColorDark1"] = palette.Dark;
        res["SystemAccentColorDark2"] = palette.Darker;
        res["SystemAccentColorDark3"] = palette.Darkest;
    }

    private static bool IsSystemInDarkMode()
    {
        try
        {
            using var key = Microsoft.Win32.Registry.CurrentUser.OpenSubKey(
                @"SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize");
            return key?.GetValue("AppsUseLightTheme") is int v && v == 0;
        }
        catch
        {
            return false;
        }
    }
}
