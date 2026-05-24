using Microsoft.UI.Windowing;
using Microsoft.UI.Xaml;
using System.Runtime.InteropServices;
using Windows.Graphics;

namespace WsaPacman;

public sealed partial class InstallerWindow : Window
{
    public LocalizedStrings R { get; } = LocalizedStrings.Instance;

    public string ApkPath { get; set; } = string.Empty;

    public string InstallButtonLabel => R.installer_btn_install;

    [DllImport("user32.dll")]
    private static extern uint GetDpiForWindow(IntPtr hWnd);

    public InstallerWindow()
    {
        InitializeComponent();

        ExtendsContentIntoTitleBar = true;
        SetTitleBar(AppTitleBar);
        AppWindow.TitleBar.PreferredHeightOption = TitleBarHeightOption.Tall;
        AppWindow.SetIcon("Assets/AppIcon.ico");

        var hwnd = Microsoft.UI.Win32Interop.GetWindowFromWindowId(AppWindow.Id);
        var scale = GetDpiForWindow(hwnd) / 96.0;
        AppWindow.Resize(new SizeInt32((int)(500 * scale), (int)(335 * scale)));
        if (AppWindow.Presenter is OverlappedPresenter p)
        {
            p.IsResizable = false;
            p.IsMaximizable = false;
        }
    }

    private void Cancel_Click(object sender, RoutedEventArgs e)
    {
        Close();
    }

    private void Install_Click(object sender, RoutedEventArgs e)
    {
        // Logic: run adb install (implemented in service layer later)
        PermissionsPanel.Visibility = Visibility.Collapsed;
        ProgressPanel.Visibility = Visibility.Visible;
        InstallButton.IsEnabled = false;
        CancelButton.IsEnabled = false;
    }
}
