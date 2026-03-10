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
import 'package:wsa_pacman/windows/wsa_status.dart';

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

  String? _loadingAction;
  bool _isRefreshing = false;

  /// Forces WSAStatus to re-detect and triggers a periodic connector cycle.
  Future<void> _refreshStatus() async {
    if (_isRefreshing) return;
    setState(() => _isRefreshing = true);
    try {
      // Invalidate the cache, then await a fresh detection run.
      WSAStatus.invalidateCache();
      await WSAStatus.waitForStatus();
      // Drive a full connector cycle so GState.connectionStatus is updated.
      await WSAPeriodicConnector.checkNow();
    } finally {
      if (mounted) setState(() => _isRefreshing = false);
    }
  }

  Future<void> _executeWsaAction(
      String actionName, Future<void> Function(String address) action) async {
    if (_loadingAction != null) return;

    setState(() {
      _loadingAction = actionName;
    });

    try {
      final connectionStatus = GState.connectionStatus.of(context);
      if (connectionStatus.isDisconnected ||
          connectionStatus.type == ConnectionStatus.ARRESTED) {
        WSAUtils.launch();
      }

      final ip = GState.ipAddress.of(context);
      final port = GState.androidPort.of(context);
      final address = '$ip:$port';

      bool isReady = false;
      const int timeoutSeconds = 15;

      for (int i = 0; i < timeoutSeconds; i++) {
        try {
          final res = await ADBUtils.shellToAddress(ip, port, 'echo 1');
          if (res.exitCode == 0) {
            isReady = true;
            break;
          }
        } catch (e) {
          // ignore
        }
        await Future.delayed(const Duration(seconds: 1));
      }

      if (isReady) {
        await action(address);
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingAction = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = GState.connectionStatus.of(context);
    final lang = AppLocalizations.of(context)!;

    const smallSpacer = SizedBox(height: 5.0);

    // ── Shared button style for InfoBar action buttons ───────────────────────
    // Provides uniform padding, uniform rounded corners (r=8), and the Fluent
    // default shape. Colors are intentionally NOT set here so each button's
    // semantic color (white bg, accent, etc.) is preserved.
    ButtonStyle infoBarButtonStyle(
        {Color? foreground, Color? Function(Set<WidgetState>)? background}) {
      return ButtonStyle(
        padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0)),
        shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
        foregroundColor:
            foreground != null ? WidgetStateProperty.all(foreground) : null,
        backgroundColor: background != null
            ? WidgetStateProperty.resolveWith(background)
            : null,
      );
    }

    // ── Helper: icon + text row used by all InfoBar buttons ─────────────────
    Widget btnContent(IconData icon, String label) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14),
            const SizedBox(width: 6),
            Text(label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          ],
        );

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
                    spacing: 8.0,
                    runSpacing: 6.0,
                    children: [
                      Text(connectionStatus.desc(lang)),

                      // ── MISSING: nothing we can launch, point to WSABuilds ─
                      if (connectionStatus.type ==
                          ConnectionStatus.MISSING) ...[
                        FilledButton(
                            style: infoBarButtonStyle(),
                            child: btnContent(FluentIcons.open_in_new_window,
                                lang.btn_wsabuilds),
                            onPressed: () => Process.run('explorer',
                                ['https://github.com/MustardChef/WSABuilds'])),
                      ]

                      // ── ARRESTED: WSA installed but no process running ──────
                      else if (connectionStatus.type ==
                          ConnectionStatus.ARRESTED) ...[
                        // White "Turn on" — keeps semantic color (white bg, black fg)
                        Button(
                          style: infoBarButtonStyle(
                            foreground: Colors.black,
                            background: (states) {
                              if (states.contains(WidgetState.hovered))
                                return Colors.white.withOpacity(0.9);
                              if (states.contains(WidgetState.pressed))
                                return Colors.grey[10];
                              return Colors.white;
                            },
                          ),
                          onPressed: () async {
                            WSAUtils.launch();
                            await _refreshStatus();
                          },
                          child: btnContent(
                              FluentIcons.power_button, lang.btn_launch_wsa),
                        ),
                      ]

                      // ── OFFLINE: process running but ADB port closed ────────
                      else if (connectionStatus.type ==
                          ConnectionStatus.OFFLINE) ...[
                        // Launch WSA button (attempts re-launch / dev-mode prompt)
                        Button(
                          style: infoBarButtonStyle(),
                          onPressed: () async {
                            WSAUtils.launch();
                            await _refreshStatus();
                          },
                          child:
                              btnContent(FluentIcons.play, lang.btn_launch_wsa),
                        ),
                        // Developer settings shortcut
                        Button(
                          style: infoBarButtonStyle(),
                          onPressed: () => WSAUtils.launchDeveloperSettings(),
                          child: btnContent(
                              FluentIcons.settings, lang.btn_dev_settings),
                        ),
                      ]

                      // ── DISCONNECTED / UNKNOWN ─────────────────────────────
                      else if (connectionStatus.type ==
                              ConnectionStatus.DISCONNECTED ||
                          connectionStatus.type ==
                              ConnectionStatus.UNKNOWN) ...[
                        if (connectionStatus.type ==
                            ConnectionStatus.DISCONNECTED)
                          Button(
                            style: infoBarButtonStyle(),
                            onPressed: () => WSAUtils.launchDeveloperSettings(),
                            child: btnContent(
                                FluentIcons.settings, lang.btn_dev_settings),
                          ),
                        // Restart WSA button
                        Button(
                          style: infoBarButtonStyle(),
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
                          child: btnContent(
                              FluentIcons.refresh, lang.btn_restart_wsa),
                        ),
                      ]

                      // ── UNAUTHORIZED ───────────────────────────────────────
                      else if (connectionStatus.type ==
                          ConnectionStatus.UNAUTHORIZED) ...[
                        Button(
                          style: infoBarButtonStyle(),
                          onPressed: () => WSAPeriodicConnector.reconnect(),
                          child: Text(lang.btn_auth),
                        ),
                        Button(
                          style: infoBarButtonStyle(),
                          onPressed: () => WSAUtils.launchDeveloperSettings(),
                          child: Text(lang.btn_dev_settings),
                        ),
                      ],

                      // ── Refresh Status (always shown) ──────────────────────
                      Tooltip(
                        message: lang.tooltip_refresh_status,
                        child: Button(
                          style: infoBarButtonStyle(),
                          onPressed: _isRefreshing ? null : _refreshStatus,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (_isRefreshing)
                                const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: ProgressRing(strokeWidth: 2),
                                )
                              else
                                const Icon(FluentIcons.refresh, size: 14),
                              const SizedBox(width: 6),
                              Text(lang.btn_refresh_status,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
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
            content: Text(_loadingAction == 'app'
                ? lang.status_starting
                : lang.wsa_manage_app),
            isButton: true,
            onPressed: _loadingAction != null
                ? null
                : () => _executeWsaAction('app', (address) async {
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
                    }),
          ),
          smallSpacer,
          FluentCard(
            leading: const Icon(Mdi.cogs, size: 23),
            content: Text(_loadingAction == 'settings'
                ? lang.status_starting
                : lang.wsa_manage_settings),
            isButton: true,
            onPressed: _loadingAction != null
                ? null
                : () => _executeWsaAction('settings', (address) async {
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
                    }),
          )
        ],
      ),
    );
  }
}
