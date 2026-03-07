// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures, library_private_types_in_public_api

import 'dart:async';
import 'dart:io';

import 'package:wsa_pacman/android/android_utils.dart';
import 'package:wsa_pacman/android/permissions.dart';
import 'package:wsa_pacman/global_state.dart';
import 'package:wsa_pacman/main.dart';
import 'package:wsa_pacman/utils/wsa_utils.dart';
import 'package:wsa_pacman/widget/smooth_list_view.dart';
import 'package:wsa_pacman/windows/win_io.dart';
import 'package:wsa_pacman/widget/adaptive_icon.dart';
import 'package:wsa_pacman/widget/flexible_info_bar.dart';
import 'package:wsa_pacman/widget/move_window_nomax.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:wsa_pacman/windows/win_path.dart';

import 'dart:developer';

class ApkInstaller extends StatefulWidget {
  const ApkInstaller({super.key});

  static void createLaunchIcon(String package, String appName) {
    WinIO.createShortcut(
        "%LOCALAPPDATA%\\Microsoft\\WindowsApps\\${Env.WSA_INFO.familyName}\\WsaClient.exe",
        "${WinPath.desktop}\\$appName",
        args: "/launch wsa://$package",
        icon:
            '%LOCALAPPDATA%\\Packages\\${Env.WSA_INFO.familyName}\\LocalState\\$package.ico');
  }

  static void installApk(String apkFile, String ipAddress, int port,
      AppLocalizations lang, int timeout,
      [bool downgrade = false]) async {
    log("INSTALLING \"$apkFile\" on on $ipAddress:$port...");

    // UIを「インストール中（ぐるぐる）」に変えて操作をブロックする
    GState.apkInstallState.update((_) => InstallState.INSTALLING);

    // ★修正：WSAのパッケージマネージャー（pm）が応答するまで待機する
    bool isBootCompleted = false;
    for (int i = 0; i < 60; i++) {
      // 最大120秒間（2秒 × 60回）待機
      // Androidシステムに「androidパッケージはどこにある？」と聞いて生存確認をする
      var pmResult =
          await ADBUtils.shellToAddress(ipAddress, port, "pm path android");

      // エラーなく応答が返ってきて、中に「package:」という文字が含まれていれば完全に起動済み！
      if (pmResult.exitCode == 0 &&
          pmResult.stdout.toString().contains('package:')) {
        isBootCompleted = true;
        break;
      }
      // まだ起動中の場合は2秒待ってから再チェック
      await Future.delayed(const Duration(seconds: 2));
    }

    // 120秒待機しても応答がなかった場合のタイムアウト処理
    if (!isBootCompleted) {
      GState.apkInstallState.update((_) => InstallState.ERROR);
      GState.errorCode.update((_) => "WSA_BOOT_TIMEOUT");
      GState.errorDesc.update(
          (_) => "WSAの起動完了を2分間待ちましたが、タイムアウトしました。WSAが正常に動作していない可能性があります。");
      return;
    }

    // 完全に起動したのを確認してから、本来のインストールコマンドを発行
    var installation = ADBUtils.installToAddress(ipAddress, port, apkFile,
        downgrade: downgrade);

    // タイムアウトをたっぷり5分(300秒)に固定
    installation = installation.processTimeout(const Duration(seconds: 300));
    installation = installation.defaultError();

    var result = await installation;
    log("EXIT CODE: ${result.exitCode}");
    String error = result.stderr.toString();
    log("OUTPUT: ${result.stdout}");
    log("ERROR: $error");

    if (result.exitCode == 0) {
      GState.apkInstallState.update((_) => InstallState.SUCCESS);

      final package = GState.package.$;
      final appTitle = GState.apkTitle.$;
      final execDir = File(Platform.resolvedExecutable).parent.path;
      final execPath = '$execDir\\WSA-pacman.exe';

      if (package.isNotEmpty) {
        try {
          // Uninstall info registry registration
          Process.run(
            'reg',
            [
              'add',
              'HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\$package',
              '/v',
              'DisplayName',
              '/t',
              'REG_SZ',
              '/d',
              appTitle,
              '/f'
            ],
            runInShell: true,
          ).then((_) {
            Process.run(
              'reg',
              [
                'add',
                'HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\$package',
                '/v',
                'UninstallString',
                '/t',
                'REG_SZ',
                '/d',
                '"$execPath" --uninstall "$package"',
                '/f'
              ],
              runInShell: true,
            ).then((_) {
              Process.run(
                'reg',
                [
                  'add',
                  'HKCU\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\$package',
                  '/v',
                  'QuietUninstallString',
                  '/t',
                  'REG_SZ',
                  '/d',
                  '"$execPath" --uninstall "$package"',
                  '/f'
                ],
                runInShell: true,
              );
            });
          });
        } catch (e) {
          log("Failed to register uninstaller: $e");
        }
      }
    } else if (result.isTimeout) {
      GState.apkInstallState.update((_) => InstallState.TIMEOUT);
      GState.errorCode.update((_) => "TIMEOUT");
      GState.errorDesc.update((_) => lang.installer_error_timeout);
    } else {
      GState.apkInstallState.update((_) => InstallState.ERROR);
      RegExpMatch? errorMatch = RegExp(
              r'(^|\n)\s*adb:\s+failed\s+to\s+install\s+.*:\s+Failure\s+\[([^:]*):\s*([^\s].*[^\s])\s*\]')
          .firstMatch(error);

      if (errorMatch != null) {
        String errorCode = errorMatch.group(2) ?? "";
        GState.errorCode
            .update((_) => errorCode.isNotEmpty ? errorCode : "UNKNOWN_ERROR");
        String errorDesc = errorMatch.group(3) ?? "";
        GState.errorDesc.update((_) =>
            errorDesc.isNotEmpty ? errorDesc : lang.installer_error_nomsg);
      } else {
        GState.errorCode
            .update((_) => "INSTALL_ERROR (Exit: ${result.exitCode})");
        GState.errorDesc.update((_) =>
            error.trim().isNotEmpty ? error.trim() : "エラーの詳細が取得できませんでした。");
      }
    }
  }

