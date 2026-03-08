// lib/screens/app_manager.dart
import 'dart:convert';
import 'dart:io';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:mdi/mdi.dart';
// lib/screens/app_manager.dart の一番上付近
import '../global_state.dart'; // ★これを追加
import 'dart:async'; // ★ これを追加
import '../widget/fluent_card.dart';

class ScreenAppManager extends StatefulWidget {
  const ScreenAppManager({super.key});

  @override
  State<ScreenAppManager> createState() => _ScreenAppManagerState();
}

class _ScreenAppManagerState extends State<ScreenAppManager> {
  bool _isScanning = false;
  List<Map<String, dynamic>> _detectedApps = [];
  final Set<String> _selectedPackages = {};

  // ★ 追加: 通知が重ならないようにするための「順番待ち」フラグ
  bool _isInfoBarShowing = false;

  // ★ 修正: ×ボタンを待つのではなく、自動フェードアウトし切るまで待機する
  void _queueInfoBar(
      InfoBar Function(BuildContext context, void Function() close)
          builder) async {
    // 前の通知が出ている間は待機
    while (_isInfoBarShowing) {
      await Future.delayed(const Duration(milliseconds: 300));
    }
    if (!mounted) return;

    _isInfoBarShowing = true;

    // 通知を表示する時間（3秒）
    const showDuration = Duration(seconds: 1);

    // ★ durationを指定することで、×を押さなくても自動で消えるようにする
    displayInfoBar(
      context,
      duration: showDuration,
      builder: builder,
    );

    // ★ 表示時間 ＋ フェードアウトのアニメーション時間（0.5秒）を確実に待ってから次へ進む
    await Future.delayed(showDuration + const Duration(milliseconds: 500));

    _isInfoBarShowing = false;
  }

  Future<void> _startScan(AppLocalizations lang) async {
    setState(() {
      _isScanning = true;
      _detectedApps.clear();
      _selectedPackages.clear();
    });

    List<Map<String, dynamic>> results = [];
    Set<String> knownPackages = {};

    try {
      final process = await Process.run(
          'powershell',
          [
            '-NoProfile',
            '-Command',
            '''
        [Console]::OutputEncoding = [System.Text.Encoding]::UTF8;
        \$apps = Get-ItemProperty "HKCU:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\*" -ErrorAction SilentlyContinue |
                Where-Object { \$_.UninstallString -match "WsaClient\\.exe" -or \$_.Publisher -match "Windows Subsystem for Android" -or \$_.DisplayIcon -match "MicrosoftCorporationII\\.WindowsSubsystemForAndroid" } |
                Select-Object DisplayName, PSChildName, UninstallString, DisplayIcon
        if (\$apps) { \$apps | ConvertTo-Json -Compress } else { "[]" }
        '''
          ],
          stdoutEncoding: utf8);

      if (process.exitCode == 0 &&
          process.stdout.toString().trim().isNotEmpty) {
        final String output = process.stdout.toString().trim();
        final decoded = jsonDecode(output);

        final List<dynamic> jsonList = decoded is List ? decoded : [decoded];

        for (var item in jsonList) {
          if (item['DisplayName'] != null && item['PSChildName'] != null) {
            final pkg = item['PSChildName'].toString();
            knownPackages.add(pkg);
            results.add({
              "name": item['DisplayName'],
              "type": "registry",
              "package": pkg,
              "uninstallString": item['UninstallString'],
              "displayIcon": item['DisplayIcon'],
            });
          }
        }
      }
    } catch (e) {
      debugPrint("Registry Scan error: $e");
    }

    try {
      final adbProcess =
          await Process.run('adb', ['shell', 'pm', 'list', 'packages', '-3']);
      if (adbProcess.exitCode == 0) {
        final lines = adbProcess.stdout.toString().split('\n');
        for (String line in lines) {
          line = line.trim();
          if (line.startsWith('package:')) {
            final pkg = line.replaceFirst('package:', '');
            if (pkg.isNotEmpty && !knownPackages.contains(pkg)) {
              results.add({
                "name": pkg,
                "type": "adb",
                "package": pkg,
                "uninstallString": null,
                "displayIcon": null,
              });
            }
          }
        }
      }
    } catch (e) {
      debugPrint("ADB Scan error: $e");
    }

    setState(() {
      _isScanning = false;
      _detectedApps = results;
    });
  }

