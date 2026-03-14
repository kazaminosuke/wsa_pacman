import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:wsa_pacman/global_state.dart';
import 'package:wsa_pacman/main.dart';
import 'package:window_manager/window_manager.dart';
import 'package:wsa_pacman/widget/move_window_nomax.dart';
import 'package:wsa_pacman/utils/wsa_utils.dart';

class ApkUninstaller extends StatefulWidget {
  const ApkUninstaller({super.key});

  @override
  State<ApkUninstaller> createState() => _ApkUninstallerState();
}

class _ApkUninstallerState extends State<ApkUninstaller> {
  bool _isProcessing = false;
  String _statusMessage = "";
  bool _success = false;
  String _appName = "";
  String _displayIcon = "";

  @override
  void initState() {
    super.initState();
    _fetchAppInfo();
  }

  Future<void> _fetchAppInfo() async {
    final package = Constants.uninstallPackage;
    if (package.isEmpty) return;

    try {
      final process = await Process.run('powershell', [
        '-NoProfile',
        '-Command',
        '\$app = Get-ItemProperty "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\$package" -ErrorAction SilentlyContinue; if (\$app) { "\$(\$app.DisplayName)|\$(\$app.DisplayIcon)" }'
      ]);

      if (process.exitCode == 0) {
        final out = process.stdout.toString().trim();
        if (out.isNotEmpty && out.contains('|')) {
          final parts = out.split('|');
          if (mounted) {
            setState(() {
              _appName = parts[0];
              if (parts.length > 1) {
                _displayIcon = parts[1].replaceAll('"', '').trim();
              }
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Failed to fetch app info: $e");
    }

    if (_appName.isEmpty) {
      if (mounted) {
        setState(() {
          _appName = package;
        });
      }
    }
  }

  Future<void> _uninstallApp(AppLocalizations lang) async {
    setState(() {
      _isProcessing = true;
      _statusMessage = lang.uninstaller_status_uninstalling(_appName);
    });

    final package = Constants.uninstallPackage;
    try {
      // 0. registry backup
      String savedDir = GState.backupDirectory.$;
      if (!Directory(savedDir).existsSync()) {
        savedDir = '${Platform.environment['USERPROFILE'] ?? 'C:'}\\Desktop';
      }
      final now = DateTime.now();
      final ts =
          "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
      final backupPath = '$savedDir\\wsa_pacman_${package}_backup_$ts.reg';
      await Process.run(
          'reg',
          [
            'export',
            'HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\$package',
            backupPath,
            '/y'
          ],
          runInShell: true);

      // 1. WSA起動 + 接続待機（apk_installer.dartと完全に同一のロジック）
      setState(() {
        _statusMessage = lang.uninstaller_status_starting_wsa;
      });

      // WSAを起動する（すでに起動中でも問題ない）
      WSAUtils.launch();

      // 設定ファイルのロードを待機してIPとポートを取得
      final ip = await GState.ipAddress.whenReady();
      final port = await GState.androidPort.whenReady();
      final adbPath = ADBUtils.adbPath;

      // ★修正：WSAのパッケージマネージャー（pm）が応答するまで待機する
      bool isBootCompleted = false;
      String lastError = "";
      for (int i = 0; i < 60; i++) {
        // 最大120秒間（2秒 × 60回）待機
        try {
          // Androidシステムに「androidパッケージはどこにある？」と聞いて生存確認をする
          var pmResult =
              await ADBUtils.shellToAddress(ip, port, "pm path android")
                  .processTimeout(const Duration(seconds: 5)) // 毎回最大5秒でタイムアウト
                  .defaultError(); // 例外が起きても -1 を返すようにする

          // エラーなく応答が返ってきて、中に「package:」という文字が含まれていれば完全に起動済み！
          if (!pmResult.isTimeout &&
              pmResult.exitCode == 0 &&
              pmResult.stdout.toString().contains('package:')) {
            isBootCompleted = true;
            break;
          }
        } catch (e) {
          lastError = e.toString();
        }
        // まだ起動中の場合は2秒待ってから再チェック
        await Future.delayed(const Duration(seconds: 2));
      }

      // 120秒待機しても応答がなかった場合のタイムアウト処理
      if (!isBootCompleted) {
        throw Exception(
            "WSAの起動完了を待機しましたが、タイムアウトしました。\n内部エラー: $lastError\nWSAが正常に動作していないか、ADBが見つかりません。");
      }

      setState(() {
        _statusMessage = lang.uninstaller_status_uninstalling(_appName);
      });

      // 2. adb uninstall
      final adbProc = await Process.run(
              adbPath, ['-s', '$ip:$port', 'uninstall', package],
              runInShell: false)
          .timeout(const Duration(seconds: 30),
              onTimeout: () => ProcessResult(-1, -1, '', 'TIMEOUT'));

      // 3. registry delete
      await Process.run(
          'reg',
          [
            'delete',
            'HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\$package',
            '/f'
          ],
          runInShell: true);

      // 4. remove shortcuts
      await Process.run(
          'powershell',
          [
            '-NoProfile',
            '-Command',
            '\$StartMenuPath = [Environment]::GetFolderPath("Programs"); Get-ChildItem -Path \$StartMenuPath -Recurse -Filter "*$_appName*.lnk" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue'
          ],
          runInShell: true);

      if (mounted) {
        setState(() {
          _statusMessage = adbProc.exitCode == 0
              ? lang.uninstaller_status_success
              : lang.uninstaller_status_errors;
          _success = true;
        });
      }

      await Future.delayed(const Duration(seconds: 2));
      windowManager.close();
    } catch (e) {
      if (mounted) {
        setState(() {
          _statusMessage = lang.uninstaller_status_error_msg(e.toString());
          _isProcessing = false;
        });
      }
    }
  }

  Widget _buildAppIcon() {
    if (_displayIcon.isNotEmpty) {
      final file = File(_displayIcon.split(',').first.trim());
      if (file.existsSync()) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            file,
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.medium,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(FluentIcons.app_icon_default, size: 48),
          ),
        );
      }
    }
    return const Icon(FluentIcons.app_icon_default, size: 48);
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    final theme = FluentTheme.of(context);
    final package = Constants.uninstallPackage;

    return Mica(
      child: moveWindow(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                      child: SizedBox(
                          width: 30.00,
                          height: 30.00,
                          child: FittedBox(child: _buildAppIcon()))),
                  const SizedBox(width: 20),
                  Expanded(
                      child: Text(lang.screen_uninstall,
                          style: theme.typography.bodyLarge)),
                ],
              ),
              const SizedBox(height: 20),
              if (_isProcessing) ...[
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!_success) const ProgressRing(),
                        if (_success)
                          Icon(FluentIcons.check_mark,
                              color: Colors.green, size: 48),
                        const SizedBox(height: 24),
                        Text(_statusMessage, textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lang.uninstaller_confirm(_appName),
                          style: theme.typography.bodyLarge),
                      const SizedBox(height: 8),
                      Text("Package: $package",
                          style: theme.typography.caption),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    noMoveWindow(
                      Button(
                        onPressed: () => windowManager.close(),
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 80),
                          alignment: Alignment.center,
                          child: Text(lang.installer_btn_cancel),
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    noMoveWindow(
                      FilledButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.resolveWith((states) {
                            if (states.contains(WidgetState.hovered)) {
                              return Colors.red.light;
                            }
                            if (states.contains(WidgetState.pressed)) {
                              return Colors.red.dark;
                            }
                            return Colors.red;
                          }),
                        ),
                        onPressed: () => _uninstallApp(lang),
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 80),
                          alignment: Alignment.center,
                          child: Text(lang.uninstaller_btn_yes),
                        ),
                      ),
                    ),
                  ],
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
