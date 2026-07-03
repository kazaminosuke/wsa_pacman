namespace WsaPacman.Models;

/// <summary>ApkInstallService の進捗状態（設計書§2.11 InstallProgress が保持する状態）。</summary>
public enum InstallState { Installing, Success, Error, Timeout }
