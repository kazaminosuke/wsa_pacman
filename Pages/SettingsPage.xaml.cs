using System.ComponentModel;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Controls.Primitives;
using Microsoft.UI.Xaml.Media;

namespace WsaPacman.Pages;

public sealed partial class SettingsPage : Page, INotifyPropertyChanged
{
    public LocalizedStrings R { get; } = LocalizedStrings.Instance;

    private int _timeoutSeconds = 30;

    public string TimeoutLabel =>
        R.settings_timeout(_timeoutSeconds == 0 ? "∞" : _timeoutSeconds.ToString());

    public event PropertyChangedEventHandler? PropertyChanged;

    public SettingsPage()
    {
        InitializeComponent();

        // System swatch reflects the current OS accent color (design doc §4.1)
        var accent = new Windows.UI.ViewManagement.UISettings()
            .GetColorValue(Windows.UI.ViewManagement.UIColorType.Accent);
        SwatchSystem.Background = new SolidColorBrush(accent);

        SelectSwatch(SwatchDefault);

        // Mica requires Windows 11; hide the card entirely on older builds (S19)
        if (System.Environment.OSVersion.Version.Build < 22000)
        {
            MicaSettingCard.Visibility = Visibility.Collapsed;
        }
    }

    private static string DesktopDir =>
        System.Environment.GetFolderPath(System.Environment.SpecialFolder.Desktop);

    // Reset appears only while the backup dir differs from the default Desktop (S16)
    private void UpdateBackupResetVisibility() =>
        BtnResetBackupDir.Visibility = BackupDirText.Text == DesktopDir || BackupDirText.Text == "Desktop"
            ? Visibility.Collapsed
            : Visibility.Visible;

    // --- Theme color swatches ---

    private void ThemeColorSwatch_Click(object sender, RoutedEventArgs e) =>
        SelectSwatch((Button)sender);

    private void SelectSwatch(Button? selected)
    {
        foreach (var child in SwatchPanel.Children)
        {
            if (child is not Button swatch || swatch.Content is not FontIcon check) continue;
            var isSelected = ReferenceEquals(swatch, selected);
            check.Visibility = isSelected ? Visibility.Visible : Visibility.Collapsed;
            if (isSelected && swatch.Background is SolidColorBrush brush)
            {
                // Checkmark turns black on light swatches, white on dark ones
                check.Foreground = new SolidColorBrush(
                    Luminance(brush.Color) > 0.5 ? Microsoft.UI.Colors.Black : Microsoft.UI.Colors.White);
                // The custom-color preview circle always mirrors the active accent color (S8)
                CustomColorPreview.Fill = new SolidColorBrush(brush.Color);
            }
        }
    }

    private static double Luminance(Windows.UI.Color c)
    {
        // Relative luminance, matching Flutter's Color.computeLuminance()
        static double Channel(byte v)
        {
            var s = v / 255.0;
            return s <= 0.03928 ? s / 12.92 : Math.Pow((s + 0.055) / 1.055, 2.4);
        }
        return 0.2126 * Channel(c.R) + 0.7152 * Channel(c.G) + 0.0722 * Channel(c.B);
    }

