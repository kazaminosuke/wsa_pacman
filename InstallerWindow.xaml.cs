using Microsoft.UI.Windowing;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;
using Microsoft.UI.Xaml.Media.Imaging;
using System.Runtime.InteropServices;
using System.Text.RegularExpressions;
using Windows.Graphics;
using WsaPacman.Models;
using WsaPacman.Services;

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
    private ApkInfo? _apkInfo;
    private bool _apkLoadStarted;

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

        // テーマ/Mica/アクセントカラーの復元と、設定変更時の即時反映（§6.5）
        WindowThemeHelper.Apply(this);
        AppServices.Theme.ThemeChanged += Theme_ThemeChanged;
        Closed += (_, _) => AppServices.Theme.ThemeChanged -= Theme_ThemeChanged;

        // ApkPath はオブジェクト初期化子で構築後に設定されるため、Activated（Activate()呼び出し時）まで待つ
        Activated += InstallerWindow_Activated;
    }

    private async void InstallerWindow_Activated(object sender, WindowActivatedEventArgs e)
    {
        if (_apkLoadStarted) return;
        _apkLoadStarted = true;
        await LoadApkAsync();
    }

    /// <summary>ApkReaderServiceでAPK実データを読み込み、インストール種別(新規/再/更新/降格)を判定する。</summary>
    private async Task LoadApkAsync()
    {
        InstallButton.Content = R.installer_btn_loading;
        InstallButton.IsEnabled = false;

        ApkInfo info;
        try
        {
            info = await AppServices.ApkReader.ReadAsync(ApkPath);
        }
        catch (ApkReadException ex)
        {
            ShowError(ex.ErrorCode, ex.Message);
            return;
        }
        catch (Exception ex)
        {
            ShowError("APK_READ_ERROR", ex.Message);
            return;
        }

        _apkInfo = info;
        AppNameText.Text = info.Label;
        AppVersionText.Text = R.installer_info_version(info.VersionName);
        AppPackageText.Text = R.installer_info_package(info.Package);
        PermissionList.ItemsSource = info.Permissions.Select(R.PermissionDescription).ToList();
        await ApplyIconAsync(info.IconBytes);

        _installType = await DetermineInstallTypeAsync(info.Package, info.VersionCode);
        SetInstallType(_installType);
        InstallButton.IsEnabled = true;
    }

    /// <summary>adb shell dumpsys package からインストール済みバージョンを読み取り種別を判定する（reader_apk.dart loadInstallType 踏襲）。</summary>
    private static async Task<ApkInstallType> DetermineInstallTypeAsync(string package, int newVersionCode)
    {
        if (string.IsNullOrEmpty(package)) return ApkInstallType.Install;
        try
        {
            var settings = AppServices.Settings.Current;
            var result = await AppServices.Adb.ShellAsync(
                settings.IpAddress, settings.Port, $"dumpsys package {package}", TimeSpan.FromSeconds(5));
            var match = Regex.Match(
                result.StdOut, @"(\n|\s|^)versionCode=(\d+)");
            if (match.Success && int.TryParse(match.Groups[2].Value, out var oldVersionCode))
            {
                return oldVersionCode < newVersionCode ? ApkInstallType.Update
                    : oldVersionCode > newVersionCode ? ApkInstallType.Downgrade
                    : ApkInstallType.Reinstall;
            }
        }
        catch
        {
            // 判定できない場合は新規インストール扱い（Flutter版踏襲）。
        }
        return ApkInstallType.Install;
    }

    private async Task ApplyIconAsync(byte[]? iconBytes)
    {
        if (iconBytes is null || iconBytes.Length == 0) return;
        try
        {
            using var stream = new MemoryStream(iconBytes);
            var bitmap = new BitmapImage();
            await bitmap.SetSourceAsync(stream.AsRandomAccessStream());

            HeaderIconImage.Source = bitmap;
            HeaderIconGlyph.Visibility = Visibility.Collapsed;
            HeaderIconImage.Visibility = Visibility.Visible;

            ProgressIconImage.Source = bitmap;
            ProgressIconGlyph.Visibility = Visibility.Collapsed;
            ProgressIconImage.Visibility = Visibility.Visible;
        }
        catch
        {
            // Unsupported image format (e.g. WebP) — keep the placeholder glyph.
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

    private void Cancel_Click(object sender, RoutedEventArgs e)
    {
        CreateShortcutIfRequested();
        Close();
    }

    private void CreateShortcutIfRequested()
    {
        if (ShortcutCheckBox.Visibility == Visibility.Visible && ShortcutCheckBox.IsChecked == true
            && _apkInfo is { } info)
        {
            AppServices.Shortcut.CreateWsaAppShortcut(info.Package, info.Label);
        }
    }

    private async void Install_Click(object sender, RoutedEventArgs e)
    {
        if (_apkInfo is not { } info) return;

        ShowInstalling();
        StatusText.Text = R.installer_installing(info.Label);

        var result = await AppServices.ApkInstall.InstallAsync(
            ApkPath, info.Package, info.Label, _installType == ApkInstallType.Downgrade);

        switch (result.State)
        {
            case InstallState.Success:
                ShowSuccess(info.Label, _installType == ApkInstallType.Install, !string.IsNullOrEmpty(info.Package));
                break;
            case InstallState.Timeout:
                ShowError(result.ErrorCode ?? "TIMEOUT", result.ErrorDescription ?? R.installer_error_timeout, isWarning: true);
                break;
            default:
                ShowError(result.ErrorCode ?? "INSTALL_ERROR", result.ErrorDescription ?? R.installer_error_nomsg);
                break;
        }
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
        CreateShortcutIfRequested();
        if (_apkInfo is { } info && !string.IsNullOrEmpty(info.Package))
        {
            AppServices.WsaClient.LaunchApp(info.Package);
        }
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
