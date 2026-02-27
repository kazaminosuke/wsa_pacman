import 'dart:io';

class WSAStatus {
  static bool _isRunningCache = false;
  static int _lastCheck = 0;

  static bool get isBooted => isRunning;

  static bool get isRunning {
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // 1秒に1回だけ、WSAのプロセスを超高速で検索する
    if (now - _lastCheck > 1000) {
      _lastCheck = now;
      try {
        // /FI (フィルター) オプションをつけることで、一瞬で検索を終わらせる
        final result = Process.runSync('tasklist', ['/FI', 'IMAGENAME eq WsaClient.exe']);
        final out = result.stdout.toString();
        
        // "WsaClient.exe" という文字が見つかれば起動中
        _isRunningCache = out.contains('WsaClient.exe');
      } catch (e) {
        _isRunningCache = false;
      }
    }
    return _isRunningCache;
  }
}