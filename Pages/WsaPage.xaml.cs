using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;
using WsaPacman.Models;
using WsaPacman.Services;

namespace WsaPacman.Pages;

public sealed partial class WsaPage : Page
{
    public LocalizedStrings R { get; } = LocalizedStrings.Instance;

    private readonly IWsaStatusService _wsaStatus = AppServices.WsaStatus;
    private readonly IWsaClientService _wsaClient = AppServices.WsaClient;
    private readonly IAdbService _adb = AppServices.Adb;
    private readonly ISettingsService _settings = AppServices.Settings;

    public WsaPage()
    {
        InitializeComponent();
        ApplySnapshot(_wsaStatus.Current);
        _wsaStatus.StatusChanged += WsaStatus_StatusChanged;
        Unloaded += WsaPage_Unloaded;
    }

    private void WsaPage_Unloaded(object sender, RoutedEventArgs e) =>
        _wsaStatus.StatusChanged -= WsaStatus_StatusChanged;

    private void WsaStatus_StatusChanged(object? sender, WsaStatusSnapshot snapshot) =>
        DispatcherQueue.TryEnqueue(() => ApplySnapshot(snapshot));

    /// <summary>
    /// ステータスInfoBarのseverity切替（背景/アイコン/文字色）と状態別ボタンの出し分け。
    /// WsaStatusService からの通知（StatusChanged）で毎回呼ばれる。
    /// </summary>
    public void ApplySnapshot(WsaStatusSnapshot snapshot)
    {
        StatusTitleText.Text = R[snapshot.TitleKey];
        StatusMessageText.Text = R[snapshot.DescriptionKey];

        // Severity → 背景/アイコン色/グリフ（fluent_ui InfoBarSeverity踏襲）
        var (bgKey, fgKey, glyph) = snapshot.Severity switch
        {
            InfoBarSeverity.Success => ("StatusSuccessBackgroundBrush", "SystemFillColorSuccessBrush", ""),
            InfoBarSeverity.Error => ("StatusErrorBackgroundBrush", "SystemFillColorCriticalBrush", ""),
            InfoBarSeverity.Warning => ("StatusWarningBackgroundBrush", "SystemFillColorCautionBrush", ""),
            _ => ("StatusConnectingBackgroundBrush", "SystemFillColorAttentionBrush", ""),
        };
        StatusInfoBar.Background = (Brush)Application.Current.Resources[bgKey];
        StatusIcon.Foreground = (Brush)Application.Current.Resources[fgKey];
        StatusIcon.Glyph = glyph;

        // 状態別の操作ボタン（Flutter wsa.dart:183-313）
        var status = snapshot.Status;
        BtnWsaBuilds.Visibility = Visible(status is ConnectionStatus.Missing);
        BtnLaunchWsa.Visibility = Visible(status is ConnectionStatus.Arrested);
        BtnRestartWsa.Visibility = Visible(status is ConnectionStatus.Offline or ConnectionStatus.Disconnected or ConnectionStatus.Unknown);
        BtnAuth.Visibility = Visible(status is ConnectionStatus.Unauthorized);
        BtnDevSettings.Visibility = Visible(status is ConnectionStatus.Offline or ConnectionStatus.Disconnected
            or ConnectionStatus.Unknown or ConnectionStatus.Unauthorized);

        SetRefreshing(status is ConnectionStatus.Starting);
    }

    /// <summary>更新ボタンのアイコンを14×14 ProgressRingに差し替える（W18）。</summary>
    public void SetRefreshing(bool refreshing)
    {
        RefreshIcon.Visibility = Visible(!refreshing);
        RefreshRing.Visibility = Visible(refreshing);
        RefreshRing.IsActive = refreshing;
    }

    private static Visibility Visible(bool visible) =>
        visible ? Visibility.Visible : Visibility.Collapsed;

    private async void RefreshStatus_Click(object sender, RoutedEventArgs e)
    {
        SetRefreshing(true);
        try
        {
            await _wsaStatus.CheckNowAsync();
        }
        finally
        {
            SetRefreshing(_wsaStatus.Current.Status is ConnectionStatus.Starting);
        }
    }

    private async void WsaBuilds_Click(object sender, RoutedEventArgs e) =>
        await Windows.System.Launcher.LaunchUriAsync(new Uri("https://github.com/MustardChef/WSABuilds"));

    private void LaunchWsa_Click(object sender, RoutedEventArgs e)
    {
        _wsaClient.Launch();
        _wsaStatus.NotifyWsaStartRequested();
        ScheduleStartingTimeoutRefresh();
    }

    private async void RestartWsa_Click(object sender, RoutedEventArgs e)
    {
        // 内部処理設計書 §4.4: taskkill → adb kill-server → 1秒待機 → Launch()
        await _wsaClient.KillClientAsync();
        await _adb.KillServerAsync();
        await Task.Delay(TimeSpan.FromSeconds(1));
        _wsaClient.Launch();
        _wsaStatus.NotifyWsaStartRequested();
        ScheduleStartingTimeoutRefresh();
    }

    private async void Auth_Click(object sender, RoutedEventArgs e) =>
        await _wsaStatus.ReconnectAsync();

    private void DevSettings_Click(object sender, RoutedEventArgs e) =>
        _wsaClient.LaunchDeveloperSettings();

    private async void ManageApps_Click(object sender, RoutedEventArgs e) =>
        await OpenAndroidActivityAsync("com.android.settings/.Settings$ManageApplicationsActivity");

    private async void ManageSettings_Click(object sender, RoutedEventArgs e) =>
        await OpenAndroidActivityAsync("com.android.settings/.Settings");

    /// <summary>起動要求から1分後、まだSTARTINGなら強制的に再検出する（§3.3、wsa.dartのFuture.delayed(1min)踏襲）。</summary>
    private void ScheduleStartingTimeoutRefresh()
    {
        _ = Task.Run(async () =>
        {
            await Task.Delay(TimeSpan.FromMinutes(1));
            if (_wsaStatus.Current.Status is ConnectionStatus.Starting)
            {
                await _wsaStatus.CheckNowAsync();
            }
        });
    }

    /// <summary>§4.4: 未接続なら起動→簡易待機（1秒×最大15回）→ am start。</summary>
    private async Task OpenAndroidActivityAsync(string activity)
    {
        if (_wsaStatus.Current.Status is not ConnectionStatus.Connected)
        {
            _wsaClient.Launch();
            _wsaStatus.NotifyWsaStartRequested();
        }

        var ip = _settings.Current.IpAddress;
        var port = _settings.Current.Port;
        for (var i = 0; i < 15; i++)
        {
            var echo = await _adb.ShellAsync(ip, port, "echo 1", TimeSpan.FromSeconds(1));
            if (echo.ExitCode == 0) break;
            await Task.Delay(TimeSpan.FromSeconds(1));
        }
        await _adb.ShellAsync(ip, port, $"am start -n {activity}");
    }
}
