import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:wsa_pacman/windows/win_reg.dart';
import 'package:wsa_pacman/windows/win_pkg.dart';

import 'package:wsa_pacman/utils/wsa_utils.dart';
import 'package:wsa_pacman/utils/string_utils.dart';

class Env {
  static final String SYSTEM_ROOT = Platform.environment["SystemRoot"] ?? "";
  static final String USER_PROFILE = Platform.environment["UserProfile"] ?? "";

  // 実行ファイル（.exe）があるディレクトリを取得
  static String get EXEC_DIR => File(Platform.resolvedExecutable).parent.path;

  // 絶対パスでツールフォルダを指定
  static String get TOOLS_DIR {
    final releasePath = "$EXEC_DIR\\embedded-tools";
    if (Directory(releasePath).existsSync()) return releasePath;
    
    // デバッグ実行時（D:\wsatools\wsa_pacman\build\windows\x64\runner\Debug）からプロジェクトルートの embedded-tools を探す
    // 5つ上の階層がプロジェクトルート
    final debugPath = path.normalize(path.join(EXEC_DIR, "..", "..", "..", "..", "..", "embedded-tools"));
    if (Directory(debugPath).existsSync()) return debugPath;

    return releasePath; // fallback
  }

  static final String POWERSHELL = WinReg.getString(
              RegHKey.HKEY_LOCAL_MACHINE,
              r'SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell',
              'Path')
          ?.value ??
      '$SYSTEM_ROOT\\System32\\WindowsPowerShell\\v1.0\\powershell.exe';

  static final String WSA_SYSTEM_PATH = RegExp(
              r'^(.*)[\\/]+[^\\/]*[\\/]+[^\\/]*$')
          .firstMatch(WinReg.getString(
                      RegHKey.HKEY_LOCAL_MACHINE,
                      r'SYSTEM\CurrentControlSet\Services\WsaService',
                      'ImagePath')
                  ?.value
                  .unquoted ??
              WinReg.getString(
                      RegHKey.HKEY_CURRENT_USER,
                      r'Software\Microsoft\Windows\CurrentVersion\App Paths\WsaClient.exe',
                      null)
                  ?.value ??
              '')
          ?.group(1) ??
      '';

  static final String WSA_EXECUTABLE =
      '$WSA_SYSTEM_PATH\\WsaClient\\WsaClient.exe';
  static final bool WSA_INSTALLED =
      File('$WSA_SYSTEM_PATH\\AppxManifest.xml').existsSync();
  static final WSA_INFO = WSAPkgInfo.fromSystemPath(WSA_SYSTEM_PATH);
}
