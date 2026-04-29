// ignore_for_file: constant_identifier_names, curly_braces_in_flow_control_structures
import 'dart:developer';
import 'dart:ffi' hide Size;

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart' hide MoveWindow;
import 'package:wsa_pacman/windows/win_info.dart';

/// Windows 11 Mica エフェクト (DWM_SYSTEMBACKDROP_TYPE) をネイティブ API で適用するユーティリティ。
///
/// flutter_acrylic を使わず、`win32` + `dart:ffi` のみで実装。
/// window_manager と共存できるよう、HWND 取得はウィンドウタイトル検索で行う。
class MicaHelper {
  MicaHelper._();

  // ── DWM 属性 ID ──────────────────────────────────────────────
  static const int _DWMWA_USE_IMMERSIVE_DARK_MODE = 20;
  static const int _DWMWA_SYSTEMBACKDROP_TYPE = 38;

  // Windows 11 Build 22000-22620 (21H2) 向け旧 Mica 属性
  static const int _DWMWA_MICA_EFFECT = 1029;

  // ── DWM_SYSTEMBACKDROP_TYPE 値 ───────────────────────────────
  static const int _DWMSBT_NONE = 1;
  static const int _DWMSBT_MAINWINDOW = 2;
  static const int _DWMSBT_TABBEDWINDOW = 4;

  // ── ウィンドウ拡張スタイル ────────────────────────────────────
  static const int _WS_EX_NOREDIRECTIONBITMAP = 0x00200000;

  // ── SetWindowPos フラグ ───────────────────────────────────────
  static const int _SWP_NOSIZE = 0x0001;
  static const int _SWP_NOMOVE = 0x0002;
  static const int _SWP_NOZORDER = 0x0004;
  static const int _SWP_FRAMECHANGED = 0x0020;

  // ── キャッシュ ────────────────────────────────────────────────
  static bool? _lastMica;
  static bool? _lastDark;
  static bool? _lastMicaAlt;

  // ────────────────────────────────────────────────────────────
  // 公開 API
  // ────────────────────────────────────────────────────────────

  /// キャッシュと比較して変化があったときのみ Mica 設定を適用する。
  static void applyIfNeeded({
    required bool micaEnabled,
    required bool isDark,
    required String windowTitle,
    bool micaAlt = false,
    bool force = false,
  }) {
    if (!force &&
        _lastMica == micaEnabled &&
        _lastDark == isDark &&
        _lastMicaAlt == micaAlt) return;
    _lastMica = micaEnabled;
    _lastDark = isDark;
    _lastMicaAlt = micaAlt;
    _apply(
        micaEnabled: micaEnabled,
        isDark: isDark,
        windowTitle: windowTitle,
        micaAlt: micaAlt);
  }

  /// キャッシュを更新しつつ強制適用する（初回適用用）。
  static void apply({
    required bool micaEnabled,
    required bool isDark,
    required String windowTitle,
    bool micaAlt = false,
  }) {
    _lastMica = micaEnabled;
    _lastDark = isDark;
    _lastMicaAlt = micaAlt;
    _apply(
        micaEnabled: micaEnabled,
        isDark: isDark,
        windowTitle: windowTitle,
        micaAlt: micaAlt);
  }

  // ────────────────────────────────────────────────────────────
  // 内部実装
  // ────────────────────────────────────────────────────────────

