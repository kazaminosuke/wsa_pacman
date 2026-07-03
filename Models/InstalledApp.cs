namespace WsaPacman.Models;

public enum InstalledAppSource { Registry, AdbOnly }

/// <summary>内部処理設計書 §2.10. InstalledAppsService.ScanAsync の結果1件。</summary>
public sealed record InstalledApp(
    string Package, string DisplayName,
    InstalledAppSource Source,
    string? UninstallString, string? DisplayIcon);
