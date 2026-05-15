using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;

namespace WsaPacman.Pages;

/// <summary>Uninstall タブ: ゴーストアプリのスキャン・クリーンアップ</summary>
public sealed partial class UninstallPage : Page
{
    private bool _isScanning;
    private readonly HashSet<string> _selectedPackages = [];

    // TODO: WSA インストール状態を実際の検出結果で差し替える
    private bool _wsaInstalled = false;

    public UninstallPage()
    {
        this.InitializeComponent();
        this.Loaded += UninstallPage_Loaded;
    }

    private void UninstallPage_Loaded(object sender, RoutedEventArgs e)
    {
        // TODO: ConnectionStatus から WSA インストール状態を取得する
        UpdateActionBarState();

        // 骨格: サンプルデータが表示されているので ResultsScrollViewer を表示
        // 実装時: スキャン前は EmptyStatePanel を表示
        // ShowEmptyState("スキャンボタンを押してゴーストアプリを検出してください");
        ShowSampleResults();
    }

    // ── 状態管理 ──────────────────────────────────────────────────────────────

    private void UpdateActionBarState()
    {
        BtnScan.IsEnabled          = _wsaInstalled && !_isScanning;
        BtnBackupRegistry.IsEnabled = _wsaInstalled;
        BtnCleanup.IsEnabled       = _selectedPackages.Count > 0;
    }

    private void ShowEmptyState(string message)
    {
        EmptyStateText.Text         = message;
        EmptyStatePanel.Visibility  = Visibility.Visible;
        ResultsScrollViewer.Visibility = Visibility.Collapsed;
        ScanProgressRing.IsActive   = false;
        ScanProgressRing.Visibility = Visibility.Collapsed;
    }

    private void ShowScanning()
    {
        BtnScanText.Text            = "スキャン中…";
        ScanProgressRing.IsActive   = true;
        ScanProgressRing.Visibility = Visibility.Visible;
        EmptyStateText.Visibility   = Visibility.Collapsed;
        EmptyStatePanel.Visibility  = Visibility.Visible;
        ResultsScrollViewer.Visibility = Visibility.Collapsed;
    }

    private void ShowSampleResults()
    {
        EmptyStatePanel.Visibility     = Visibility.Collapsed;
        ResultsScrollViewer.Visibility = Visibility.Visible;
    }

    // ── ボタンハンドラ (ロジックは TODO) ────────────────────────────────────

    private async void BtnScan_Click(object sender, RoutedEventArgs e)
    {
        if (_isScanning) return;
        _isScanning = true;
        _selectedPackages.Clear();
        UpdateActionBarState();

        ShowScanning();

        // TODO: PowerShell でレジストリスキャン + ADB pm list packages -3
        await Task.Delay(500); // 暫定

        _isScanning = false;
        BtnScanText.Text = "スキャン";
        UpdateActionBarState();

        // TODO: スキャン結果をリストに表示する
        ShowSampleResults();
    }

    private async void BtnBackupRegistry_Click(object sender, RoutedEventArgs e)
    {
        // TODO: FileSavePicker で保存先を選択してから
        //       reg export HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall <path> /y を実行
        await Task.CompletedTask;
    }

    private async void BtnCleanup_Click(object sender, RoutedEventArgs e)
    {
        if (_selectedPackages.Count == 0) return;

        // TODO: 確認ダイアログ → レジストリ自動バックアップ (設定で有効な場合) →
        //       reg delete + adb uninstall + スタートメニューショートカット削除
        await Task.CompletedTask;
    }
}