  @override
  _ApkInstallerState createState() => _ApkInstallerState();
}

class _ApkInstallerState extends State<ApkInstaller> {
  int index = 0;
  ToggleButtonThemeData? warningButtonTheme;
  bool createShortcut = false;
  bool startingWSA = false;

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    Widget icon;
    String appTitle = GState.apkTitle.of(context);
    Widget? aForeground = GState.apkForegroundIcon.of(context);
    bool adaptiveNoScale = GState.apkAdaptiveNoScale.of(context);
    Widget? lIcon = GState.apkIcon.of(context);
    WSAStatusAlert connectionStatus = GState.connectionStatus.of(context);
    bool isConnected = connectionStatus.isConnected;
    InstallType? installType = GState.apkInstallType.of(context);
    bool canInstall = isConnected &&
        installType != null &&
        installType != InstallType.UNKNOWN;
    InstallState installState = GState.apkInstallState.of(context);
    final theme = FluentTheme.of(context);
    if (startingWSA && isConnected) startingWSA = false;
    final autostartWSA =
        !startingWSA && !isConnected && GState.autostartWSA.of(context);

    if (autostartWSA) {
      startingWSA = true;
      // 画面の描画が完了した「直後」に安全に起動処理を走らせる（ルール違反回避）
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!WSAUtils.launch()) {
          if (mounted)
            setState(() {
              startingWSA = false;
            });
        }
      });
    }

    if (installType == InstallType.DOWNGRADE && warningButtonTheme == null)
      warningButtonTheme = ToggleButtonThemeData.standard(
          theme.copyWith(accentColor: Colors.orange));

    String package = GState.package.of(context);
    String version = GState.version.of(context);
    int installTimeout = GState.installTimeout.of(context);

    String oldVersion = GState.oldVersion.of(context);

    String ipAddress = GState.ipAddress.of(context);
    int port = GState.androidPort.of(context);

    if (aForeground != null)
      icon = AdaptiveIcon(
          noScale: adaptiveNoScale,
          backColor: GState.apkBackgroundColor.of(context),
          background: GState.apkBackgroundIcon.of(context),
          foreground: aForeground,
          radius: GState.iconShape.of(context).radius);
    else if (lIcon != null)
      icon = FittedBox(child: lIcon);
    else
      icon = const ProgressRing();

    Widget titleWidget =
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Flexible(child: SizedBox(width: 30.00, height: 30.00, child: icon)),
      const Flexible(child: SizedBox(width: 20)),
      Text(appTitle, style: theme.typography.bodyLarge),
    ]);

    return Mica(
        child: moveWindow(Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: (() {
          switch (installState) {
            case InstallState.PROMPT:
              return [
                titleWidget,
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(height: 10),
                  Text(lang.installer_message),
                  const SizedBox(height: 10),
                  Text(
                      (oldVersion.isNotEmpty
                              ? lang.installer_info_version_change(
                                  oldVersion, version)
                              : lang.installer_info_version(version))
                          .replaceAll(' ', '\u00A0'),
                      style: TextStyle(
                          color: theme.resources.textFillColorDisabled),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                  Text(
                      lang
                          .installer_info_package(package)
                          .replaceAll(' ', '\u00A0'),
                      style: TextStyle(
                          color: theme.resources.textFillColorDisabled),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1),
                ]),
                const SizedBox(height: 10),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      color: theme.brightness == Brightness.dark
                          ? const Color(0x0CFFFFFF)
                          : const Color(0x08000000),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 14),
                      child: SmoothListView(
                        children: [
                          for (var permission in GState.permissions.of(context))
                            PermissionListItem(
                              permission: permission,
                              lang: lang,
                              theme: theme,
                            )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      noMoveWindow(Button(
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)))),
                        onPressed: () {
                          appWindow.close();
                        },
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 80),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          alignment: Alignment.center,
                          child: Text(lang.installer_btn_cancel,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      )),
                      const SizedBox(width: 15),
                      noMoveWindow(
                        FluentTheme(
                          data: installType == InstallType.DOWNGRADE
                              ? theme.copyWith(accentColor: Colors.orange)
                              : theme,
                          child: FilledButton(
                            style: ButtonStyle(
                                shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)))),
                            onPressed: !canInstall
                                ? null
                                : () {
                                    if (Constants.packageType.directInstall)
                                      ApkInstaller.installApk(
                                          Constants.packageFile,
                                          ipAddress,
                                          port,
                                          lang,
                                          installTimeout,
                                          installType == InstallType.DOWNGRADE);
                                    else
                                      GState.installCallback.$?.call(
                                          ipAddress,
                                          port,
                                          lang,
                                          installTimeout,
                                          installType == InstallType.DOWNGRADE);
                                  },
                            child: Container(
                              constraints: const BoxConstraints(minWidth: 80),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              alignment: Alignment.center,
                              child: Text(
                                  startingWSA
                                      ? lang.installer_btn_starting
                                      : installType?.buttonText(lang) ??
                                          lang.installer_btn_loading,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ),
                      ),
                    ])
              ];
            case InstallState.INSTALLING:
              return [
                titleWidget,
                const SizedBox(height: 10),
                Text(lang.installer_installing(appTitle)),

                // ★ 追加：中央の寂しい空間を埋める、リッチな巨大アイコンとくるくるアニメーション
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.dark
                                ? const Color(0x0CFFFFFF)
                                : const Color(0x08000000),
                            borderRadius: BorderRadius.circular(20), // 少し大きめの角丸
                          ),
                          padding: const EdgeInsets.all(16),
                          child: (aForeground != null)
                              ? AdaptiveIcon(
                                  noScale: adaptiveNoScale,
                                  backColor:
                                      GState.apkBackgroundColor.of(context),
                                  background:
                                      GState.apkBackgroundIcon.of(context),
                                  foreground: aForeground,
                                  radius: GState.iconShape.of(context).radius)
                              : (lIcon != null
                                  ? FittedBox(child: GState.apkIcon.of(context))
                                  : const ProgressRing()),
                        ),
                        const SizedBox(height: 24),
                        const ProgressRing(), // 「一生懸命インストールしてます感」を出す
                      ],
                    ),
                  ),
                ),

                const Row(
                    children: [Expanded(child: ProgressBar(strokeWidth: 6))]),
              ];
            case InstallState.SUCCESS:
              return [
                titleWidget,
                const SizedBox(height: 10),
                Text(lang.installer_installed(appTitle)),

                // ★ 追加：成功時のドヤ感あるアプリアイコン＋緑チェックバッジ
                Expanded(
                  child: Center(
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: theme.brightness == Brightness.dark
                                ? const Color(0x0CFFFFFF)
                                : const Color(0x08000000),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: (aForeground != null)
                              ? AdaptiveIcon(
                                  noScale: adaptiveNoScale,
                                  backColor:
                                      GState.apkBackgroundColor.of(context),
                                  background:
                                      GState.apkBackgroundIcon.of(context),
                                  foreground: aForeground,
                                  radius: GState.iconShape.of(context).radius)
                              : (lIcon != null
                                  ? FittedBox(child: GState.apkIcon.of(context))
                                  : const ProgressRing()),
                        ),
                        // 右下に飛び出す緑色のチェックマークバッジ
                        Transform.translate(
                          offset: const Offset(8, 8),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: theme.brightness == Brightness.dark
                                      ? const Color(0xFF202020)
                                      : const Color(0xFFF3F3F3),
                                  width: 4 // 背景に溶け込まないように太めのフチをつける
                                  ),
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(FluentIcons.check_mark,
                                color: Colors.white, size: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (installType == InstallType.INSTALL)
                  Checkbox(
                    checked: createShortcut,
                    content: Text(lang.installer_btn_checkbox_shortcut),
                    onChanged: (value) =>
                        setState(() => createShortcut = value!),
                  ),
                const SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      noMoveWindow(Button(
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)))),
                        onPressed: () {
                          if (createShortcut)
                            ApkInstaller.createLaunchIcon(package, appTitle);
                          appWindow.close();
                        },
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 80),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          alignment: Alignment.center,
                          child: Text(lang.installer_btn_dismiss,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      )),
                      if (package.isNotEmpty) const SizedBox(width: 15),
                      if (package.isNotEmpty)
                        noMoveWindow(FilledButton(
                          style: ButtonStyle(
                              shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(8.0)))),
                          onPressed: () {
                            if (createShortcut)
                              ApkInstaller.createLaunchIcon(package, appTitle);
                            WSAUtils.launchApp(package);
                            appWindow.close();
                          },
                          child: Container(
                            constraints: const BoxConstraints(minWidth: 80),
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 8.0),
                            alignment: Alignment.center,
                            child: Text(lang.installer_btn_open,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                          ),
                        ))
                    ])
              ];
            case InstallState.ERROR:
            case InstallState.TIMEOUT:
              return [
                titleWidget,
                const SizedBox(height: 10),
                Text(lang.installer_fail(appTitle)),
                const SizedBox(height: 10),
                FlexibleInfoBar(
                    title: noMoveWindow(
                        material.SelectableText(GState.errorCode.of(context))),
                    content: noMoveWindow(
                        material.SelectableText(GState.errorDesc.of(context))),
                    severity: installState == InstallState.ERROR
                        ? InfoBarSeverity.error
                        : InfoBarSeverity.warning),
                const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      noMoveWindow(Button(
                        style: ButtonStyle(
                            shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0)))),
                        onPressed: () {
                          appWindow.close();
                        },
                        child: Container(
                          constraints: const BoxConstraints(minWidth: 80),
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          alignment: Alignment.center,
                          child: Text(lang.installer_btn_dismiss,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ))
                    ])
              ];
          }
        })(),
      ),
    )));
  }
}

