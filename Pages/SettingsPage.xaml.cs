using System.ComponentModel;
using System.Runtime.InteropServices;
using Microsoft.UI.Xaml;
using Microsoft.UI.Xaml.Controls;
using Microsoft.UI.Xaml.Controls.Primitives;
using Microsoft.UI.Xaml.Media;
using WsaPacman.Models;
using WsaPacman.Services;

namespace WsaPacman.Pages;

/// <summary>Timeout slider thumb tooltip: shows the seconds, or "∞" at the max position.</summary>
public sealed class TimeoutTipConverter : Microsoft.UI.Xaml.Data.IValueConverter
{
    public object Convert(object value, Type targetType, object parameter, string language)
    {
        var v = (double)value;
        return v >= 105 ? "∞" : ((int)v).ToString();
    }

    public object ConvertBack(object value, Type targetType, object parameter, string language) =>
        throw new NotSupportedException();
}

public sealed partial class SettingsPage : Page, INotifyPropertyChanged
{
    public LocalizedStrings R { get; } = LocalizedStrings.Instance;

    private int _timeoutSeconds = 30;

    public string TimeoutLabel =>
        R.settings_timeout(_timeoutSeconds == 0 ? "∞" : _timeoutSeconds.ToString());

    public event PropertyChangedEventHandler? PropertyChanged;

    // Guards initial control-state restoration from re-persisting the values it just set
    // (ComboBox.SelectedIndex / CheckBox.IsChecked / ToggleSwitch.IsOn all fire their
    // change events immediately once the handlers are wired by InitializeComponent()).
    private bool _isRestoringSettings = true;

    public SettingsPage()
    {
        InitializeComponent();

        // System swatch reflects the current OS accent color (design doc §4.1)
        var accent = new Windows.UI.ViewManagement.UISettings()
            .GetColorValue(Windows.UI.ViewManagement.UIColorType.Accent);
        SwatchSystem.Background = new SolidColorBrush(accent);

        // Mica requires Windows 11; hide the card entirely on older builds (S19)
        if (System.Environment.OSVersion.Version.Build < 22000)
        {
            MicaSettingCard.Visibility = Visibility.Collapsed;
        }

        RestoreSettingsUi();
        _isRestoringSettings = false;
    }

