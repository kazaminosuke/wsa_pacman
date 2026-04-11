// ignore_for_file: constant_identifier_names
import 'dart:developer';
import 'dart:ffi' hide Size;

import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart' hide MoveWindow;
import 'package:wsa_pacman/windows/win_info.dart';

/// Windows 11 Mica エフェクト (DWM_SYSTEMBACKDROP_TYPE) をネイティブ API で適用するユーティリティ。
///
/// flutter_acrylic を使わず、`win32` + `dart:ffi` のみで実装。
/// window_manager と共存できるよう、HWND 取得はウィンドウタイトル検索で行う。
///
/// ## 動作原理
/// 1. `WS_EX_NOREDIRECTIONBITMAP` — Flutter の DirectX サーフェスが DWM バックドロップを
///    遮らないようにする拡張スタイル。これがないと Mica が見えない。
/// 2. `DwmExtendFrameIntoClientArea(-1,-1,-1,-1)` — DWM フレームをクライアント領域全体に
///    拡張し、Mica が描画される領域を確保する。
/// 3. `DWMWA_SYSTEMBACKDROP_TYPE = DWMSBT_MAINWINDOW(2)` — Mica エフェクトを要求。
/// 4. Flutter 側で `Colors.transparent` を背景に設定することで Mica が透過して見える。
class MicaHelper {
  MicaHelper._();

  // ── DWM 属性 ID ──────────────────────────────────────────────
  /// DWMWA_USE_IMMERSIVE_DARK_MODE: タイトルバー・フレームのダーク/ライト切替
  static const int _DWMWA_USE_IMMERSIVE_DARK_MODE = 20;

  /// DWMWA_SYSTEMBACKDROP_TYPE: システムバックドロップ種別 (Windows 11 Build 22621+)
  static const int _DWMWA_SYSTEMBACKDROP_TYPE = 38;

  // ── DWM_SYSTEMBACKDROP_TYPE 値 ───────────────────────────────
  /// DWMSBT_NONE: バックドロップなし (= 既定の不透明ウィンドウに戻す)
  static const int _DWMSBT_NONE = 1;

  /// DWMSBT_MAINWINDOW: Mica エフェクト
  static const int _DWMSBT_MAINWINDOW = 2;

  // ── ウィンドウ拡張スタイル ────────────────────────────────────
  /// WS_EX_NOREDIRECTIONBITMAP: DWM がリダイレクションビットマップを作らないようにする。
  /// Flutter のような Direct3D レンダラーを使うアプリで Mica を透過させるために必須。
  static const int _WS_EX_NOREDIRECTIONBITMAP = 0x00200000;

  // ── キャッシュ（連続した同一設定での余計な API 呼び出しを防ぐ）────
  static bool? _lastMica;
  static bool? _lastDark;

  // ────────────────────────────────────────────────────────────
  // 公開 API
  // ────────────────────────────────────────────────────────────

  /// キャッシュと比較して変化があったときのみ Mica 設定を適用する。
  ///
  /// [windowTitle] でウィンドウを検索する。見つからない場合はフォアグラウンドウィンドウを使用。
  /// [force] を `true` にするとキャッシュを無視して必ず適用する（初回呼び出し時に推奨）。
  static void applyIfNeeded({
    required bool micaEnabled,
    required bool isDark,
    required String windowTitle,
    bool force = false,
  }) {
    if (!force && _lastMica == micaEnabled && _lastDark == isDark) return;
    _lastMica = micaEnabled;
    _lastDark = isDark;
    _apply(micaEnabled: micaEnabled, isDark: isDark, windowTitle: windowTitle);
  }

  /// キャッシュを更新しつつ強制適用する。
  /// `waitUntilReadyToShow` コールバック内での初回適用に使う。
  static void apply({
    required bool micaEnabled,
    required bool isDark,
    required String windowTitle,
  }) {
    _lastMica = micaEnabled;
    _lastDark = isDark;
    _apply(micaEnabled: micaEnabled, isDark: isDark, windowTitle: windowTitle);
  }