  static void _apply({
    required bool micaEnabled,
    required bool isDark,
    required String windowTitle,
    bool micaAlt = false,
  }) {
    try {
      using((arena) {
        // ── HWND 取得 ─────────────────────────────────────────
        final titlePtr = windowTitle.toNativeUtf16(allocator: arena);
        int hwnd = FindWindow(nullptr, titlePtr);
        if (hwnd == 0) hwnd = GetForegroundWindow();
        if (hwnd == 0) {
          log('[MicaHelper] HWND が見つかりません。スキップします。');
          return;
        }

        // ── 1. WS_EX_NOREDIRECTIONBITMAP (Win11 のみ) ─────────
        // Flutter の DirectX サーフェスが DWM バックドロップを遮らないようにする。
        // Mica が見えるために必須。Mica 有効/無効に応じて付け外しする。
        if (WinVer.isWindows11OrGreater) {
          final exStyle = GetWindowLongPtr(hwnd, GWL_EXSTYLE);
          if (micaEnabled) {
            if (exStyle & _WS_EX_NOREDIRECTIONBITMAP == 0) {
              SetWindowLongPtr(
                  hwnd, GWL_EXSTYLE, exStyle | _WS_EX_NOREDIRECTIONBITMAP);
            }
          } else {
            if (exStyle & _WS_EX_NOREDIRECTIONBITMAP != 0) {
              SetWindowLongPtr(
                  hwnd, GWL_EXSTYLE, exStyle & ~_WS_EX_NOREDIRECTIONBITMAP);
            }
          }
        }

        // ── 2. DwmExtendFrameIntoClientArea (Win11 + Mica 有効時のみ) ──
        // クライアント領域全体を DWM フレームとして扱い Mica の描画領域を確保する。
        if (WinVer.isWindows11OrGreater && micaEnabled) {
          final pMargins = arena<Int32>(4);
          pMargins[0] = -1; // cxLeftWidth
          pMargins[1] = -1; // cxRightWidth
          pMargins[2] = -1; // cyTopHeight
          pMargins[3] = -1; // cyBottomHeight
          DwmExtendFrameIntoClientArea(hwnd, pMargins.cast());
        }

        // ── 3. DWMWA_USE_IMMERSIVE_DARK_MODE (20) ─────────────
        // タイトルバー・フレームをダーク/ライトに切り替える。
        // アプリの ThemeMode 設定から導出した isDark を使用し、OS 側の
        // platformBrightness には依存しない。
        final pDark = arena<Int32>()..value = isDark ? 1 : 0;
        DwmSetWindowAttribute(
          hwnd,
          _DWMWA_USE_IMMERSIVE_DARK_MODE,
          pDark.cast(),
          sizeOf<Int32>(),
        );

        // ── 4. バックドロップ種別 (Win11 のみ) ───────────────
        // Build 22621+ : DWMWA_SYSTEMBACKDROP_TYPE (38)
        // Build 22000-22620: DWMWA_MICA_EFFECT (1029) でフォールバック
        if (WinVer.isWindows11OrGreater) {
          if (WinVer.buildNumber >= 22621) {
            final int backdropType;
            if (!micaEnabled) {
              backdropType = _DWMSBT_NONE;
            } else if (micaAlt) {
              backdropType = _DWMSBT_TABBEDWINDOW;
            } else {
              backdropType = _DWMSBT_MAINWINDOW;
            }
            final pBackdrop = arena<Int32>()..value = backdropType;
            DwmSetWindowAttribute(
              hwnd,
              _DWMWA_SYSTEMBACKDROP_TYPE,
              pBackdrop.cast(),
              sizeOf<Int32>(),
            );
          } else {
            // 旧 Windows 11 (21H2): DWMWA_MICA_EFFECT のみ対応
            // MicaAlt は非対応のため、有効なら通常 Mica として扱う
            final pMica = arena<Int32>()..value = micaEnabled ? 1 : 0;
            DwmSetWindowAttribute(
              hwnd,
              _DWMWA_MICA_EFFECT,
              pMica.cast(),
              sizeOf<Int32>(),
            );
          }
        }

        // ── 5. フレーム変更を DWM に通知 ─────────────────────
        // SWP_FRAMECHANGED で NC 領域の再描画を強制し、属性変更を即時反映させる。
        SetWindowPos(
          hwnd,
          0,
          0,
          0,
          0,
          0,
          _SWP_NOMOVE | _SWP_NOSIZE | _SWP_NOZORDER | _SWP_FRAMECHANGED,
        );

        log('[MicaHelper] 適用完了: '
            'mica=$micaEnabled, alt=$micaAlt, dark=$isDark, '
            'build=${WinVer.buildNumber}, '
            'hwnd=0x${hwnd.toRadixString(16).toUpperCase()}');
      });
    } catch (e, st) {
      log('[MicaHelper] エラー: $e\n$st');
    }
  }
}
