using WsaPacman.Services.Core;

namespace WsaPacman.Services;

/// <summary>内部処理設計書 §2.12. UninstallString の同期（--sync）／解除（--unsync）。</summary>
public interface IAppSyncService
{
    /// <summary>WSA由来のUninstallエントリを検出し、自exeの --uninstall 呼び出しへ書き換える。戻り値: 書き換えた件数。</summary>
    Task<int> SyncAsync(CancellationToken ct = default);

    /// <summary>自アプリに紐付いたエントリをWsaClient.exeの呼び出しへ復元する。戻り値: 復元した件数。</summary>
    Task<int> UnsyncAsync(CancellationToken ct = default);
}

public sealed class AppSyncService(IRegistryService registry, IWsaEnvironment environment) : IAppSyncService
{
    public Task<int> SyncAsync(CancellationToken ct = default)
    {
        // §7-6: sync/インストール登録間の引用符揺れをなくすため、常にクォート有りに統一する。
        var exePath = Environment.ProcessPath ?? "";
        var entries = registry.EnumerateWsaEntries();
        foreach (var entry in entries)
        {
            ct.ThrowIfCancellationRequested();
            registry.SetUninstallStrings(entry.Package, $"\"{exePath}\" --uninstall \"{entry.Package}\"");
        }
        return Task.FromResult(entries.Count);
    }

    public Task<int> UnsyncAsync(CancellationToken ct = default)
    {
        var localAppData = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
        var wsaClientPath = Path.Combine(
            localAppData, "Microsoft", "WindowsApps", environment.WsaFamilyName, "WsaClient.exe");

        var entries = registry.EnumeratePacmanEntries();
        foreach (var entry in entries)
        {
            ct.ThrowIfCancellationRequested();
            // sync_apps.dart runUnsyncApps() が書き込むのと同じ書式（WSA公式の呼び出し規約に合わせる）。
            registry.SetUninstallStrings(entry.Package, $"\"{wsaClientPath}\" /uninstall {entry.Package}");
        }
        return Task.FromResult(entries.Count);
    }
}
