using Microsoft.UI.Windowing;
using Microsoft.UI.Xaml;
using System.Runtime.InteropServices;
using Windows.Graphics;

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

        ExtendsContentIntoTitleBar = true;
        SetTitleBar(AppTitleBar);
        AppWindow.TitleBar.PreferredHeightOption = TitleBarHeightOption.Tall;
        AppWindow.SetIcon("Assets/AppIcon.ico");

        var hwnd = Microsoft.UI.Win32Interop.GetWindowFromWindowId(AppWindow.Id);
        var scale = GetDpiForWindow(hwnd) / 96.0;
        AppWindow.Resize(new SizeInt32((int)(420 * scale), (int)(320 * scale)));
    }

    public void Initialize(string packageId, string appName)
    {
        PackageId = packageId;
        AppName = string.IsNullOrEmpty(appName) ? packageId : appName;
        AppNameText.Text = AppName;
        PackageText.Text = PackageId;
        ConfirmText.Text = R.uninstaller_confirm(AppName);
    }

    private void Cancel_Click(object sender, RoutedEventArgs e)
    {
        Close();
    }

    private void Uninstall_Click(object sender, RoutedEventArgs e)
    {
        // Logic: adb uninstall + registry delete + shortcut cleanup (implemented later)
        ConfirmText.Visibility = Visibility.Collapsed;
        ProgressPanel.Visibility = Visibility.Visible;
        UninstallButton.IsEnabled = false;
        CancelButton.IsEnabled = false;
        StatusText.Text = R.uninstaller_status_uninstalling(AppName);
    }
}
