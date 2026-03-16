// ignore_for_file: non_constant_identifier_names

import 'dart:io';

bool testFlag(int value, int attribute) => value & attribute == attribute;

/// Represents the version number (e.g. 10.0)
class WinVer {
  int major;
  int minor;
  WinVer._(this.major, this.minor);

  // 危険なWMI呼び出しはクラッシュの元なので無効化
  static final String WIN_CAPTION = '';

  @override String toString() => '$major.$minor';

  // Dart標準機能を使って安全にOSのビルド番号を取得する
  static final int buildNumber = () {
    if (!Platform.isWindows) return 0;
    // 例: "Windows 10 Pro (OS Build 22621.1848)" から "22621" を抽出
    final RegExp regex = RegExp(r'Build (\d+)');
    final match = regex.firstMatch(Platform.operatingSystemVersion);
    return match != null ? (int.tryParse(match.group(1) ?? '0') ?? 0) : 0;
  }();

  // 危険な GetVersionEx を廃止し、ビルド番号からの判定に変更
  static final WinVer version = () {
    if (buildNumber >= 22000) return WinVer._(10, 0); // Windows 11
    if (buildNumber >= 10240) return WinVer._(10, 0); // Windows 10
    if (buildNumber >= 9200) return WinVer._(6, 2);  // Windows 8
    if (buildNumber >= 7600) return WinVer._(6, 1);  // Windows 7
    if (buildNumber >= 6000) return WinVer._(6, 0);  // Windows Vista
    return WinVer._(5, 1);                           // Windows XP
  }();

  static bool isAtLeast(int major, int minor) => 
      version.major > major || version.major == major && version.minor >= minor;

  static final bool isWindowsXPOrGreater = isAtLeast(5, 1);
  static final bool isWindowsVistaOrGreater = isAtLeast(6, 0);
  static final bool isWindows7OrGreater = isAtLeast(6, 1);
  static final bool isWindows8OrGreater = isAtLeast(6, 2);
  static final bool isWindows10OrGreater = isAtLeast(10, 0);
  
  // Windows 11はビルド番号22000以上かどうかで安全・確実に判定！
  static final bool isWindows11OrGreater = buildNumber >= 22000;
}