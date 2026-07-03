using System.Text.Json.Serialization;

namespace WsaPacman.Models;

public enum AppTheme { System, Light, Dark }

public enum IconShape { Squircle, Circle, RoundedSquare }

public enum MicaMode { Full, Partial, Disabled, Alt }

/// <summary>Persisted settings POCO (内部処理設計書 §5.2). Serialized to options.json.</summary>
public sealed class AppSettings
{
    public string IpAddress { get; set; } = "127.0.0.1";
    public int Port { get; set; } = 58526;

    [JsonConverter(typeof(JsonStringEnumConverter))]
    public AppTheme Theme { get; set; } = AppTheme.System;

    [JsonConverter(typeof(JsonStringEnumConverter))]
    public IconShape IconShape { get; set; } = IconShape.Squircle;

    public bool LegacyIcons { get; set; }

    [JsonConverter(typeof(JsonStringEnumConverter))]
    public MicaMode Mica { get; set; } = MicaMode.Full;

    public bool AutostartWsa { get; set; }

    /// <summary>Seconds. Design-doc note: unused by the current install flow (fixed 300s timeout).</summary>
    public int InstallTimeout { get; set; } = 30;

    /// <summary>BCP-47 tag, or null for the system locale.</summary>
    public string? Locale { get; set; }

    /// <summary>"#AARRGGBB", or null for the default (Alpine Landing) color.</summary>
    public string? AccentColor { get; set; }

    public bool AutoBackupRegistry { get; set; } = true;

    public string BackupDirectory { get; set; } =
        Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
}
