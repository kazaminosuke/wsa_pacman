using Microsoft.UI.Xaml.Controls;

namespace WsaPacman.Models;

/// <summary>内部処理設計書 §2.7. Text is returned as resource keys; the UI layer resolves them.</summary>
public sealed record WsaStatusSnapshot(
    ConnectionStatus Status,
    InfoBarSeverity Severity,
    string TitleKey,
    string DescriptionKey);
