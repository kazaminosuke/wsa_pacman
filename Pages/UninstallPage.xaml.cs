using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.InteropServices;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;
using Microsoft.UI.Xaml.Media.Imaging;
using WsaPacman.Models;
using WsaPacman.Services;

namespace WsaPacman.Pages;

public sealed class AppEntry : INotifyPropertyChanged
{
    private bool _isSelected;

    public string Name { get; set; } = string.Empty;
    public string PackageId { get; set; } = string.Empty;
    public string Type { get; set; } = string.Empty;

    /// <summary>Path to the DisplayIcon image from the registry, when available.</summary>
    public string IconPath { get; set; } = string.Empty;

    // Fallback icon per entry type: adb = green phone / registry = orange apps (U4)
    public string IconGlyph => Type == "adb" ? "" : "";
    public SolidColorBrush IconBrush => new(Type == "adb"
        ? Windows.UI.Color.FromArgb(0xFF, 0x10, 0x7C, 0x10)
        : Windows.UI.Color.FromArgb(0xFF, 0xF7, 0x63, 0x0C));

    public ImageSource? IconImage =>
        string.IsNullOrEmpty(IconPath) ? null : new BitmapImage(new Uri(IconPath));
    public Visibility ImageVisibility => string.IsNullOrEmpty(IconPath) ? Visibility.Collapsed : Visibility.Visible;
    public Visibility GlyphVisibility => string.IsNullOrEmpty(IconPath) ? Visibility.Visible : Visibility.Collapsed;

    public bool IsSelected
    {
        get => _isSelected;
        set
        {
            if (_isSelected == value) return;
            _isSelected = value;
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(IsSelected)));
        }
    }

    public event PropertyChangedEventHandler? PropertyChanged;
}

public sealed partial class UninstallPage : Page
{
    public LocalizedStrings R { get; } = LocalizedStrings.Instance;

    private readonly ObservableCollection<AppEntry> _apps = [];

    [DllImport("user32.dll")]
    private static extern IntPtr GetActiveWindow();

    public UninstallPage()
    {
        InitializeComponent();
        AppList.ItemsSource = _apps;
        SetWsaAvailable(AppServices.WsaEnvironment.IsWsaInstalled);
    }

    private async void Scan_Click(object sender, RoutedEventArgs e) => await RunScanAsync();

    private async Task RunScanAsync()
    {
        ScanningState.Visibility = Visibility.Visible;
        EmptyState.Visibility = Visibility.Collapsed;
        AppList.Visibility = Visibility.Collapsed;
        BtnScan.IsEnabled = false;

        var apps = await AppServices.InstalledApps.ScanAsync();

        _apps.Clear();
        foreach (var app in apps)
        {
            var entry = new AppEntry
            {
                Name = app.DisplayName,
                PackageId = app.Package,
                Type = app.Source == InstalledAppSource.AdbOnly ? "adb" : "registry",
                IconPath = ResolveIconPath(app.DisplayIcon),
            };
            entry.PropertyChanged += AppEntry_PropertyChanged;
            _apps.Add(entry);
        }

        ScanningState.Visibility = Visibility.Collapsed;
        BtnScan.IsEnabled = true;
        UpdateCleanupButtonState();

        if (_apps.Count == 0)
        {
            EmptyState.Visibility = Visibility.Visible;
        }
        else
        {
            AppList.Visibility = Visibility.Visible;
        }
    }

    private static string ResolveIconPath(string? displayIcon)
    {
        if (string.IsNullOrEmpty(displayIcon)) return "";
        // Registry DisplayIcon values may carry a ",<index>" suffix (e.g. "C:\icon.ico,0").
        var path = displayIcon.Split(',')[0].Trim('"');
        return File.Exists(path) ? path : "";
    }

    private void AppEntry_PropertyChanged(object? sender, PropertyChangedEventArgs e) => UpdateCleanupButtonState();

    private void UpdateCleanupButtonState() => BtnCleanup.IsEnabled = _apps.Any(a => a.IsSelected);

    /// <summary>
    /// Disables scan/backup and swaps the empty-state text for status_unsupported
    /// when WSA is not installed (U11). Called by the service layer / VM.
    /// </summary>
    public void SetWsaAvailable(bool available)
    {
        BtnScan.IsEnabled = available;
        BtnBackup.IsEnabled = available;
        EmptyStateText.Text = available ? R.click_scan_to_find_ghost_apps : R.status_unsupported;
    }

    private void AppList_ItemClick(object sender, ItemClickEventArgs e)
    {
        if (e.ClickedItem is AppEntry entry) entry.IsSelected = !entry.IsSelected;
    }

    private async void BackupRegistry_Click(object sender, RoutedEventArgs e)
    {
        var picker = new Windows.Storage.Pickers.FileSavePicker();
        WinRT.Interop.InitializeWithWindow.Initialize(picker, GetActiveWindow());
        picker.SuggestedFileName = $"wsa_registry_backup_{DateTime.Now:yyyyMMdd_HHmmss}";
        picker.FileTypeChoices.Add("Registry Files", new List<string> { ".reg" });

        var file = await picker.PickSaveFileAsync();
        if (file is null)
        {
            await ShowInfoDialogAsync(R.backup_cancelled, "");
            return;
        }

        var result = await AppServices.Registry.ExportAllUninstallAsync(file.Path);
        await ShowInfoDialogAsync(
            result.ExitCode == 0 ? R.backup_success : "Error",
            result.ExitCode == 0 ? file.Path : result.StdErr);
    }

    private async void Cleanup_Click(object sender, RoutedEventArgs e)
    {
        var selected = _apps.Where(a => a.IsSelected).ToList();
        if (selected.Count == 0) return;

        BtnCleanup.IsEnabled = false;
        BtnScan.IsEnabled = false;
        BtnBackup.IsEnabled = false;

        if (AppServices.Settings.Current.AutoBackupRegistry)
        {
            var savedDir = AppServices.Settings.Current.BackupDirectory;
            if (string.IsNullOrWhiteSpace(savedDir) || !Directory.Exists(savedDir))
            {
                savedDir = Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
            }
            var backupPath = Path.Combine(savedDir, $"wsa_registry_backup_{DateTime.Now:yyyyMMdd_HHmmss}.reg");
            await AppServices.Registry.ExportAllUninstallAsync(backupPath);
        }

        var ip = AppServices.Settings.Current.IpAddress;
        var port = AppServices.Settings.Current.Port;

        foreach (var entry in selected)
        {
            if (entry.Type == "registry")
            {
                AppServices.Registry.DeleteUninstallEntry(entry.PackageId);
            }
            AppServices.Shortcut.DeleteStartMenuShortcuts(entry.Name);
            await AppServices.Adb.UninstallAsync(ip, port, entry.PackageId);
        }

        await ShowInfoDialogAsync(R.cleanup_complete, R.cleanup_success_desc(selected.Count));
        await RunScanAsync();
    }

    private async Task ShowInfoDialogAsync(string title, string content)
    {
        var dialog = new ContentDialog
        {
            XamlRoot = XamlRoot,
            Title = title,
            Content = new TextBlock { Text = content, TextWrapping = TextWrapping.Wrap, IsTextSelectionEnabled = true },
            CloseButtonText = R.installer_btn_dismiss,
        };
        await dialog.ShowAsync();
    }
}