// =========================================================
// フワッとフェードインし、クリックエフェクトも備えたリストアイテム
// =========================================================
class PermissionListItem extends StatelessWidget {
  final AndroidPermission permission;
  final AppLocalizations lang;
  final FluentThemeData theme;

  const PermissionListItem({
    super.key,
    required this.permission,
    required this.lang,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return HoverButton(
      onPressed: () {},
      builder: (context, states) {
        // ★ 修正箇所：最新の Flutter (WidgetState) の仕様に合わせて contains で判定
        final isHovering = states.contains(WidgetState.hovered);
        final isPressing = states.contains(WidgetState.pressed);

        Color bgColor = const Color(0x00000000); // 普段は透明
        if (isPressing) {
          // クリックした瞬間は少し濃くなる
          bgColor = theme.brightness == Brightness.dark
              ? const Color(0x19FFFFFF)
              : const Color(0x0F000000);
        } else if (isHovering) {
          // ホバー時はほんのり明るく
          bgColor = theme.brightness == Brightness.dark
              ? const Color(0x0FFFFFFF)
              : const Color(0x0A000000);
        }

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          margin: const EdgeInsets.symmetric(vertical: 1.0),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconTheme.merge(
                data: IconThemeData(
                  color: theme.resources.textFillColorPrimary,
                  size: 15.0,
                ),
                child: permission.icon,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  permission.description(lang),
                  style: TextStyle(
                    color: theme.resources.textFillColorPrimary,
                    fontSize: 14.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
