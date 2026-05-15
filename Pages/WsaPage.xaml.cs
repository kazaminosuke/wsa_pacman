using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;

namespace WsaPacman.Pages;

/// <summary>WSA タブ: ステータス表示・起動・アプリ/設定管理</summary>
public sealed partial class WsaPage : Page
{
    // TODO: ConnectionStatus を DI や SharedState で受け取る
    private ConnectionStatus _currentStatus = ConnectionStatus.Unknown;

    public WsaPage()
    {
        this.InitializeComponent();
        this.Loaded += WsaPage_Loaded;
    }

    private void WsaPage_Loaded(object sender, RoutedEventArgs e)
    {
        // TODO: WSAPeriodicConnector の定期チェックを購読してステータスを更新する
        UpdateStatusUI(_currentStatus);
    }

    // ── UI 更新 ──────────────────────────────────────────────────────────────

    /// <summary>
    /// ConnectionStatus に応じて InfoBar・ボタンの表示内容を切り替える。
    /// 実装時はここを呼び出すイベントを状態管理クラスから受け取る。
    /// </summary>
    internal void UpdateStatusUI(ConnectionStatus status)
    {
        _currentStatus = status;

        // InfoBar の Severity / Title / 説明文
        (StatusInfoBar.Severity, StatusInfoBar.Title, var desc) = status switch
        {
            ConnectionStatus.Connected    => (InfoBarSeverity.Success,       "接続済み",       "WSA は正常に接続されています。"),
            ConnectionStatus.Missing      => (InfoBarSeverity.Error,         "WSA 未インストール", "WSA が見つかりません。WSABuilds から入手してください。"),
            ConnectionStatus.Unsupported  => (InfoBarSeverity.Error,         "非対応",         "このバージョンの Windows では WSA はサポートされていません。"),
            ConnectionStatus.Arrested     => (InfoBarSeverity.Warning,       "停止中",         "WSA はインストールされていますが、起動していません。"),
            ConnectionStatus.Offline      => (InfoBarSeverity.Warning,       "オフライン",      "WSA プロセスは実行中ですが ADB ポートが閉じています。"),
            ConnectionStatus.Disconnected => (InfoBarSeverity.Error,         "切断",           "ADB 接続に失敗しました。"),
            ConnectionStatus.Unauthorized => (InfoBarSeverity.Warning,       "認証エラー",      "デバッグ認証が必要です。"),
            ConnectionStatus.Starting     => (InfoBarSeverity.Informational, "起動中",         "WSA を起動しています…"),
            _                             => (InfoBarSeverity.Informational, "ステータス不明",  "WSA の接続状態を確認中です。"),
        };
        StatusDescription.Text = desc;

        // WSA がインストールされているかどうかで管理ボタンを有効化
        bool wsaAvailable = status is ConnectionStatus.Connected
                                   or ConnectionStatus.Arrested
                                   or ConnectionStatus.Offline
                                   or ConnectionStatus.Disconnected
                                   or ConnectionStatus.Unauthorized
                                   or ConnectionStatus.Starting;
        BtnManageApp.IsEnabled      = wsaAvailable;
        BtnManageSettings.IsEnabled = wsaAvailable;

        // 状態別アクションボタン表示
        BtnLaunchWSA.IsEnabled  = status == ConnectionStatus.Arrested;
        BtnRestartWSA.Visibility = status is ConnectionStatus.Offline
                                          or ConnectionStatus.Disconnected
                                          ? Visibility.Visible : Visibility.Collapsed;
        BtnDevSettings.Visibility = status is ConnectionStatus.Offline
                                           or ConnectionStatus.Disconnected
                                           ? Visibility.Visible : Visibility.Collapsed;

        // 起動中は更新ボタンを無効化してスピナーを表示
        bool isStarting = status == ConnectionStatus.Starting;
        BtnRefreshStatus.IsEnabled = !isStarting;
        RefreshRing.IsActive        = isStarting;
        RefreshRing.Visibility      = isStarting ? Visibility.Visible  : Visibility.Collapsed;
        RefreshIcon.Visibility      = isStarting ? Visibility.Collapsed : Visibility.Visible;
    }

    // ── ボタンハンドラ (ロジックは TODO) ────────────────────────────────────

    private void BtnLaunchWSA_Click(object sender, RoutedEventArgs e)
    {
        // TODO: WSAUtils.Launch() を呼び出す
    }

    private void BtnRestartWSA_Click(object sender, RoutedEventArgs e)
    {
        // TODO: WSA プロセスを再起動する
    }

    private void BtnDevSettings_Click(object sender, RoutedEventArgs e)
    {
        // TODO: WSAUtils.LaunchDeveloperSettings() を呼び出す
    }

    private async void BtnRefreshStatus_Click(object sender, RoutedEventArgs e)
    {
        // TODO: WSAStatus.InvalidateCache() → WSAPeriodicConnector.CheckNow() を呼ぶ
        BtnRefreshStatus.IsEnabled = false;
        RefreshRing.IsActive       = true;
        RefreshRing.Visibility     = Visibility.Visible;
        RefreshIcon.Visibility     = Visibility.Collapsed;

        await Task.Delay(500); // 暫定: 実際の非同期チェックに差し替える

        BtnRefreshStatus.IsEnabled = true;
        RefreshRing.IsActive       = false;
        RefreshRing.Visibility     = Visibility.Collapsed;
        RefreshIcon.Visibility     = Visibility.Visible;
    }

    private void BtnManageApp_Click(object sender, RoutedEventArgs e)
    {
        // TODO: ADB で com.android.settings/.Settings$ManageApplicationsActivity を起動
    }

    private void BtnManageSettings_Click(object sender, RoutedEventArgs e)
    {
        // TODO: ADB で com.android.settings/.Settings を起動
    }
}

// ── WSA 接続状態列挙 ─────────────────────────────────────────────────────────
// Flutter 版 ConnectionStatus の C# 移植。
// 将来的には別ファイル (Models/ConnectionStatus.cs) に切り出す。
public enum ConnectionStatus
{
    Unknown,
    Unsupported,
    Missing,
    Arrested,
    Starting,
    Offline,
    Disconnected,
    Connected,
    Unauthorized,
}
