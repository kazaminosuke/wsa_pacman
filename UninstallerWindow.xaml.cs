using Microsoft.UI.Windowing;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Media.Imaging;
using System.Runtime.InteropServices;
using Windows.Graphics;
using WsaPacman.Services;

namespace WsaPacman;

public sealed partial class UninstallerWindow : Window
{
    public LocalizedStrings R { get; } = LocalizedStrings.Instance;

    public string PackageId { get; set; } = string.Empty;
    public string AppName { get; set; } = string.Empty;

    private UninstallPhase? _lastPhase;
    private bool _appInfoLoadStarted;

    [DllImport("user32.dll")]
    private static extern uint GetDpiForWindow(IntPtr hWnd);

    public UninstallerWindow()
    {
        InitializeComponent();

        AppWindow.SetIcon("Assets/AppIcon.ico");

        var hwnd = Microsoft.UI.Win32Interop.GetWindowFromWindowId(AppWindow.Id);
        var scale = GetDpiForWindow(hwnd) / 96.0;
        AppWindow.Resize(new SizeInt32((int)(500 * scale), (int)(335 * scale)));
        if (AppWindow.Presenter is OverlappedPresenter p)
        {
            // No caption bar / system buttons; the window is closed via Cancel or Alt+F4
            p.SetBorderAndTitleBar(true, false);
            p.IsResizable = false;
            p.IsMaximizable = false;
            p.IsMinimizable = false;
        }

        HeaderArea.SizeChanged += (_, _) => UpdateDragRegion();
        HeaderArea.Loaded += (_, _) => UpdateDragRegion();

        // テーマ/Mica/アクセントカラーの復元と、設定変更時の即時反映（§6.5）
        WindowThemeHelper.Apply(this);
        AppServices.Theme.ThemeChanged += Theme_ThemeChanged;
        Closed += (_, _) => AppServices.Theme.ThemeChanged -= Theme_ThemeChanged;

        // PackageId は Initialize() 経由で Activate() 前に設定される
        Activated += UninstallerWindow_Activated;
    }

    private async void UninstallerWindow_Activated(object sender, WindowActivatedEventArgs e)
    {
        if (_appInfoLoadStarted) return;
        _appInfoLoadStarted = true;
        await LoadAppInfoAsync();
    }

    /// <summary>RegistryServiceの実データでDisplayName/DisplayIconを補完する（コマンドライン起動時はappNameが空のため）。</summary>
    private async Task LoadAppInfoAsync()
    {
        if (string.IsNullOrEmpty(PackageId)) return;

        var entry = await AppServices.ApkUninstall.GetAppInfoAsync(PackageId);
        if (entry is null) return;

        if (!string.IsNullOrEmpty(entry.DisplayName))
        {
            AppName = entry.DisplayName;
            ConfirmText.Text = R.uninstaller_confirm(AppName);
        }

        ApplyIcon(entry.DisplayIcon);
    }

    private void ApplyIcon(string? displayIcon)
    {
        if (string.IsNullOrEmpty(displayIcon)) return;
        try
        {
            // "C:\path\icon.ico,0" 形式（インデックス付き）を考慮してパス部分のみ取り出す
            var path = displayIcon.Split(',')[0].Trim('"');
            if (!File.Exists(path)) return;

            var bitmap = new BitmapImage(new Uri(path));
            HeaderIconImage.Source = bitmap;
            HeaderIconGlyph.Visibility = Visibility.Collapsed;
            HeaderIconImage.Visibility = Visibility.Visible;
        }
        catch
        {
            // Unreadable/unsupported icon file — keep the placeholder glyph.
        }
    }

    private void Theme_ThemeChanged(object? sender, EventArgs e) =>
        DispatcherQueue.TryEnqueue(() => WindowThemeHelper.Apply(this));

    // The header band acts as the caption (drag) area of the borderless window
    private void UpdateDragRegion()
    {
        if (Content?.XamlRoot is not { } xamlRoot) return;
        var scale = xamlRoot.RasterizationScale;
        var transform = HeaderArea.TransformToVisual(Content);
        var bounds = transform.TransformBounds(
            new Windows.Foundation.Rect(0, 0, HeaderArea.ActualWidth, HeaderArea.ActualHeight));
        var region = new RectInt32(
            (int)(bounds.X * scale), (int)(bounds.Y * scale),
            (int)(bounds.Width * scale), (int)(bounds.Height * scale));
        Microsoft.UI.Input.InputNonClientPointerSource.GetForWindowId(AppWindow.Id)
            .SetRegionRects(Microsoft.UI.Input.NonClientRegionKind.Caption, new[] { region });
    }

    public void Initialize(string packageId, string appName)
    {
        PackageId = packageId;
        AppName = string.IsNullOrEmpty(appName) ? packageId : appName;
        PackageText.Text = $"Package: {PackageId}";
        ConfirmText.Text = R.uninstaller_confirm(AppName);
    }

    private void Cancel_Click(object sender, RoutedEventArgs e)
    {
        Close();
    }

    private async void Uninstall_Click(object sender, RoutedEventArgs e)
    {
        ConfirmPanel.Visibility = Visibility.Collapsed;
        ProgressPanel.Visibility = Visibility.Visible;
        UninstallButton.IsEnabled = false;
        CancelButton.IsEnabled = false;
        StatusText.Text = R.uninstaller_status_uninstalling(AppName);

        var progress = new Progress<UninstallProgress>(ApplyUninstallProgress);
        var success = await AppServices.ApkUninstall.UninstallAsync(PackageId, AppName, progress);

        if (!success && _lastPhase == UninstallPhase.Failed)
        {
            // ブート待機タイムアウト等で継続不能。ユーザーが手動で閉じられるようにする。
            UninstallProgress.IsActive = false;
            UninstallProgress.Visibility = Visibility.Collapsed;
            CancelButton.IsEnabled = true;
            CancelButton.Content = R.installer_btn_dismiss;
            return;
        }

        ShowCompleted(success ? R.uninstaller_status_success : R.uninstaller_status_errors);
    }

    private void ApplyUninstallProgress(UninstallProgress progress)
    {
        _lastPhase = progress.Phase;
        StatusText.Text = progress.Phase switch
        {
            UninstallPhase.StartingWsa or UninstallPhase.WaitingBoot => R.uninstaller_status_starting_wsa,
            UninstallPhase.Failed => R.uninstaller_status_error_msg(progress.Message ?? ""),
            _ => R.uninstaller_status_uninstalling(AppName),
        };
    }

    /// <summary>
    /// Done state: the ring becomes a 48px green check with a success message,
    /// and the window closes itself after two seconds (X7).
    /// </summary>
    public void ShowCompleted(string message)
    {
        ConfirmPanel.Visibility = Visibility.Collapsed;
        ProgressPanel.Visibility = Visibility.Visible;
        UninstallProgress.IsActive = false;
        UninstallProgress.Visibility = Visibility.Collapsed;
        DoneIcon.Visibility = Visibility.Visible;
        StatusText.Text = message;

        var timer = DispatcherQueue.CreateTimer();
        timer.Interval = TimeSpan.FromSeconds(2);
        timer.IsRepeating = false;
        timer.Tick += (_, _) => Close();
        timer.Start();
    }
}
