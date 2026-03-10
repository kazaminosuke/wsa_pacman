// ignore_for_file: constant_identifier_names
// lib/windows/wsa_status.dart
import 'dart:io';

import 'package:wsa_pacman/main.dart';

/// 3-step WSA status detector.
///
/// Step 1: AppxPackage presence    → MISSING  if absent
/// Step 2: WsaClient / WsaService  → ARRESTED if not running
/// Step 3: ADB port open check     → OFFLINE  if port closed
///                                  → CONNECTED if port open
class WSAStatus {
  // ── Constants (no magic numbers) ──────────────────────────────────────────
  static const String _wsaPackageQuery = '*WindowsSubsystemForAndroid*';
  static const String _wsaProcessName1 = 'WsaClient.exe';
  static const String _wsaProcessName2 = 'WsaService.exe';
  static const int _adbPort = 58526;
  static const int _cacheIntervalMs = 1000;

  // ── Cache ─────────────────────────────────────────────────────────────────
  static ConnectionStatus _cachedStatus = ConnectionStatus.UNKNOWN;
  static int _lastCheckMs = 0;

  // ── Public API ────────────────────────────────────────────────────────────

  /// Returns the current WSA connection status by performing up to 3 checks.
  /// Results are cached for [_cacheIntervalMs] ms to avoid hammering the OS.
  static ConnectionStatus getStatus() {
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastCheckMs > _cacheIntervalMs) {
      _lastCheckMs = now;
      _cachedStatus = _detect();
    }
    return _cachedStatus;
  }

  // ── Back-compat helpers (used by legacy callers if any still exist) ────────

  /// `true` when WSA is installed and at least one WSA process is running.
  static bool get isBooted {
    final s = getStatus();
    return s != ConnectionStatus.MISSING &&
        s != ConnectionStatus.UNSUPPORTED &&
        s != ConnectionStatus.ARRESTED;
  }

  /// `true` when a WSA process (`WsaClient.exe` or `WsaService.exe`) is found.
  static bool get isRunning {
    final s = getStatus();
    return s != ConnectionStatus.MISSING &&
        s != ConnectionStatus.UNSUPPORTED &&
        s != ConnectionStatus.ARRESTED;
  }

  /// `true` when the ADB port is confirmed open.
  static bool get isAdbReady => getStatus() == ConnectionStatus.CONNECTED;

  // ── Internal detection logic ──────────────────────────────────────────────

  static ConnectionStatus _detect() {
    try {
      // ── Step 1: AppxPackage presence ──────────────────────────────────────
      final pkgResult = Process.runSync(
        'powershell',
        ['-NoProfile', '-Command', 'Get-AppxPackage $_wsaPackageQuery'],
      );
      final pkgOut = pkgResult.stdout.toString().trim();
      if (pkgOut.isEmpty) {
        return ConnectionStatus.MISSING;
      }

      // ── Step 2: Process running check ─────────────────────────────────────
      final taskResult = Process.runSync('tasklist', []);
      final taskOut = taskResult.stdout.toString();
      final processRunning = taskOut.contains(_wsaProcessName1) ||
          taskOut.contains(_wsaProcessName2);
      if (!processRunning) {
        return ConnectionStatus.ARRESTED;
      }

      // ── Step 3: ADB port open check ───────────────────────────────────────
      final netstatResult = Process.runSync(
        'cmd',
        ['/c', 'netstat -ano | findstr LISTENING | findstr :$_adbPort'],
      );
      final netstatOut = netstatResult.stdout.toString();
      if (!netstatOut.contains(':$_adbPort')) {
        return ConnectionStatus.OFFLINE;
      }

      return ConnectionStatus.CONNECTED;
    } catch (_) {
      return ConnectionStatus.UNKNOWN;
    }
  }
}