  // ★ PowerShellを使ってWindowsネイティブの「名前を付けて保存」ダイアログを呼び出す
  Future<String?> _pickSaveLocation() async {
    const script = '''
      Add-Type -AssemblyName System.Windows.Forms
      \$dlg = New-Object System.Windows.Forms.SaveFileDialog
      \$dlg.Filter = "Registry Files (*.reg)|*.reg"
      \$dlg.FileName = "wsa_registry_backup_\$((Get-Date).ToString('yyyyMMdd_HHmmss')).reg"
      \$dlg.Title = "Save Registry Backup"
      if (\$dlg.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        Write-Output \$dlg.FileName
      }
    ''';
    final process =
        await Process.run('powershell', ['-NoProfile', '-Command', script]);
    final path = process.stdout.toString().trim();
    return path.isNotEmpty ? path : null;
  }

  Future<bool> _backupRegistry(AppLocalizations lang,
      {bool isAuto = false}) async {
    String backupPath = '';

    if (isAuto) {
      String savedDir = GState.backupDirectory.$;
      if (!Directory(savedDir).existsSync()) {
        savedDir = '${Platform.environment['USERPROFILE'] ?? 'C:'}\\Desktop';
      }
      final now = DateTime.now();
      final ts =
          "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}";
      backupPath = '$savedDir\\wsa_registry_backup_$ts.reg';
    } else {
      final selectedPath = await _pickSaveLocation();
      if (selectedPath == null) {
        if (mounted) {
          _queueInfoBar((context, close) => InfoBar(
                title: Text(lang.backup_cancelled),
                severity: InfoBarSeverity.warning,
                onClose: close,
              ));
        }
        return false;
      }
      backupPath = selectedPath;
    }

    // ★ 修正: runInShell: true を追加して確実に実行
    await Process.run(
        'reg',
        [
          'export',
          'HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall',
          backupPath,
          '/y'
        ],
        runInShell: true);

    if (mounted) {
      _queueInfoBar((context, close) => InfoBar(
            title: Text(lang.backup_success),
            content: Text(backupPath),
            severity: InfoBarSeverity.success,
            onClose: close,
          ));
    }
    return true;
  }

  Future<void> _executeCleanup(AppLocalizations lang) async {
    if (_selectedPackages.isEmpty) return;

    if (GState.autoBackupRegistry.$) {
      final success = await _backupRegistry(lang, isAuto: true);
      if (!success) return;
    }

    final int deletedCount = _selectedPackages.length;

    for (String package in _selectedPackages) {
      final appData = _detectedApps
          .firstWhere((app) => app['package'] == package, orElse: () => {});
      final appName = appData['name'];

      if (appData['type'] == 'registry' || appData['type'] == 'shortcut') {
        // ★ 修正: runInShell: true を追加
        await Process.run(
            'reg',
            [
              'delete',
              'HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\$package',
              '/f'
            ],
            runInShell: true);
      }

      if (appName != null) {
        // ★ 修正: runInShell: true を追加し、名前のブレに対応するため *$appName*.lnk に変更
        await Process.run(
            'powershell',
            [
              '-NoProfile',
              '-Command',
              '\$StartMenuPath = [Environment]::GetFolderPath("Programs"); Get-ChildItem -Path \$StartMenuPath -Recurse -Filter "*$appName*.lnk" -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue'
            ],
            runInShell: true);
      }

      // ★ 修正: runInShell: true を追加して確実にAndroid側から削除
      await Process.run('adb', ['uninstall', package], runInShell: true);
    }

    if (mounted) {
      _queueInfoBar((context, close) => InfoBar(
            title: Text(lang.cleanup_complete),
            content: Text(lang.cleanup_success_desc(deletedCount)),
            severity: InfoBarSeverity.success,
            onClose: close,
          ));
    }

    _startScan(lang);
  }

