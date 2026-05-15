using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;
using Windows.UI;

namespace WsaPacman.Pages;

/// <summary>設定タブ: ポート・テーマ・言語・Mica 等の設定</summary>
public sealed partial class SettingsPage : Page
{
    public SettingsPage()
    {
        this.InitializeComponent();
        this.Loaded += SettingsPage_Loaded;
    }

    private void SettingsPage_Loaded(object sender, RoutedEventArgs e)
    {
        // TODO: 永続化された設定値をロードして各コントロールに反映する
        LoadSavedSettings();
    }

    // ── 設定ロード / セーブ ──────────────────────────────────────────────────

    private void LoadSavedSettings()
    {
        // TODO: ApplicationData.Current.LocalSettings または独自の設定ファイルから読み込む
        // 骨格では初期値を固定表示
        AndroidPortBox.Value = 58526;
        UpdateBackupDirDisplay(Environment.GetFolderPath(Environment.SpecialFolder.Desktop));
    }

    private void UpdateBackupDirDisplay(string path)
    {
        BackupDirText.Text          = path;
        BtnResetBackupDir.Visibility = path == Environment.GetFolderPath(Environment.SpecialFolder.Desktop)
                                       ? Visibility.Collapsed
                                       : Visibility.Visible;
    }

    // ── ADB ポート ────────────────────────────────────────────────────────────

    private void AndroidPortBox_ValueChanged(NumberBox sender, NumberBoxValueChangedEventArgs args)
    {
        if (double.IsNaN(args.NewValue)) return;
        // TODO: GState.AndroidPort を更新して永続化する (3 秒デバウンス)
    }

    private void BtnResetPort_Click(object sender, RoutedEventArgs e)
    {
        AndroidPortBox.Value = 58526;
        // TODO: 即時反映して永続化する
    }

    // ── トグルスイッチ ────────────────────────────────────────────────────────

    private void AutostartToggle_Toggled(object sender, RoutedEventArgs e)
    {
        // TODO: GState.AutostartWSA を更新して永続化する
    }

    private void AutoBackupToggle_Toggled(object sender, RoutedEventArgs e)
    {
        // TODO: GState.AutoBackupRegistry を更新して永続化する
    }

    // ── インストールタイムアウト ─────────────────────────────────────────────

    private void TimeoutSlider_ValueChanged(object sender, Microsoft.UI.Xaml.Controls.Primitives.RangeBaseValueChangedEventArgs e)
    {
        int seconds = (int)e.NewValue;
        TimeoutLabel.Text = seconds == 0
            ? "インストールタイムアウト: 無制限"
            : $"インストールタイムアウト: {seconds} 秒";
        // TODO: GState.InstallTimeout を更新して永続化する
    }

    // ── バックアップ保存先 ───────────────────────────────────────────────────

    private async void BtnBrowseBackupDir_Click(object sender, RoutedEventArgs e)
    {
        // TODO: FolderPicker を使ってフォルダを選択する
        // Windows App SDK では StorageFolder を使う:
        //
        // var picker = new FolderPicker();
        // picker.SuggestedStartLocation = PickerLocationId.Desktop;
        // var folder = await picker.PickSingleFolderAsync();
        // if (folder != null) UpdateBackupDirDisplay(folder.Path);
        await Task.CompletedTask;
    }

    private void BtnResetBackupDir_Click(object sender, RoutedEventArgs e)
    {
        UpdateBackupDirDisplay(Environment.GetFolderPath(Environment.SpecialFolder.Desktop));
        // TODO: GState.BackupDirectory を更新して永続化する
    }

    // ── 言語 ──────────────────────────────────────────────────────────────────

    private void LanguageComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        // TODO: GState.Locale を更新して永続化・アプリ再起動を促す
    }

    // ── テーマ ────────────────────────────────────────────────────────────────

    private void ThemeRadio_Checked(object sender, RoutedEventArgs e)
    {
        // TODO: 選択されたテーマを App の RequestedTheme に反映して永続化する
        // 例: (App.Current as App)!.SetTheme(ElementTheme.Dark);
    }

    // ── アクセントカラー ─────────────────────────────────────────────────────

    private void ColorBtn_Click(object sender, RoutedEventArgs e)
    {
        // TODO: sender.Tag でカラー名を取得し AppTheme のアクセントカラーを変更する
        if (sender is Button btn && btn.Background is SolidColorBrush brush)
            CustomColorPreview.Fill = brush;
    }

    private async void BtnCustomColor_Click(object sender, RoutedEventArgs e)
    {
        // TODO: カラーピッカーダイアログ (ContentDialog) を表示する
        await Task.CompletedTask;
    }

    // ── Mica ──────────────────────────────────────────────────────────────────

    private void MicaRadio_Checked(object sender, RoutedEventArgs e)
    {
        // TODO: MainWindow の SystemBackdrop を切り替える
        // MicaDisabled → SystemBackdrop = null
        // MicaEnabled  → new MicaBackdrop { Kind = MicaKind.Base }
        // MicaAlt      → new MicaBackdrop { Kind = MicaKind.BaseAlt }
    }

    // ── アイコンスタイル ─────────────────────────────────────────────────────

    private void LegacyIconToggle_Toggled(object sender, RoutedEventArgs e)
    {
        LegacyIconLabel.Text = LegacyIconToggle.IsOn ? "オン" : "オフ";
        // TODO: GState.LegacyIcons を更新して永続化する
    }

    private void IconRadio_Checked(object sender, RoutedEventArgs e)
    {
        // TODO: GState.IconShape を更新して永続化する
    }
}
