namespace WsaPacman.Models;

/// <summary>ApkReaderService の解析結果（aapt dump badging 由来）。</summary>
public sealed record ApkInfo(
    string Package,
    int VersionCode,
    string VersionName,
    string Label,
    IReadOnlyList<AndroidPermission> Permissions,
    byte[]? IconBytes);

/// <summary>APK解析（aapt呼び出し・展開）が失敗した場合の例外。ErrorCodeはInstallerWindowのエラー表示に使う。</summary>
public sealed class ApkReadException(string errorCode, string message) : Exception(message)
{
    public string ErrorCode { get; } = errorCode;
}
