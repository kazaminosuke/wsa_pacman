// lib/windows/wsa_status.dart
import 'dart:io';

class WSAStatus {
  static bool _isRunningCache = false;
  static bool _isAdbReadyCache = false; // ★ 追加: ADBが接続可能かどうかのキャッシュ
  static int _lastCheck = 0;

  static bool get isBooted => isRunning;

  // 既存の「プロセスが起動しているか」のチェック
  static bool get isRunning {
    _updateStatusIfNeeded();
    return _isRunningCache;
  }

  // ★ 追加: 「開発者モードがオンで、ADBポートが開いているか」のチェック
  static bool get isAdbReady {
    _updateStatusIfNeeded();
    return _isAdbReadyCache;
  }

  static void _updateStatusIfNeeded() {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // 1秒に1回だけチェックを走らせる
    if (now - _lastCheck > 1000) {
      _lastCheck = now;
      try {
        // 1. WsaClient.exe が存在するかチェック
        final taskResult = Process.runSync('tasklist', ['/FI', 'IMAGENAME eq WsaClient.exe']);
        final taskOut = taskResult.stdout.toString();
        _isRunningCache = taskOut.contains('WsaClient.exe');

        // 2. ★ 開発者モード(ADB)のチェック
        // WSAが起動している場合のみ、ポート58526(WSAのデフォルト)が開いているか調べる
        if (_isRunningCache) {
          // netstat -ano | findstr LISTENING | findstr :58526
          final netstatResult = Process.runSync('cmd', ['/c', 'netstat -ano | findstr LISTENING | findstr :58526']);
          final netstatOut = netstatResult.stdout.toString();
          
          // 出力に 58526 が含まれていれば、開発者モードがONで接続待ち状態
          _isAdbReadyCache = netstatOut.contains(':58526');
        } else {
          _isAdbReadyCache = false;
        }

      } catch (e) {
        _isRunningCache = false;
        _isAdbReadyCache = false;
      }
    }
  }
}