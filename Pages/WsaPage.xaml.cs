using Microsoft.UI.Xaml.Controls;

namespace WsaPacman.Pages;

public sealed partial class WsaPage : Page
{
    public LocalizedStrings R { get; } = LocalizedStrings.Instance;

    public WsaPage()
    {
        InitializeComponent();
    }

    private void RefreshStatus_Click(object sender, Microsoft.UI.Xaml.RoutedEventArgs e)
    {
        // Logic: re-detect WSA status (implemented in service layer later)
    }

    private void ManageApps_Click(object sender, Microsoft.UI.Xaml.RoutedEventArgs e)
    {
        // Logic: launch adb shell am start ManageApplicationsActivity (implemented later)
    }

    private void ManageSettings_Click(object sender, Microsoft.UI.Xaml.RoutedEventArgs e)
    {
        // Logic: launch adb shell am start android Settings (implemented later)
    }
}
