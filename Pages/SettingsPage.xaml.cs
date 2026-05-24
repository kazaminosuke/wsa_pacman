using System.ComponentModel;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Controls.Primitives;

namespace WsaPacman.Pages;

public sealed partial class SettingsPage : Page, INotifyPropertyChanged
{
    public LocalizedStrings R { get; } = LocalizedStrings.Instance;

    private int _timeoutSeconds = 120;

    public string TimeoutLabel =>
        R.settings_timeout(_timeoutSeconds == 0 ? "∞" : _timeoutSeconds.ToString());

    public event PropertyChangedEventHandler? PropertyChanged;

    public SettingsPage()
    {
        InitializeComponent();
    }

    private void Timeout_ValueChanged(object sender, RangeBaseValueChangedEventArgs e)
    {
        var raw = (int)e.NewValue;
        _timeoutSeconds = raw >= 105 ? 0 : raw;
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(TimeoutLabel)));
    }

    private void CustomColor_Click(object sender, RoutedEventArgs e)
    {
        // Logic: open custom color picker dialog (implemented later)
    }

    private void ResetBackupDir_Click(object sender, RoutedEventArgs e)
    {
        BackupDirText.Text = System.IO.Path.Combine(
            System.Environment.GetFolderPath(System.Environment.SpecialFolder.Desktop));
    }

    private async void BrowseBackupDir_Click(object sender, RoutedEventArgs e)
    {
        // Logic: open folder picker via StorageFolder or PowerShell (implemented later)
        await System.Threading.Tasks.Task.CompletedTask;
    }
}
