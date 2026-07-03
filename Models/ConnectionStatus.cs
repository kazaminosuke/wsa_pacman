namespace WsaPacman.Models;

/// <summary>WSA connection state (内部処理設計書 §3.1). Mirrors the Flutter version's 9-value enum.</summary>
public enum ConnectionStatus
{
    Unsupported,
    Missing,
    Unknown,
    Arrested,
    Starting,
    Offline,
    Disconnected,
    Connected,
    Unauthorized,
}