  // ────────────────────────────────────────────────────────────
  // 内部実装
  // ────────────────────────────────────────────────────────────

  static void _apply({
    required bool micaEnabled,
    required bool isDark,
    required String windowTitle,
  }) {
    try {
      using((arena) {
        // ── HWND 取得 ─────────────────────────────────────────
        // まずウィンドウタイトルで検索し、見つからなければフォアグラウンドウィンドウを使用
        final titlePtr = windowTitle.toNativeUtf16(allocator: arena);
        int hwnd = FindWindow(nullptr, titlePtr);
        if (hwnd == 0) hwnd = GetForegroundWindow();
        if (hwnd == 0) {
          log('[MicaHelper] HWND が見つかりません。スキップします。');
          return;
        }

        // ── 1. ダークモード設定 ───────────────────────────────
        // DWMWA_USE_IMMERSIVE_DARK_MODE でタイトルバーの色をテーマに合わせる
        final pDark = arena<Int32>()..value = isDark ? 1 : 0;
        DwmSetWindowAttribute(
          hwnd,
          _DWMWA_USE_IMMERSIVE_DARK_MODE,
          pDark.cast(),
          sizeOf<Int32>(),
        );

        // ── 2. Windows 11 専用: Mica バックドロップ ──────────
        if (!WinVer.isWindows11OrGreater) return;

        if (micaEnabled) {
          // WS_EX_NOREDIRECTIONBITMAP を付与:
          // Flutter の DirectX サーフェスが DWM バックドロップを遮らなくなる
          final exStyle = GetWindowLongPtr(hwnd, GWL_EXSTYLE);
          if (exStyle & _WS_EX_NOREDIRECTIONBITMAP == 0) {
            SetWindowLongPtr(
              hwnd,
              GWL_EXSTYLE,
              exStyle | _WS_EX_NOREDIRECTIONBITMAP,
            );
          }

          // DwmExtendFrameIntoClientArea({-1,-1,-1,-1}):
          // クライアント領域全体を DWM フレームとして扱い、Mica が描画される領域を確保する
          // MARGINS: cxLeftWidth, cxRightWidth, cyTopHeight, cyBottomHeight の順
          final pMargins = arena<Int32>(4);
          pMargins[0] = -1; // cxLeftWidth
          pMargins[1] = -1; // cxRightWidth
          pMargins[2] = -1; // cyTopHeight
          pMargins[3] = -1; // cyBottomHeight
          DwmExtendFrameIntoClientArea(hwnd, pMargins.cast());
        } else {
          // Mica 無効時: WS_EX_NOREDIRECTIONBITMAP を除去して通常描画に戻す
          final exStyle = GetWindowLongPtr(hwnd, GWL_EXSTYLE);
          if (exStyle & _WS_EX_NOREDIRECTIONBITMAP != 0) {
            SetWindowLongPtr(
              hwnd,
              GWL_EXSTYLE,
              exStyle & ~_WS_EX_NOREDIRECTIONBITMAP,
            );
          }
        }

        // ── 3. DWMWA_SYSTEMBACKDROP_TYPE を設定 ──────────────
        final pBackdrop = arena<Int32>()
          ..value = micaEnabled ? _DWMSBT_MAINWINDOW : _DWMSBT_NONE;
        DwmSetWindowAttribute(
          hwnd,
          _DWMWA_SYSTEMBACKDROP_TYPE,
          pBackdrop.cast(),
          sizeOf<Int32>(),
        );

        log('[MicaHelper] 適用完了: '
            'mica=$micaEnabled, dark=$isDark, '
            'hwnd=0x${hwnd.toRadixString(16).toUpperCase()}');
      });
    } catch (e, st) {
      // ネイティブエラーはアプリを落とさずログのみ
      log('[MicaHelper] エラー: $e\n$st');
    }
  }
}