    /// <summary>起動時（ページ表示時）に永続化済みの設定をコントロールへ反映する。</summary>
    private void RestoreSettingsUi()
    {
        var settings = AppServices.Settings.Current;

        ThemeModeCombo.SelectedIndex = settings.Theme switch
        {
            AppTheme.Light => 1,
            AppTheme.Dark => 2,
            _ => 0,
        };

        MicaCombo.SelectedIndex = settings.Mica switch
        {
            MicaMode.Partial => 1,
            MicaMode.Alt => 2,
            MicaMode.Disabled => 3,
            _ => 0,
        };

        var customColor = AppServices.Theme.CustomAccentColor;
        if (customColor is { } color)
        {
            CustomColorPreview.Fill = new SolidColorBrush(color);
            var matchedSwatch = SwatchPanel.Children.OfType<Button>()
                .FirstOrDefault(b => b.Background is SolidColorBrush brush && brush.Color == color);
            SelectSwatch(matchedSwatch); // null のまま = 完全なカスタム色（どのスウォッチとも一致しない）
        }
        else
        {
            SelectSwatch(SwatchDefault);
        }

        switch (settings.IconShape)
        {
            case IconShape.Circle:
                IconShapeSquircle.IsChecked = false;
                IconShapeCircle.IsChecked = true;
                break;
            case IconShape.RoundedSquare:
                IconShapeSquircle.IsChecked = false;
                IconShapeRoundedSquare.IsChecked = true;
                break;
            default:
                IconShapeSquircle.IsChecked = true;
                break;
        }

        // ON = モダンアイコン（S18a）
        LegacyIconsToggle.IsOn = !settings.LegacyIcons;

        PortTextBox.Text = settings.Port.ToString();
        AutostartToggle.IsOn = settings.AutostartWsa;
        AutoBackupToggle.IsOn = settings.AutoBackupRegistry;

        _timeoutSeconds = settings.InstallTimeout;
        TimeoutSlider.Value = _timeoutSeconds == 0 ? 105 : _timeoutSeconds;
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(TimeoutLabel)));

        LanguageCombo.SelectedIndex = settings.Locale switch
        {
            "en-US" => 1,
            "ja-JP" => 2,
            _ => 0,
        };

        var backupDir = string.IsNullOrEmpty(settings.BackupDirectory) ? DesktopDir : settings.BackupDirectory;
        BackupDirText.Text = backupDir == DesktopDir ? "Desktop" : backupDir;
        UpdateBackupResetVisibility();
    }

    private void ThemeMode_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if (_isRestoringSettings) return;
        var theme = ThemeModeCombo.SelectedIndex switch
        {
            1 => AppTheme.Light,
            2 => AppTheme.Dark,
            _ => AppTheme.System,
        };
        AppServices.Theme.SetTheme(theme);
    }

    private void Mica_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if (_isRestoringSettings) return;
        var mica = MicaCombo.SelectedIndex switch
        {
            1 => MicaMode.Partial,
            2 => MicaMode.Alt,
            3 => MicaMode.Disabled,
            _ => MicaMode.Full,
        };
        AppServices.Settings.Update(s => s.Mica = mica);
    }

    private void LegacyIcons_Toggled(object sender, RoutedEventArgs e)
    {
        if (_isRestoringSettings) return;
        AppServices.Settings.Update(s => s.LegacyIcons = !LegacyIconsToggle.IsOn);
    }

    private void Autostart_Toggled(object sender, RoutedEventArgs e)
    {
        if (_isRestoringSettings) return;
        AppServices.Settings.Update(s => s.AutostartWsa = AutostartToggle.IsOn);
    }

    private void AutoBackup_Toggled(object sender, RoutedEventArgs e)
    {
        if (_isRestoringSettings) return;
        AppServices.Settings.Update(s => s.AutoBackupRegistry = AutoBackupToggle.IsOn);
    }

    private void Language_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        if (_isRestoringSettings) return;
        var locale = LanguageCombo.SelectedIndex switch
        {
            1 => "en-US",
            2 => "ja-JP",
            _ => null,
        };
        AppServices.Settings.Update(s => s.Locale = locale);
    }

    private static string DesktopDir =>
        System.Environment.GetFolderPath(System.Environment.SpecialFolder.Desktop);

    // Reset appears only while the backup dir differs from the default Desktop (S16)
    private void UpdateBackupResetVisibility() =>
        BtnResetBackupDir.Visibility = BackupDirText.Text == DesktopDir || BackupDirText.Text == "Desktop"
            ? Visibility.Collapsed
            : Visibility.Visible;

    // --- Theme color swatches ---

    private void ThemeColorSwatch_Click(object sender, RoutedEventArgs e)
    {
        var swatch = (Button)sender;
        SelectSwatch(swatch);

        if (ReferenceEquals(swatch, SwatchDefault))
        {
            AppServices.Theme.SetAccentColor(null);
        }
        else if (swatch.Background is SolidColorBrush brush)
        {
            // "System" は選択した瞬間のOSアクセント色を保存する（以後は追随しない。§2.4）
            AppServices.Theme.SetAccentColor(brush.Color);
        }
    }

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
        // Slider ranges 15-105 in 5 s steps; position 105 means infinite (stored as 0)
        var raw = (int)e.NewValue;
        _timeoutSeconds = raw >= 105 ? 0 : raw;
        PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(nameof(TimeoutLabel)));

        if (_isRestoringSettings) return;
        AppServices.Settings.Update(s => s.InstallTimeout = _timeoutSeconds);
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

    private void IconShape_Checked(object sender, RoutedEventArgs e)
    {
        var box = (CheckBox)sender;
        ExclusiveCheck(IconShapeGroup, box);
        if (_isRestoringSettings) return;

        var shape = box switch
        {
            _ when ReferenceEquals(box, IconShapeCircle) => IconShape.Circle,
            _ when ReferenceEquals(box, IconShapeRoundedSquare) => IconShape.RoundedSquare,
            _ => IconShape.Squircle,
        };
        AppServices.Settings.Update(s => s.IconShape = shape);
    }

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
            AppServices.Theme.SetAccentColor(picker.Color);
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

    private string _portTextOnFocus = "58526";

    private void Port_GotFocus(object sender, RoutedEventArgs e) =>
        _portTextOnFocus = PortTextBox.Text;

    // WinUI never dismisses TextBox focus on Enter/Escape; do it explicitly.
    // Escape also restores the value the box had when it was focused.
    private void Port_KeyDown(object sender, Microsoft.UI.Xaml.Input.KeyRoutedEventArgs e)
    {
        if (e.Key == Windows.System.VirtualKey.Escape)
        {
            PortTextBox.Text = _portTextOnFocus;
            e.Handled = true;
            DefocusPort();
        }
        else if (e.Key == Windows.System.VirtualKey.Enter)
        {
            e.Handled = true;
            DefocusPort();
        }
    }

    private void PageBackground_PointerPressed(object sender, Microsoft.UI.Xaml.Input.PointerRoutedEventArgs e)
    {
        if (Microsoft.UI.Xaml.Input.FocusManager.GetFocusedElement(XamlRoot) is TextBox tb
            && ReferenceEquals(tb, PortTextBox))
        {
            DefocusPort();
        }
    }

    // Toggling IsEnabled is the least invasive way to drop focus without
    // adding a focusable sink element to the tab order
    private void DefocusPort()
    {
        PortTextBox.IsEnabled = false;
        PortTextBox.IsEnabled = true;
    }

    private void Port_LostFocus(object sender, RoutedEventArgs e)
    {
        if (!int.TryParse(PortTextBox.Text, out var port) || port <= 0)
        {
            PortTextBox.Text = DefaultPort.ToString();
            port = DefaultPort;
        }
        else if (port > 65535)
        {
            PortTextBox.Text = "65535";
            port = 65535;
        }

        if (_isRestoringSettings) return;
        if (AppServices.Settings.Current.Port != port) AppServices.Settings.Update(s => s.Port = port);
    }

    private void ResetPort_Click(object sender, RoutedEventArgs e)
    {
        PortTextBox.Text = DefaultPort.ToString();
        if (!_isRestoringSettings) AppServices.Settings.Update(s => s.Port = DefaultPort);
    }

    private void ResetBackupDir_Click(object sender, RoutedEventArgs e)
    {
        BackupDirText.Text = DesktopDir;
        UpdateBackupResetVisibility();
        if (!_isRestoringSettings) AppServices.Settings.Update(s => s.BackupDirectory = DesktopDir);
    }

    [DllImport("user32.dll")]
    private static extern IntPtr GetActiveWindow();

    private async void BrowseBackupDir_Click(object sender, RoutedEventArgs e)
    {
        var picker = new Windows.Storage.Pickers.FolderPicker();
        WinRT.Interop.InitializeWithWindow.Initialize(picker, GetActiveWindow());
        picker.FileTypeFilter.Add("*");

        var folder = await picker.PickSingleFolderAsync();
        if (folder is null) return;

        BackupDirText.Text = folder.Path;
        UpdateBackupResetVisibility();
        AppServices.Settings.Update(s => s.BackupDirectory = folder.Path);
    }
}