    private void Timeout_ValueChanged(object sender, RangeBaseValueChangedEventArgs e)
    {
        // Slider position 0 means 15 s, position 105 means infinite (stored as 0)
        var raw = (int)e.NewValue;
        _timeoutSeconds = raw >= 105 ? 0 : Math.Max(raw, 15);
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(TimeoutLabel)));
    }

    // --- Exclusive checkbox group (Flutter-style expander checklist) ---

    private CheckBox[] IconShapeGroup => new[] { IconShapeSquircle, IconShapeCircle, IconShapeRoundedSquare };

    private bool _suppressCheckEvents;

    private void ExclusiveCheck(CheckBox[] group, CheckBox checkedBox)
    {
        if (_suppressCheckEvents) return;
        _suppressCheckEvents = true;
        foreach (var box in group)
        {
            // Boxes can still be null while InitializeComponent is parsing the page
            if (box is not null && !ReferenceEquals(box, checkedBox)) box.IsChecked = false;
        }
        _suppressCheckEvents = false;
    }

    // Keep exactly one option selected: re-check when the selected box is unchecked directly
    private void KeepOneChecked(CheckBox[] group, CheckBox uncheckedBox)
    {
        if (_suppressCheckEvents) return;
        foreach (var box in group)
        {
            if (box?.IsChecked == true) return;
        }
        _suppressCheckEvents = true;
        uncheckedBox.IsChecked = true;
        _suppressCheckEvents = false;
    }

    private void IconShape_Checked(object sender, RoutedEventArgs e) => ExclusiveCheck(IconShapeGroup, (CheckBox)sender);
    private void IconShape_Unchecked(object sender, RoutedEventArgs e) => KeepOneChecked(IconShapeGroup, (CheckBox)sender);

    private async void CustomColor_Click(object sender, RoutedEventArgs e)
    {
        // ContentDialog + ColorPicker with RGB text input, mirroring the Flutter dialog (S9)
        var picker = new ColorPicker
        {
            IsColorSpectrumVisible = true,
            IsColorChannelTextInputVisible = true,
            IsHexInputVisible = true,
            IsAlphaEnabled = false,
        };
        if (CustomColorPreview.Fill is SolidColorBrush current) picker.Color = current.Color;

        var dialog = new ContentDialog
        {
            XamlRoot = XamlRoot,
            Title = R.settings_custom_color,
            Content = picker,
            PrimaryButtonText = R.btn_apply,
            CloseButtonText = R.installer_btn_cancel,
            DefaultButton = ContentDialogButton.Primary,
        };
        if (await dialog.ShowAsync() == ContentDialogResult.Primary)
        {
            CustomColorPreview.Fill = new SolidColorBrush(picker.Color);
            SelectSwatch(null); // custom color replaces any swatch selection
        }
    }

    // --- Port input (S10): digits only, max 65535, empty resets to 58526 ---

    private const int DefaultPort = 58526;

    private void Port_Loaded(object sender, RoutedEventArgs e)
    {
        // The built-in clear (×) button overlaps our reset button; collapse it for good.
        // It can only be reached through the visual tree — there is no public API.
        if (FindDescendantByName(PortTextBox, "DeleteButton") is Button deleteButton)
        {
            deleteButton.MinWidth = 0;
            deleteButton.MaxWidth = 0;
            deleteButton.Opacity = 0;
            deleteButton.IsHitTestVisible = false;
            deleteButton.IsTabStop = false;
        }
    }

    private static FrameworkElement? FindDescendantByName(DependencyObject root, string name)
    {
        var count = VisualTreeHelper.GetChildrenCount(root);
        for (var i = 0; i < count; i++)
        {
            var child = VisualTreeHelper.GetChild(root, i);
            if (child is FrameworkElement fe && fe.Name == name) return fe;
            if (FindDescendantByName(child, name) is { } match) return match;
        }
        return null;
    }

    // Strip non-digits after the fact instead of cancelling in BeforeTextChanging:
    // cancelling there fights IME composition and can wedge focus inside the box.
    private void Port_TextChanged(object sender, TextChangedEventArgs e)
    {
        var text = PortTextBox.Text;
        var digits = string.Concat(text.Where(char.IsAsciiDigit));
        if (digits == text) return;
        var caret = PortTextBox.SelectionStart - (text.Length - digits.Length);
        PortTextBox.Text = digits;
        PortTextBox.SelectionStart = Math.Clamp(caret, 0, digits.Length);
    }

    private void Port_LostFocus(object sender, RoutedEventArgs e)
    {
        if (!int.TryParse(PortTextBox.Text, out var port) || port <= 0)
        {
            PortTextBox.Text = DefaultPort.ToString();
            return;
        }
        if (port > 65535) PortTextBox.Text = "65535";
    }

    private void ResetPort_Click(object sender, RoutedEventArgs e)
    {
        PortTextBox.Text = DefaultPort.ToString();
    }

    private void ResetBackupDir_Click(object sender, RoutedEventArgs e)
    {
        BackupDirText.Text = DesktopDir;
        UpdateBackupResetVisibility();
    }

    private async void BrowseBackupDir_Click(object sender, RoutedEventArgs e)
    {
        // Logic: open folder picker via StorageFolder or PowerShell (implemented later)
        await System.Threading.Tasks.Task.CompletedTask;
        UpdateBackupResetVisibility();
    }
}
