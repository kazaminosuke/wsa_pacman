using System.Collections.ObjectModel;
using System.ComponentModel;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Media;
using Microsoft.UI.Xaml.Media.Imaging;

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
    public string IconGlyph => Type == "adb" ? "" : "";
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

    public UninstallPage()
    {
        InitializeComponent();
        AppList.ItemsSource = _apps;
    }

    private async void Scan_Click(object sender, RoutedEventArgs e)
    {
        ScanningState.Visibility = Visibility.Visible;
        EmptyState.Visibility = Visibility.Collapsed;
        AppList.Visibility = Visibility.Collapsed;
        BtnScan.IsEnabled = false;

        // Logic: scan registry + adb for ghost apps (implemented in service layer later)
        await System.Threading.Tasks.Task.Delay(100);

        _apps.Clear();
        ScanningState.Visibility = Visibility.Collapsed;
        BtnScan.IsEnabled = true;

        if (_apps.Count == 0)
        {
            EmptyState.Visibility = Visibility.Visible;
        }
        else
        {
            AppList.Visibility = Visibility.Visible;
        }
    }

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

    private void BackupRegistry_Click(object sender, RoutedEventArgs e)
    {
        // Logic: export registry key to file (implemented in service layer later)
    }

    private void Cleanup_Click(object sender, RoutedEventArgs e)
    {
        // Logic: delete selected entries from registry + adb uninstall (implemented later)
    }
}
