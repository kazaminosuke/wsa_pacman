using Microsoft.UI;
using Microsoft.UI.Windowing;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Windows.Graphics;
using WsaPacman.Pages;

namespace WsaPacman;

public sealed partial class MainWindow : Window
{
    public MainWindow()
    {
        this.InitializeComponent();

        SetupTitleBar();
        SetupWindowSize();
    }

    // ── タイトルバー設定 ─────────────────────────────────────────────────────
    //
    // ExtendsContentIntoTitleBar = true でウィンドウ枠内にコンテンツを拡張し、
    // NavigationView の PaneHeader (AppTitleBar グリッド) をドラッグ領域に指定する。
    // システムボタンは Windows がオーバーレイ描画するため通常通り機能する。
    private void SetupTitleBar()
    {
        ExtendsContentIntoTitleBar = true;
        SetTitleBar(AppTitleBar);

        // システムボタンの背景を透明にして Mica が透けるようにする
        var titleBar = AppWindow.TitleBar;
        titleBar.ButtonBackgroundColor = Colors.Transparent;
        titleBar.ButtonInactiveBackgroundColor = Colors.Transparent;
        // ホバー/押下時の色はデフォルトを維持し視認性を保つ
    }

    // ── ウィンドウサイズと初期位置 ───────────────────────────────────────────
    private void SetupWindowSize()
    {
        const int width = 740;
        const int height = 540;

        AppWindow.Resize(new SizeInt32(width, height));

        var displayArea = DisplayArea.GetFromWindowId(AppWindow.Id, DisplayAreaFallback.Nearest);
        var work = displayArea.WorkArea;
        AppWindow.Move(new PointInt32(
            work.X + (work.Width  - width)  / 2,
            work.Y + (work.Height - height) / 2));
    }

    // ── ナビゲーション ───────────────────────────────────────────────────────

    private void NavView_Loaded(object sender, RoutedEventArgs e)
    {
        // 起動時は WSA タブを選択
        NavView.SelectedItem = NavWSA;
    }

    private void NavView_SelectionChanged(NavigationView sender, NavigationViewSelectionChangedEventArgs args)
    {
        if (args.SelectedItemContainer is not NavigationViewItem item)
            return;

        var pageType = item.Tag?.ToString() switch
        {
            "WsaPage"      => typeof(WsaPage),
            "UninstallPage" => typeof(UninstallPage),
            "SettingsPage"  => typeof(SettingsPage),
            _              => typeof(WsaPage),
        };

        ContentFrame.Navigate(pageType);
    }
}
