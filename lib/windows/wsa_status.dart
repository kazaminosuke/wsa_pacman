// ignore_for_file: constant_identifier_names
// lib/windows/wsa_status.dart
import 'dart:async';
import 'dart:io';

import 'package:wsa_pacman/main.dart';

/// 3-step WSA status detector — fully async (no UI-thread blocking).
///
/// Uses a stale-while-revalidate strategy:
///   • [getStatus] returns the last known cached value immediately (never blocks).
///   • A background [Future] re-runs the 3 detection steps once per
///     [_cacheIntervalMs] and atomically updates the cache when done.
///   • [waitForStatus] awaits the in-flight future if one is running.
///
/// Detection steps
///   1. `powershell Get-AppxPackage` → MISSING  if blank
///   2. `tasklist`                   → ARRESTED if WSA process absent
///   3. `netstat | findstr :port`    → OFFLINE  if port closed
///                                    → CONNECTED if port open
class WSAStatus {
  // ── Constants (no magic numbers / hard-coded strings) ────────────────────
  static const String _wsaPackageQuery = '*WindowsSubsystemForAndroid*';
  static const String _wsaProcessName1 = 'WsaClient.exe';
  static const String _wsaProcessName2 = 'WsaService.exe';
  static const int _adbPort = 58526;
  static const int _cacheIntervalMs = 1500;

  // ── Cache ────────────────────────────────────────────────────────────────
  static ConnectionStatus _cachedStatus = ConnectionStatus.UNKNOWN;
  static int _lastCheckMs = 0;
  static Future<ConnectionStatus>? _inFlight;

  // ── Public API ────────────────────────────────────────────────────────────

  /// Returns the last known status immediately (stale-but-fast).
  /// Simultaneously kicks off a background refresh if the cache is stale,
  /// so the *next* call (or a [waitForStatus] call) gets a fresh value.
  static ConnectionStatus getStatus() {
    _scheduleRefreshIfNeeded();
    return _cachedStatus;
  }

  /// Awaits the current in-flight detection and returns a fresh status.
  /// Use this in contexts where accuracy is more important than latency
  /// (e.g., the Refresh button).
  static Future<ConnectionStatus> waitForStatus() {
    _scheduleRefreshIfNeeded();
    return _inFlight ?? Future.value(_cachedStatus);
  }

  /// Clears the result cache so the next [getStatus] / [waitForStatus] call
  /// triggers fresh OS checks.
  static void invalidateCache() {
    _lastCheckMs = 0;
    _inFlight = null;
  }

  // ── Back-compat Boolean helpers ───────────────────────────────────────────
  // These remain purely synchronous (return from cache) so that any remaining
  // callers compile without changes. The cache is kept fresh in the background.

  /// `true` when WSA is installed and a WSA process is running.
  static bool get isBooted {
    final s = getStatus();
    return s != ConnectionStatus.MISSING &&
        s != ConnectionStatus.UNSUPPORTED &&
        s != ConnectionStatus.ARRESTED;
  }

  /// `true` when a WSA process (WsaClient.exe or WsaService.exe) is found.
  static bool get isRunning => isBooted;

  /// `true` when the ADB port is confirmed open.
  static bool get isAdbReady => getStatus() == ConnectionStatus.CONNECTED;

  // ── Internal ──────────────────────────────────────────────────────────────

  static void _scheduleRefreshIfNeeded() {
    final now = DateTime.now().millisecondsSinceEpoch;
    // Already refreshing, or cache still fresh → nothing to do.
    if (_inFlight != null || now - _lastCheckMs <= _cacheIntervalMs) return;

    _lastCheckMs = now;
    _inFlight = _detectAsync().then((status) {
      _cachedStatus = status;
      _inFlight = null;
      return status;
    });
  }

  /// All OS queries run via [Process.run] (non-blocking) so the Flutter
  /// event loop is never stalled, regardless of how long PowerShell or
  /// netstat take to respond.
  static Future<ConnectionStatus> _detectAsync() async {
    try {
      // ── Step 1: AppxPackage presence ────────────────────────────────────
      final pkgResult = await Process.run(
        'powershell',
        ['-NoProfile', '-Command', 'Get-AppxPackage $_wsaPackageQuery'],
      );
      if (pkgResult.stdout.toString().trim().isEmpty) {
        return ConnectionStatus.MISSING;
      }

      // ── Step 2: Process running check ───────────────────────────────────
      final taskResult = await Process.run('tasklist', []);
      final taskOut = taskResult.stdout.toString();
      if (!taskOut.contains(_wsaProcessName1) &&
          !taskOut.contains(_wsaProcessName2)) {
        return ConnectionStatus.ARRESTED;
      }

      // ── Step 3: ADB port open check ─────────────────────────────────────
      final netstatResult = await Process.run(
        'cmd',
        ['/c', 'netstat -ano | findstr LISTENING | findstr :$_adbPort'],
      );
      if (!netstatResult.stdout.toString().contains(':$_adbPort')) {
        return ConnectionStatus.OFFLINE;
      }

      return ConnectionStatus.CONNECTED;
    } catch (_) {
      return ConnectionStatus.UNKNOWN;
    }
  }
}
