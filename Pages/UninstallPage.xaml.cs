using System.Collections.ObjectModel;
using System.ComponentModel;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;

namespace WsaPacman.Pages;

public sealed class AppEntry : INotifyPropertyChanged
{
    private bool _isSelected;

    public string Name { get; set; } = string.Empty;
    public string PackageId { get; set; } = string.Empty;
    public string Type { get; set; } = string.Empty;

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

    private void BackupRegistry_Click(object sender, RoutedEventArgs e)
    {
        // Logic: export registry key to file (implemented in service layer later)
    }

    private void Cleanup_Click(object sender, RoutedEventArgs e)
    {
        // Logic: delete selected entries from registry + adb uninstall (implemented later)
    }
}
