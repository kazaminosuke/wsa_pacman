using Microsoft.UI.Windowing;
using Microsoft.UI.Xaml;
using System.Runtime.InteropServices;
using Windows.Graphics;
using WsaPacman.Services;

namespace WsaPacman;

public sealed partial class UninstallerWindow : Window
{
    public LocalizedStrings R { get; } = LocalizedStrings.Instance;

    public string PackageId { get; set; } = string.Empty;
    public string AppName { get; set; } = string.Empty;

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

    private void Uninstall_Click(object sender, RoutedEventArgs e)
    {
        // Logic: adb uninstall + registry delete + shortcut cleanup (implemented later)
        ConfirmPanel.Visibility = Visibility.Collapsed;
        ProgressPanel.Visibility = Visibility.Visible;
        UninstallButton.IsEnabled = false;
        CancelButton.IsEnabled = false;
        StatusText.Text = R.uninstaller_status_uninstalling(AppName);
    }

    /// <summary>
    /// Done state: the ring becomes a 48px green check with a success message,
    /// and the window closes itself after two seconds (X7).
    /// </summary>
    public void ShowCompleted()
    {
        ConfirmPanel.Visibility = Visibility.Collapsed;
        ProgressPanel.Visibility = Visibility.Visible;
        UninstallProgress.IsActive = false;
        UninstallProgress.Visibility = Visibility.Collapsed;
        DoneIcon.Visibility = Visibility.Visible;
        StatusText.Text = R.uninstaller_status_success;

        var timer = DispatcherQueue.CreateTimer();
        timer.Interval = TimeSpan.FromSeconds(2);
        timer.IsRepeating = false;
        timer.Tick += (_, _) => Close();
        timer.Start();
    }
}
