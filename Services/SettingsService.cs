using System.Text.Json;
using WsaPacman.Models;

namespace WsaPacman.Services;

/// <summary>内部処理設計書 §2.3 / §5. 設定の永続化（options.json）。</summary>
public interface ISettingsService
{
    AppSettings Current { get; }
    event EventHandler<AppSettings>? SettingsChanged;

    Task SaveAsync();
    void Update(Action<AppSettings> mutate);
}

public sealed class SettingsService : ISettingsService, IDisposable
{
    private static readonly string Directory_ =
        Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.UserProfile), ".wsa-pacman");
    private static readonly string FilePath = Path.Combine(Directory_, "options.json");

    private static readonly JsonSerializerOptions JsonOptions = new() { WriteIndented = true };

    private readonly SemaphoreSlim _lock = new(1, 1);
    private readonly FileSystemWatcher? _watcher;
    private DateTime _lastSelfWriteUtc;

    public AppSettings Current { get; private set; }

    public event EventHandler<AppSettings>? SettingsChanged;

    public SettingsService()
    {
        System.IO.Directory.CreateDirectory(Directory_);
        Current = LoadSync();

        try
        {
            _watcher = new FileSystemWatcher(Directory_, "options.json")
            {
                NotifyFilter = NotifyFilters.LastWrite,
            };
            _watcher.Changed += OnFileChanged;
            _watcher.EnableRaisingEvents = true;
        }
        catch
        {
            // Watching is a convenience (multi-instance sync); failure to set it up is not fatal.
        }
    }

    private static AppSettings LoadSync()
    {
        try
        {
            if (!File.Exists(FilePath)) return new AppSettings();
            var json = File.ReadAllText(FilePath);
            return JsonSerializer.Deserialize<AppSettings>(json, JsonOptions) ?? new AppSettings();
        }
        catch
        {
            // Corrupt/unreadable JSON falls back to defaults (Flutter版の InvalidProtocolBufferException 同等).
            return new AppSettings();
        }
    }

    public void Update(Action<AppSettings> mutate)
    {
        mutate(Current);
        _ = SaveAsync();
    }

    public async Task SaveAsync()
    {
        await _lock.WaitAsync().ConfigureAwait(false);
        try
        {
            var json = JsonSerializer.Serialize(Current, JsonOptions);
            var tempPath = FilePath + ".tmp";
            await File.WriteAllTextAsync(tempPath, json).ConfigureAwait(false);

            _lastSelfWriteUtc = DateTime.UtcNow;
            if (File.Exists(FilePath))
            {
                File.Replace(tempPath, FilePath, null);
            }
            else
            {
                File.Move(tempPath, FilePath);
            }
        }
        finally
        {
            _lock.Release();
        }
        SettingsChanged?.Invoke(this, Current);
    }

    private void OnFileChanged(object sender, FileSystemEventArgs e)
    {
        // Skip the notification our own SaveAsync just produced.
        if ((DateTime.UtcNow - _lastSelfWriteUtc).TotalMilliseconds < 500) return;

        try
        {
            Current = LoadSync();
            SettingsChanged?.Invoke(this, Current);
        }
        catch
        {
            // Transient read failure (file mid-write by another instance) — next change event retries.
        }
    }

    public void Dispose() => _watcher?.Dispose();
}
