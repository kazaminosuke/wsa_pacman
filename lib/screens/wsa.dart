// ignore_for_file: avoid_print

import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:mdi/mdi.dart';
import 'package:wsa_pacman/utils/wsa_utils.dart';
import 'package:wsa_pacman/widget/fluent_card.dart';
import 'package:wsa_pacman/widget/fluent_info_bar.dart';
import 'package:wsa_pacman/widget/smooth_list_view.dart';
import '../main.dart';
import '../global_state.dart';

class ScreenWSA extends StatefulWidget {
  const ScreenWSA({super.key});

  @override
  _ScreenWSAState createState() => _ScreenWSAState();
}

class EmptyElement extends Element {
  EmptyElement(Empty super.widget);
  @override
  void performRebuild() {}
  @override
  bool get debugDoingBuild => false;
  @override
  Empty get widget => super.widget as Empty;
}
class Empty extends Widget {
  const Empty({super.key});

  @override
  Element createElement() => EmptyElement(this);
}
Expanded EMPTY = const Expanded(child: Column());

class _ScreenWSAState extends State<ScreenWSA> {
  //_FormsState(this.gsmap);

  //final GSMap<Object, dynamic> gsmap;
  final autoSuggestBox = TextEditingController();

  final _clearController = TextEditingController();
  final bool _showPassword = false;
  final values = ['Blue', 'Green', 'Yellow', 'Red'];
  String? comboBoxValue;

  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var connectionStatus = GState.connectionStatus.of(context);
    final lang = AppLocalizations.of(context)!;

    const smallSpacer = SizedBox(height: 5.0);

    return ScaffoldPage(
      header: PageHeader(title: Text(lang.screen_wsa)),
      content: SmoothListView(
        padding: EdgeInsets.only(
          bottom: kPageDefaultVerticalPadding,
          left: PageHeader.horizontalPadding(context),
          right: PageHeader.horizontalPadding(context),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: FluentInfoBar(
              title: Text(connectionStatus.title(lang)),
              content: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
                // ★ 1. 直接 lang から説明文を呼び出す（main.dartの処理で勝手に紐づきます）
                Text(connectionStatus.desc(lang)),
                
                // ★ 2. WSABuildsボタンも、l10nからテキストを取得！
                if (connectionStatus.type == ConnectionStatus.MISSING) ...[
                  const SizedBox(width: 15.0),
                  FilledButton(
                    child: Text(lang.btn_wsabuilds, style: const TextStyle(fontWeight: FontWeight.bold)),
                    onPressed: () => Process.run('explorer', ['https://github.com/MustardChef/WSABuilds'])
                  )
                ]
                // 3. WSA停止中の時の「オンにする」ボタン（白くてシンプルなモダンボタン）
                else if (connectionStatus.type == ConnectionStatus.ARRESTED) ...[
                  const SizedBox(width: 15.0),
                  Button(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith((states) {
                        if (states.contains(WidgetState.hovered)) return Colors.white.withOpacity(0.9);
                        if (states.contains(WidgetState.pressed)) return Colors.grey[10];
                        return Colors.white;
                      }),
                      foregroundColor: WidgetStateProperty.all(Colors.black),
                      shape: WidgetStateProperty.resolveWith((states) {
                        final borderColor = states.contains(WidgetState.hovered) ? Colors.grey[120] : Colors.grey[80];
                        return RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                          side: BorderSide(color: borderColor ?? const Color(0xFFCCCCCC), width: 0.5),
                        );
                      }),
                      padding: WidgetStateProperty.all(const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0)),
                      elevation: WidgetStateProperty.resolveWith((states) => states.contains(WidgetState.hovered) ? 1.0 : 0.0),
                    ),
                    onPressed: () => WSAUtils.launch(),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(FluentIcons.power_button, size: 16),
                        const SizedBox(width: 8),
                        Text(lang.btn_boot, style: const TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  )
                ]
                // 4. 認証エラーなどのボタン
                else if (connectionStatus.type == ConnectionStatus.UNAUTHORIZED) ...[
                  Button(child: Text(lang.btn_auth), onPressed: () => WSAPeriodicConnector.reconnect()),
                  const SizedBox(width: 15.0),
                  Button(child: Text(lang.btn_dev_settings), onPressed: () => WSAUtils.launchDeveloperSettings())
                ],
              ]),
              isLong: true,
              severity: connectionStatus.severity,
              action: () {
                // Do nothing for now
              }(),
            )
          ),
          const SizedBox(height: 20),
          Text(lang.wsa_manage, style: FluentTheme.of(context).typography.bodyLarge),
          const SizedBox(height: 20),
FluentCard(
            leading: const Icon(Mdi.android , size: 23),
            content: Text(lang.wsa_manage_app),
            isButton: true,
            // アプリ管理画面を開く（シングルクォートで確実に渡す）
            onPressed: connectionStatus.isDisconnected ? null : () {
              ADBUtils.shellToAddress(GState.ipAddress.of(context), GState.androidPort.of(context), 
                r"am start -n 'com.android.settings/.Settings$ManageApplicationsActivity'");
            },
          ),
          smallSpacer,
          FluentCard(
            leading: const Icon(Mdi.cogs, size: 23),
            content: Text(lang.wsa_manage_settings),
            isButton: true,
            // 全体設定を開く
            onPressed: connectionStatus.isDisconnected ? null : () {
              ADBUtils.shellToAddress(GState.ipAddress.of(context), GState.androidPort.of(context), 
                'am start -n com.android.settings/.Settings');
            },
          )
        ],
      ),
    );
  }
}
