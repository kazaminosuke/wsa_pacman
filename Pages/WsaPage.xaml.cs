using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;

namespace WsaPacman.Pages;

/// <summary>WSA connection states, mirroring the Flutter WSAStatusAlt enum.</summary>
public enum WsaStatus
{
    Unknown,
    Missing,
    Starting,
    Arrested,
    Offline,
    Disconnected,
    Connected,
    Unauthorized,
}

public sealed partial class WsaPage : Page
{
    public LocalizedStrings R { get; } = LocalizedStrings.Instance;

    public WsaPage()
    {
        InitializeComponent();
        SetStatus(WsaStatus.Unknown);
    }

    /// <summary>
    /// Switches the status InfoBar severity visuals (background, icon, colors)
    /// and the per-state action buttons. Called by the service layer / VM.
    /// </summary>
    public void SetStatus(WsaStatus status)
    {
        var (titleText, descText) = status switch
        {
            WsaStatus.Missing => (R.status_missing, R.status_missing_desc),
            WsaStatus.Starting => (R.status_starting, R.status_starting_desc),
            WsaStatus.Arrested => (R.status_arrested, R.status_arrested_desc),
            WsaStatus.Offline => (R.status_offline, R.status_offline_desc),
            WsaStatus.Disconnected => (R.status_disconnected, R.status_disconnected_desc),
            WsaStatus.Connected => (R.status_connected, R.status_connected_desc),
            WsaStatus.Unauthorized => (R.status_unauthorized, R.status_unauthorized_desc),
            _ => (R.status_unknown, R.status_unknown_desc),
        };
        StatusTitleText.Text = titleText;
        StatusMessageText.Text = descText;

        // Severity mapping follows fluent_ui InfoBarSeverity used by the Flutter version
        var (bgKey, fgKey, glyph) = status switch
        {
            WsaStatus.Connected => ("StatusSuccessBackgroundBrush", "SystemFillColorSuccessBrush", ""),
            WsaStatus.Missing => ("StatusErrorBackgroundBrush", "SystemFillColorCriticalBrush", ""),
            WsaStatus.Unauthorized or WsaStatus.Offline or WsaStatus.Disconnected or WsaStatus.Arrested
                => ("StatusWarningBackgroundBrush", "SystemFillColorCautionBrush", ""),
            _ => ("StatusConnectingBackgroundBrush", "SystemFillColorAttentionBrush", ""),
        };
        StatusInfoBar.Background = (Brush)Application.Current.Resources[bgKey];
        StatusIcon.Foreground = (Brush)Application.Current.Resources[fgKey];
        StatusIcon.Glyph = glyph;

        // Per-state action buttons (Flutter wsa.dart:183-313)
        BtnWsaBuilds.Visibility = Visible(status is WsaStatus.Missing);
        BtnLaunchWsa.Visibility = Visible(status is WsaStatus.Arrested);
        BtnRestartWsa.Visibility = Visible(status is WsaStatus.Offline or WsaStatus.Disconnected or WsaStatus.Unknown);
        BtnAuth.Visibility = Visible(status is WsaStatus.Unauthorized);
        BtnDevSettings.Visibility = Visible(status is WsaStatus.Offline or WsaStatus.Disconnected
            or WsaStatus.Unknown or WsaStatus.Unauthorized);
    }

    /// <summary>Swaps the refresh button icon for a 14×14 ring while refreshing or WSA is starting (W18).</summary>
    public void SetRefreshing(bool refreshing)
    {
        RefreshIcon.Visibility = Visible(!refreshing);
        RefreshRing.Visibility = Visible(refreshing);
        RefreshRing.IsActive = refreshing;
    }

    private static Visibility Visible(bool visible) =>
        visible ? Visibility.Visible : Visibility.Collapsed;

    private void RefreshStatus_Click(object sender, RoutedEventArgs e)
    {
        // Logic: re-detect WSA status (implemented in service layer later)
    }

    private void WsaBuilds_Click(object sender, RoutedEventArgs e)
    {
        // Logic: open WSABuilds download page (implemented in service layer later)
    }

    private void LaunchWsa_Click(object sender, RoutedEventArgs e)
    {
        // Logic: start the WSA client (implemented in service layer later)
    }

    private void RestartWsa_Click(object sender, RoutedEventArgs e)
    {
        // Logic: restart the WSA client (implemented in service layer later)
    }

    private void Auth_Click(object sender, RoutedEventArgs e)
    {
        // Logic: run adb authorization (implemented in service layer later)
    }

    private void DevSettings_Click(object sender, RoutedEventArgs e)
    {
        // Logic: open WSA developer settings (implemented in service layer later)
    }

    private void ManageApps_Click(object sender, RoutedEventArgs e)
    {
        // Logic: launch adb shell am start ManageApplicationsActivity (implemented later)
    }

    private void ManageSettings_Click(object sender, RoutedEventArgs e)
    {
        // Logic: launch adb shell am start android Settings (implemented later)
    }
}
