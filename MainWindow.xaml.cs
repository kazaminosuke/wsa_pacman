using Microsoft.UI.Windowing;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media.Animation;
using System.Runtime.InteropServices;
using Windows.Graphics;
using WsaPacman.Pages;

namespace WsaPacman;

public sealed partial class MainWindow : Window
{
    public LocalizedStrings R { get; } = LocalizedStrings.Instance;

    [DllImport("user32.dll")]
    private static extern uint GetDpiForWindow(IntPtr hWnd);
    [DllImport("user32.dll")]
    private static extern IntPtr SetWindowLongPtr(IntPtr hWnd, int nIndex, IntPtr newLong);
    [DllImport("user32.dll")]
    private static extern IntPtr GetWindowLongPtr(IntPtr hWnd, int nIndex);
    [DllImport("user32.dll")]
    private static extern IntPtr CallWindowProc(IntPtr lpPrevWndFunc, IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);

    private const int GWLP_WNDPROC = -4;
    private const uint WM_GETMINMAXINFO = 0x0024;

    [StructLayout(LayoutKind.Sequential)]
    private struct POINT { public int x, y; }
    [StructLayout(LayoutKind.Sequential)]
    private struct MINMAXINFO
    {
        public POINT ptReserved, ptMaxSize, ptMaxPosition, ptMinTrackSize, ptMaxTrackSize;
    }

    private delegate IntPtr WndProcDelegate(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam);
    private WndProcDelegate? _wndProc;
    private IntPtr _oldWndProc;
    private int _minWidthPx, _minHeightPx;

    public MainWindow()
    {
        InitializeComponent();

        ExtendsContentIntoTitleBar = true;
        SetTitleBar(AppTitleBar);
        AppWindow.TitleBar.PreferredHeightOption = TitleBarHeightOption.Standard;
        AppWindow.SetIcon(System.IO.Path.Combine(AppContext.BaseDirectory, "Assets", "AppIcon.ico"));
        AppWindow.Title = "WSA Package Manager";

        var hwnd = Microsoft.UI.Win32Interop.GetWindowFromWindowId(AppWindow.Id);
        var scale = GetDpiForWindow(hwnd) / 96.0;
        AppWindow.Resize(new SizeInt32((int)(740 * scale), (int)(540 * scale)));

        _minWidthPx = (int)(640 * scale);
        _minHeightPx = (int)(500 * scale);
        _wndProc = WndProc;
        _oldWndProc = SetWindowLongPtr(hwnd, GWLP_WNDPROC, Marshal.GetFunctionPointerForDelegate(_wndProc));
    }

    private IntPtr WndProc(IntPtr hWnd, uint msg, IntPtr wParam, IntPtr lParam)
    {
        if (msg == WM_GETMINMAXINFO)
        {
            var mmi = Marshal.PtrToStructure<MINMAXINFO>(lParam);
            mmi.ptMinTrackSize = new POINT { x = _minWidthPx, y = _minHeightPx };
            Marshal.StructureToPtr(mmi, lParam, true);
        }
        return CallWindowProc(_oldWndProc, hWnd, msg, wParam, lParam);
    }

    private static readonly string[] NavOrder = ["wsa", "uninstall", "settings"];
    private int _currentNavIndex = 0;

    private void NavView_SelectionChanged(NavigationView sender, NavigationViewSelectionChangedEventArgs args)
    {
        if (args.SelectedItem is not NavigationViewItem item) return;
        var tag = item.Tag as string;
        var newIndex = Array.IndexOf(NavOrder, tag);
        if (newIndex < 0) return;

        var effect = newIndex > _currentNavIndex
            ? SlideNavigationTransitionEffect.FromRight
            : SlideNavigationTransitionEffect.FromLeft;
        var transitionInfo = new SlideNavigationTransitionInfo { Effect = effect };

        Type? pageType = tag switch
        {
            "wsa" => typeof(WsaPage),
            "uninstall" => typeof(UninstallPage),
            "settings" => typeof(SettingsPage),
            _ => null,
        };
        if (pageType is null) return;

        NavFrame.Navigate(pageType, null, transitionInfo);
        _currentNavIndex = newIndex;
    }
}
