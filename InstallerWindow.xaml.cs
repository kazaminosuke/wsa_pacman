using Microsoft.UI.Windowing;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;
using System.Runtime.InteropServices;
using Windows.Graphics;

namespace WsaPacman;

/// <summary>Install kinds, mirroring the Flutter InstallType enum.</summary>
public enum ApkInstallType
{
    Install,
    Reinstall,
    Update,
    Downgrade,
}

public sealed partial class InstallerWindow : Window
{
    public LocalizedStrings R { get; } = LocalizedStrings.Instance;

    public string ApkPath { get; set; } = string.Empty;

    public string InstallButtonLabel => R.installer_btn_install;

    private ApkInstallType _installType = ApkInstallType.Install;

    [DllImport("user32.dll")]
    private static extern uint GetDpiForWindow(IntPtr hWnd);

    public InstallerWindow()
    {
        InitializeComponent();

        AppWindow.SetIcon("Assets/AppIcon.ico");

        var hwnd = Microsoft.UI.Win32Interop.GetWindowFromWindowId(AppWindow.Id);
        var scale = GetDpiForWindow(hwnd) / 96.0;
        AppWindow.Resize(new SizeInt32((int)(500 * scale), (int)(335 * scale)));
        if (AppWindow.Presenter is OverlappedPresenter p)
        {
            // No caption bar / system buttons; the window is closed via Cancel/Dismiss or Alt+F4
            p.SetBorderAndTitleBar(true, false);
            p.IsResizable = false;
            p.IsMaximizable = false;
            p.IsMinimizable = false;
        }

        HeaderArea.SizeChanged += (_, _) => UpdateDragRegion();
        HeaderArea.Loaded += (_, _) => UpdateDragRegion();
    }

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

    private void Cancel_Click(object sender, RoutedEventArgs e)
    {
        Close();
    }

    private void Install_Click(object sender, RoutedEventArgs e)
    {
        // Logic: run adb install (implemented in service layer later)
        ShowInstalling();
    }

    /// <summary>Installing screen: 100×100 icon container + ring + bottom indeterminate bar.</summary>
    public void ShowInstalling()
    {
        PermissionsPanel.Visibility = Visibility.Collapsed;
        ActionsRow.Visibility = Visibility.Collapsed;
        ProgressPanel.Visibility = Visibility.Visible;
        SuccessBadge.Visibility = Visibility.Collapsed;
        InstallProgress.Visibility = Visibility.Visible;
        InstallProgressBar.Visibility = Visibility.Visible;
    }

    /// <summary>
    /// Success screen: green check badge over the app icon; buttons become
    /// Dismiss + Open (Open only when the package is known). The shortcut
    /// checkbox appears only here, and only for a fresh install (I9/I12).
    /// </summary>
    public void ShowSuccess(string appTitle, bool isNewInstall, bool canOpen)
    {
        ProgressPanel.Visibility = Visibility.Visible;
        PermissionsPanel.Visibility = Visibility.Collapsed;
        InstallProgress.Visibility = Visibility.Collapsed;
        InstallProgressBar.Visibility = Visibility.Collapsed;
        SuccessBadge.Visibility = Visibility.Visible;
        StatusText.Text = R.installer_installed(appTitle);

        ActionsRow.Visibility = Visibility.Visible;
        ShortcutCheckBox.Visibility = isNewInstall ? Visibility.Visible : Visibility.Collapsed;
        CancelButton.Content = R.installer_btn_dismiss;
        CancelButton.IsEnabled = true;
        InstallButton.Content = R.installer_btn_open;
        InstallButton.IsEnabled = true;
        InstallButton.Visibility = canOpen ? Visibility.Visible : Visibility.Collapsed;
        InstallButton.Click -= Install_Click;
        InstallButton.Click += Open_Click;
    }

    private void Open_Click(object sender, RoutedEventArgs e)
    {
        // Logic: adb shell monkey launch of the installed package (implemented later)
        Close();
    }

    /// <summary>
    /// Sets the install kind: updates the action button label and swaps its accent
    /// to orange for downgrades (I10). Call before the window is shown.
    /// </summary>
    public void SetInstallType(ApkInstallType type)
    {
        _installType = type;
        InstallButton.Content = type switch
        {
            ApkInstallType.Reinstall => R.installer_btn_reinstall,
            ApkInstallType.Update => R.installer_btn_update,
            ApkInstallType.Downgrade => R.installer_btn_downgrade,
            _ => R.installer_btn_install,
        };
        if (type == ApkInstallType.Downgrade)
        {
            InstallButton.Resources["AccentButtonBackground"] = new SolidColorBrush(OrangeAccent);
            InstallButton.Resources["AccentButtonBackgroundPointerOver"] =
                new SolidColorBrush(Windows.UI.Color.FromArgb(0xFF, 0xF8, 0x7A, 0x30));
            InstallButton.Resources["AccentButtonBackgroundPressed"] =
                new SolidColorBrush(Windows.UI.Color.FromArgb(0xFF, 0xCA, 0x50, 0x10));
        }
    }

    private static Windows.UI.Color OrangeAccent =>
        Windows.UI.Color.FromArgb(0xFF, 0xF7, 0x63, 0x0C);

    /// <summary>
    /// Error screen: InfoBar with the error code as title and a selectable
    /// description as content (I13).
    /// </summary>
    public void ShowError(string errorCode, string errorDesc, bool isWarning = false)
    {
        PermissionsPanel.Visibility = Visibility.Collapsed;
        ProgressPanel.Visibility = Visibility.Collapsed;
        InstallProgressBar.Visibility = Visibility.Collapsed;

        ResultInfoBar.Severity = isWarning ? InfoBarSeverity.Warning : InfoBarSeverity.Error;
        ResultInfoBar.Title = errorCode;
        ResultInfoBar.Content = new TextBlock
        {
            Text = errorDesc,
            TextWrapping = TextWrapping.Wrap,
            IsTextSelectionEnabled = true,
        };
        ResultInfoBar.IsOpen = true;

        ActionsRow.Visibility = Visibility.Visible;
        ShortcutCheckBox.Visibility = Visibility.Collapsed;
        InstallButton.Visibility = Visibility.Collapsed;
        CancelButton.Content = R.installer_btn_dismiss;
        CancelButton.IsEnabled = true;
    }
}