  Widget _buildAppIcon(String? iconPath, String type) {
    Widget defaultIcon = type == 'adb'
        ? Icon(Mdi.android, color: Colors.green, size: 28)
        : Icon(FluentIcons.registry_editor, color: Colors.orange, size: 28);

    if (iconPath != null && iconPath.isNotEmpty) {
      String cleanPath = iconPath.split(',').first.replaceAll('"', '').trim();

      File iconFile = File(cleanPath);
      if (iconFile.existsSync()) {
        String lowerPath = cleanPath.toLowerCase();
        if (lowerPath.endsWith('.png') ||
            lowerPath.endsWith('.jpg') ||
            lowerPath.endsWith('.bmp') ||
            lowerPath.endsWith('.webp') ||
            lowerPath.endsWith('.ico')) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.file(
              iconFile,
              width: 32,
              height: 32,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              errorBuilder: (context, error, stackTrace) => defaultIcon,
            ),
          );
        }
      }
    }
    return defaultIcon;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FluentTheme.of(context);
    final lang = AppLocalizations.of(context)!;

    return ScaffoldPage.withPadding(
      header: PageHeader(
        title: Text(lang.screen_uninstall),
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FluentCard(
            content: Row(
              children: [
                FilledButton(
                  onPressed: _isScanning ? null : () => _startScan(lang),
                  child: Row(
                    children: [
                      const Icon(FluentIcons.search, size: 16),
                      const SizedBox(width: 8),
                      Text(_isScanning ? lang.scanning : lang.scan_system),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Button(
                  onPressed: () => _backupRegistry(lang),
                  child: Row(
                    children: [
                      const Icon(FluentIcons.save),
                      const SizedBox(width: 8),
                      Text(lang.backup_registry),
                    ],
                  ),
                ),
                const Spacer(),
                Button(
                  onPressed: _selectedPackages.isEmpty
                      ? null
                      : () => _executeCleanup(lang),
                  style: const ButtonStyle().copyWith(
                    foregroundColor: WidgetStatePropertyAll(Colors.red),
                  ),
                  child: Row(
                    children: [
                      const Icon(FluentIcons.delete),
                      const SizedBox(width: 8),
                      Text(lang.execute_cleanup),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _detectedApps.isEmpty
                ? Center(
                    child: _isScanning
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(
                                width: 44,
                                height: 44,
                                child: ProgressRing(strokeWidth: 4.5),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                lang.scanning,
                                style: theme.typography.bodyLarge,
                              ),
                            ],
                          )
                        : Text(lang.click_scan_to_find_ghost_apps),
                  )
                : ListView.builder(
                    itemCount: _detectedApps.length,
                    itemBuilder: (context, index) {
                      final app = _detectedApps[index];
                      final packageId = app['package'] as String;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: FluentCard(
                          onPressed: () {
                            setState(() {
                              if (_selectedPackages.contains(packageId)) {
                                _selectedPackages.remove(packageId);
                              } else {
                                _selectedPackages.add(packageId);
                              }
                            });
                          },
                          leading: SizedBox(
                            width: 38,
                            height: 38,
                            child: Center(
                              child: _buildAppIcon(
                                  app['displayIcon']?.toString(), app['type']),
                            ),
                          ),
                          content: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(app['name'],
                                    style: theme.typography.bodyLarge),
                                const SizedBox(height: 2),
                                Text(packageId,
                                    style: theme.typography.caption),
                              ],
                            ),
                          ),
                          trailing: Checkbox(
                            checked: _selectedPackages.contains(packageId),
                            onChanged: (v) {
                              setState(() {
                                if (v == true) {
                                  _selectedPackages.add(packageId);
                                } else {
                                  _selectedPackages.remove(packageId);
                                }
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
