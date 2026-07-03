using System.Diagnostics;
using System.Net.NetworkInformation;
using System.Text.RegularExpressions;
using Microsoft.UI.Xaml.Controls;
using WsaPacman.Models;
using WsaPacman.Services.Core;

namespace WsaPacman.Services;

/// <summary>内部処理設計書 §2.7 / §3. WSA接続状態の検出・周期監視・状態遷移。</summary>
public interface IWsaStatusService : IDisposable
{
    WsaStatusSnapshot Current { get; }
    event EventHandler<WsaStatusSnapshot>? StatusChanged;

    void Start();
    void Stop();

    /// <summary>更新ボタン用（キャッシュ無効化込み）。</summary>
    Task<WsaStatusSnapshot> CheckNowAsync(CancellationToken ct = default);

    /// <summary>UNAUTHORIZED時の認証ボタン用（adb disconnect → connect）。</summary>
    Task ReconnectAsync(CancellationToken ct = default);

    /// <summary>起動/再起動ボタン押下時に呼ぶ。以後15秒間はSTARTING表示を維持する（§3.3）。</summary>
    void NotifyWsaStartRequested();
}

public sealed class WsaStatusService(
    IAdbService adb, IWsaEnvironment environment, ISettingsService settings,
    TimeProvider? timeProvider = null) : IWsaStatusService
{
    private static readonly TimeSpan PreAdbCacheDuration = TimeSpan.FromMilliseconds(1500);
    private static readonly TimeSpan StartingGrace = TimeSpan.FromSeconds(15);
    private static readonly TimeSpan AdbConnectProbeTimeout = TimeSpan.FromMilliseconds(200);

    // 行例: "127.0.0.1:58526\tdevice" / "localhost:58526\toffline"
    private static readonly Regex DeviceLineRegex =
        new(@"^(localhost|127\.0\.0\.1):(\d+)\s+(\S+)", RegexOptions.Multiline);
    private static readonly Regex ConnectFailedRegex =
        new("cannot connect|failed to connect", RegexOptions.IgnoreCase);
    private static readonly Regex AuthFailedRegex =
        new("cannot authenticate|failed to authenticate", RegexOptions.IgnoreCase);

    private readonly TimeProvider _time = timeProvider ?? TimeProvider.System;
    private readonly SemaphoreSlim _checkLock = new(1, 1);

    private (ConnectionStatus Status, DateTime TimestampUtc)? _preAdbCache;
    private DateTime? _lastStartUtc;
    private CancellationTokenSource? _loopCts;
    private Task? _loopTask;

    public WsaStatusSnapshot Current { get; private set; } = BuildSnapshot(ConnectionStatus.Unknown);

    public event EventHandler<WsaStatusSnapshot>? StatusChanged;

    public void Start()
    {
        if (_loopTask is not null) return;
        _loopCts = new CancellationTokenSource();
        _loopTask = RunLoopAsync(_loopCts.Token);
    }

    public void Stop()
    {
        _loopCts?.Cancel();
        _loopCts?.Dispose();
        _loopCts = null;
        _loopTask = null;
    }

    public void NotifyWsaStartRequested() => _lastStartUtc = _time.GetUtcNow().UtcDateTime;

    public async Task<WsaStatusSnapshot> CheckNowAsync(CancellationToken ct = default)
    {
        await _checkLock.WaitAsync(ct).ConfigureAwait(false);
        try
        {
            _preAdbCache = null; // invalidate cache so the refresh button always re-detects
            var status = await ComputeStatusAsync(ct).ConfigureAwait(false);
            var snapshot = BuildSnapshot(status);
            Current = snapshot;
            StatusChanged?.Invoke(this, snapshot);
            return snapshot;
        }
        finally
        {
            _checkLock.Release();
        }
    }

    public async Task ReconnectAsync(CancellationToken ct = default)
    {
        var ip = settings.Current.IpAddress;
        var port = settings.Current.Port;
        await adb.DisconnectAsync(ip, port, ct).ConfigureAwait(false);
        await adb.ConnectAsync(ip, port, ct: ct).ConfigureAwait(false);
        await CheckNowAsync(ct).ConfigureAwait(false);
    }

    private async Task RunLoopAsync(CancellationToken ct)
    {
        while (!ct.IsCancellationRequested)
        {
            try
            {
                await CheckNowAsync(ct).ConfigureAwait(false);
            }
            catch (OperationCanceledException)
            {
                break;
            }
            catch (Exception ex)
            {
                // A single bad cycle (unexpected exception) must not stop future polling.
                System.Diagnostics.Debug.WriteLine($"[WsaStatusService] cycle failed: {ex}");
            }

            try
            {
                await Task.Delay(PollingInterval(Current.Status), ct).ConfigureAwait(false);
            }
            catch (OperationCanceledException)
            {
                break;
            }
        }
    }

    private static TimeSpan PollingInterval(ConnectionStatus status) => status switch
    {
        ConnectionStatus.Missing or ConnectionStatus.Starting => TimeSpan.FromMilliseconds(500),
        ConnectionStatus.Arrested or ConnectionStatus.Offline => TimeSpan.FromMilliseconds(750),
        _ => TimeSpan.FromSeconds(5),
    };

    private async Task<ConnectionStatus> ComputeStatusAsync(CancellationToken ct)
    {
        var preAdb = DetectPreAdbStatus();
        var status = preAdb == ConnectionStatus.Connected
            ? await CheckAdbConnectionAsync(ct).ConfigureAwait(false)
            : preAdb; // steps 1-3 already conclusive (Unsupported/Missing/Arrested/Offline)

        return ApplyStartingGrace(status);
    }

    /// <summary>3段階の事前検出（①パッケージ ②プロセス ③ADBポート）。1500msキャッシュ付き。</summary>
    private ConnectionStatus DetectPreAdbStatus()
    {
        if (_preAdbCache is { } cached && _time.GetUtcNow().UtcDateTime - cached.TimestampUtc < PreAdbCacheDuration)
        {
            return cached.Status;
        }

        ConnectionStatus status;
        if (!environment.IsWsaInstalled)
        {
            status = environment.IsWindows11OrGreater ? ConnectionStatus.Missing : ConnectionStatus.Unsupported;
        }
        else if (Process.GetProcessesByName("WsaClient").Length == 0
            && Process.GetProcessesByName("WsaService").Length == 0)
        {
            status = ConnectionStatus.Arrested;
        }
        else if (!IsPortListening(settings.Current.Port))
        {
            status = ConnectionStatus.Offline;
        }
        else
        {
            status = ConnectionStatus.Connected; // tentative; refined by the adb steps below
        }

        _preAdbCache = (status, _time.GetUtcNow().UtcDateTime);
        return status;
    }

    private static bool IsPortListening(int port) =>
        IPGlobalProperties.GetIPGlobalProperties().GetActiveTcpListeners().Any(ep => ep.Port == port);

    /// <summary>④adb devices 判定 → 未確定なら ⑤adb connect 判定。</summary>
    private async Task<ConnectionStatus> CheckAdbConnectionAsync(CancellationToken ct)
    {
        var ip = settings.Current.IpAddress;
        var port = settings.Current.Port;

        var devices = await adb.DevicesAsync(ct).ConfigureAwait(false);
        var line = ParseDeviceLine(devices.StdOut, port);
        if (line is not null)
        {
            switch (line.Value.State)
            {
                case "offline":
                    return ConnectionStatus.Offline;
                case "unauthorized":
                    return ConnectionStatus.Unauthorized;
                case "device":
                    AutoCorrectIpAddress(line.Value.Address);
                    return ConnectionStatus.Connected;
                    // その他（"host" 等の遷移中の値）は ⑤ へフォールスルーして再接続を試みる。
            }
        }

        var connect = await adb.ConnectAsync(ip, port, AdbConnectProbeTimeout, ct).ConfigureAwait(false);
        var text = connect.StdOut + connect.StdErr;
        var communicationFailed = connect.IsTimeout || (connect.ExitCode != 0 && string.IsNullOrWhiteSpace(text));
        if (communicationFailed || ConnectFailedRegex.IsMatch(text))
        {
            // adb.exe自体が実行できなかった場合（embedded-tools不在等）も含め、
            // 「接続できなかった」として扱う。ここでadb devicesを一度でも呼ぶことが
            // adbサーバの起動条件でもあるため、事前にプロセス有無で早期リターンしない
            // （そうすると永久にUnknownのまま進行しなくなる）。
            return environment.IsWsaInstalled ? ConnectionStatus.Offline : ConnectionStatus.Disconnected;
        }
        if (AuthFailedRegex.IsMatch(text))
        {
            return ConnectionStatus.Unauthorized;
        }

        AutoCorrectIpAddress(ip);
        return ConnectionStatus.Connected;
    }

    private static (string Address, string State)? ParseDeviceLine(string devicesOutput, int port)
    {
        foreach (Match m in DeviceLineRegex.Matches(devicesOutput))
        {
            if (int.Parse(m.Groups[2].Value) == port)
            {
                return (m.Groups[1].Value, m.Groups[3].Value);
            }
        }
        return null;
    }

    /// <summary>接続確立を確認したアドレス表記（127.0.0.1/localhost）に設定値を合わせる。</summary>
    private void AutoCorrectIpAddress(string address)
    {
        if ((address is "127.0.0.1" or "localhost") && settings.Current.IpAddress != address)
        {
            settings.Update(s => s.IpAddress = address);
        }
    }

    /// <summary>lastStartから15秒以内にMissing/Arrested/Offlineが検出された場合、Startingへ上書きする（§3.3）。</summary>
    private ConnectionStatus ApplyStartingGrace(ConnectionStatus status)
    {
        if (_lastStartUtc is not { } lastStart) return status;
        if (_time.GetUtcNow().UtcDateTime - lastStart > StartingGrace) return status;

        return status is ConnectionStatus.Missing or ConnectionStatus.Arrested or ConnectionStatus.Offline
            ? ConnectionStatus.Starting
            : status;
    }

    private static WsaStatusSnapshot BuildSnapshot(ConnectionStatus status)
    {
        var severity = status switch
        {
            ConnectionStatus.Connected => InfoBarSeverity.Success,
            ConnectionStatus.Starting or ConnectionStatus.Unknown => InfoBarSeverity.Informational,
            ConnectionStatus.Arrested or ConnectionStatus.Offline or ConnectionStatus.Unauthorized => InfoBarSeverity.Warning,
            ConnectionStatus.Unsupported or ConnectionStatus.Missing or ConnectionStatus.Disconnected => InfoBarSeverity.Error,
            _ => InfoBarSeverity.Informational,
        };
        var (titleKey, descKey) = status switch
        {
            ConnectionStatus.Unsupported => ("status_unsupported", "status_unsupported_desc"),
            ConnectionStatus.Missing => ("status_missing", "status_missing_desc"),
            ConnectionStatus.Arrested => ("status_arrested", "status_arrested_desc"),
            ConnectionStatus.Starting => ("status_starting", "status_starting_desc"),
            ConnectionStatus.Offline => ("status_offline", "status_offline_desc"),
            ConnectionStatus.Disconnected => ("status_disconnected", "status_disconnected_desc"),
            ConnectionStatus.Connected => ("status_connected", "status_connected_desc"),
            ConnectionStatus.Unauthorized => ("status_unauthorized", "status_unauthorized_desc"),
            _ => ("status_unknown", "status_unknown_desc"),
        };
        return new WsaStatusSnapshot(status, severity, titleKey, descKey);
    }

    public void Dispose()
    {
        Stop();
        _checkLock.Dispose();
    }
}
