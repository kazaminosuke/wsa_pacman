// ignore_for_file: curly_braces_in_flow_control_structures, avoid_print, non_constant_identifier_names, library_private_types_in_public_api, unused_local_variable, unused_field, deprecated_member_use

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
  void performRebuild() {
    super.performRebuild();
  }

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
                content: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(connectionStatus.desc(lang)),

                      // 1. WSAが見つからない時 (MISSING) のボタン
                      if (connectionStatus.type ==
                          ConnectionStatus.MISSING) ...[
                        const SizedBox(width: 15.0),
                        FilledButton(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 2.0),
                              child: Text(lang.btn_wsabuilds,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                            onPressed: () => Process.run('explorer',
                                ['https://github.com/MustardChef/WSABuilds']))
                      ]
                      // 2. WSA停止中の時 (ARRESTED) の「オンにする」ボタン
                      else if (connectionStatus.type ==
                          ConnectionStatus.ARRESTED) ...[
                        const SizedBox(width: 15.0),
                        Button(
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.hovered))
                                return Colors.white.withOpacity(0.9);
                              if (states.contains(WidgetState.pressed))
                                return Colors.grey[10];
                              return Colors.white;
                            }),
                            foregroundColor:
                                WidgetStateProperty.all(Colors.black),
                            shape: WidgetStateProperty.resolveWith((states) {
                              final borderColor =
                                  states.contains(WidgetState.hovered)
                                      ? Colors.grey[120]
                                      : Colors.grey[80];
                              return RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                                side:
                                    BorderSide(color: borderColor, width: 1.0),
                              );
                            }),
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0)),
                            elevation: WidgetStateProperty.resolveWith(
                                (states) => states.contains(WidgetState.hovered)
                                    ? 1.0
                                    : 0.0),
                          ),
                          onPressed: () => WSAUtils.launch(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(FluentIcons.power_button, size: 14),
                              const SizedBox(width: 6),
                              Text(lang.btn_boot,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          ),
                        )
                      ]
                      // ★ 復活: 開発者モードオフ (DISCONNECTED) または 不明なエラー (UNKNOWN) 時のボタン
                      else if (connectionStatus.type ==
                              ConnectionStatus.DISCONNECTED ||
                          connectionStatus.type ==
                              ConnectionStatus.UNKNOWN) ...[
                        // DISCONNECTED の時だけ「設定を開く」ボタンを出す
                        if (connectionStatus.type ==
                            ConnectionStatus.DISCONNECTED) ...[
                          const SizedBox(width: 15.0),
                          Button(
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 6.0)),
                              shape: WidgetStateProperty.resolveWith((states) =>
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                    side: BorderSide(
                                        color: FluentTheme.of(context)
                                            .inactiveColor
                                            .withOpacity(states.contains(
                                                    WidgetState.hovered)
                                                ? 0.4
                                                : 0.2),
                                        width: 1.0),
                                  )),
                            ),
                            onPressed: () => WSAUtils.launchDeveloperSettings(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(FluentIcons.settings, size: 14),
                                const SizedBox(width: 6),
                                Text(lang.btn_dev_settings,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13)),
                              ],
                            ),
                          ),
                        ],

                        const SizedBox(width: 15.0),

                        // 再起動ボタン（両方で表示）
                        Button(
                          style: ButtonStyle(
                            padding: WidgetStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0)),
                            shape: WidgetStateProperty.resolveWith(
                                (states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0),
                                      side: BorderSide(
                                          color: FluentTheme.of(context)
                                              .inactiveColor
                                              .withOpacity(states.contains(
                                                      WidgetState.hovered)
                                                  ? 0.4
                                                  : 0.2),
                                          width: 1.0),
                                    )),
                          ),
                          onPressed: () async {
                            WSAPeriodicConnector.lastStart =
                                DateTime.now().millisecondsSinceEpoch;
                            WSAPeriodicConnector.status =
                                ConnectionStatus.STARTING;
                            GState.connectionStatus.$ =
                                ConnectionStatus.STARTING.statusAlert;
                            await Process.run(
                                'taskkill', ['/F', '/IM', 'WsaClient.exe'],
                                runInShell: true);
                            await Process.run('adb', ['kill-server'],
                                runInShell: true);
                            await Future.delayed(const Duration(seconds: 1));
                            WSAUtils.launch();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(FluentIcons.refresh, size: 14),
                              const SizedBox(width: 6),
                              Text(lang.btn_restart_wsa,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          ),
                        )
                      ]

                      // 4. 認証エラー (UNAUTHORIZED) などのボタン
                      else if (connectionStatus.type ==
                          ConnectionStatus.UNAUTHORIZED) ...[
                        const SizedBox(width: 15.0),
                        Button(
                            child: Text(lang.btn_auth),
                            onPressed: () => WSAPeriodicConnector.reconnect()),
                        const SizedBox(width: 15.0),
                        Button(
                            child: Text(lang.btn_dev_settings),
                            onPressed: () => WSAUtils.launchDeveloperSettings())
                      ],
                    ]),
                isLong: true,
                severity: connectionStatus.severity,
                action: () {
                  // Do nothing for now
                }(),
              )),
          const SizedBox(height: 20),
          Text(lang.wsa_manage,
              style: FluentTheme.of(context).typography.bodyLarge),
          const SizedBox(height: 20),
          FluentCard(
            leading: const Icon(Mdi.android, size: 23),
            content: Text(lang.wsa_manage_app),
            isButton: true,
            onPressed: connectionStatus.isDisconnected
                ? null
                : () async {
                    final address =
                        '${GState.ipAddress.of(context)}:${GState.androidPort.of(context)}';
                    await Process.run(
                        'adb',
                        [
                          '-s',
                          address,
                          'shell',
                          'am',
                          'start',
                          '-n',
                          "'com.android.settings/.Settings\$ManageApplicationsActivity'"
                        ],
                        runInShell: true);
                  },
          ),
          smallSpacer,
          FluentCard(
            leading: const Icon(Mdi.cogs, size: 23),
            content: Text(lang.wsa_manage_settings),
            isButton: true,
            // こちらは「$」が無いのでそのままでOKです
            onPressed: connectionStatus.isDisconnected
                ? null
                : () async {
                    final address =
                        '${GState.ipAddress.of(context)}:${GState.androidPort.of(context)}';
                    await Process.run(
                        'adb',
                        [
                          '-s',
                          address,
                          'shell',
                          'am',
                          'start',
                          '-n',
                          'com.android.settings/.Settings'
                        ],
                        runInShell: true);
                  },
          )
        ],
      ),
    );
  }
}
