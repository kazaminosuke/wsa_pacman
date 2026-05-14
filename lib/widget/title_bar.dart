// ignore_for_file: constant_identifier_names
import 'package:flutter/foundation.dart' show ValueListenable;
import 'package:fluent_ui/fluent_ui.dart';
import 'package:window_manager/window_manager.dart';

/// カスタムタイトルバー。
///
/// - 最大化中は上端リサイズハンドルを非表示にする。
/// - [WindowListener] で最大化イベントを受け取る。
class AppTitleBar extends StatefulWidget {
  final Color bgColor;
  final ValueListenable<int> dialogCount;
  final String title;
  final String version;

  const AppTitleBar({
    super.key,
    required this.bgColor,
    required this.dialogCount,
    required this.title,
    required this.version,
  });

  @override
  State<AppTitleBar> createState() => _AppTitleBarState();
}

class _AppTitleBarState extends State<AppTitleBar> with WindowListener {
  bool _isMaximized = false;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    // 起動時に最大化状態を同期
    windowManager.isMaximized().then((v) {
      if (mounted && v && !_isMaximized) {
        setState(() => _isMaximized = true);
      }
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowMaximize() => setState(() => _isMaximized = true);

  @override
  void onWindowUnmaximize() => setState(() => _isMaximized = false);

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ContentDialog(
        title: const Text('About WSA PacMan'),
        content: const Text(
          'WSA Package Manager (WSA PacMan) is a GUI package manager and '
          'package installer for Windows Subsystem for Android (WSA).\n\n'
          'This tool makes it easy to install, uninstall, and manage '
          'Android apps on your Windows 11 device.',
        ),
        actions: [
          Button(
            child: const Text('Close'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Layer 1: WindowCaption ─────────────────────────────
        // フル幅で背景・タイトル・システムボタンを描画。
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 32.0,
          child: ValueListenableBuilder<int>(
            valueListenable: widget.dialogCount,
            builder: (context, count, _) {
              return Stack(
                children: [
                  WindowCaption(
                    brightness: FluentTheme.of(context).brightness,
                    title: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _showAboutDialog(context),
                      child: Text.rich(
                        TextSpan(children: [
                          TextSpan(text: '${widget.title} '),
                          TextSpan(
                            text: 'v${widget.version}',
                            style: TextStyle(
                              color: Colors.grey[100],
                              fontSize: 12,
                            ),
                          ),
                        ]),
                      ),
                    ),
                    backgroundColor: widget.bgColor,
                  ),
                  // ダイアログ表示中のみ半透明オーバーレイ
                  if (count > 0)
                    IgnorePointer(
                      child: Container(
                        color: Colors.black.withValues(alpha: 0.4),
                      ),
                    ),
                ],
              );
            },
          ),
        ),

        // ── Layer 2: DragToMoveArea ────────────────────────────
        // 右 140px（システムボタン領域）を除いたドラッグ可能エリア。
        Positioned(
          top: 0,
          left: 0,
          right: 140,
          height: 32.0,
          child: DragToMoveArea(child: const SizedBox.expand()),
        ),

        // ── Layer 3: 上端リサイズハンドル ──────────────────────
        // 最大化中は完全に除外してリサイズ競合を防ぐ。
        if (!_isMaximized)
          Positioned(
            top: 0,
            left: 0,
            right: 140,
            height: 8,
            child: MouseRegion(
              cursor: SystemMouseCursors.resizeUpDown,
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onPanStart: (_) =>
                    windowManager.startResizing(ResizeEdge.top),
              ),
            ),
          ),
      ],
    );
  }
}
