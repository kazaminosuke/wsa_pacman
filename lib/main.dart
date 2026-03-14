// ignore_for_file: constant_identifier_names, curly_braces_in_flow_control_structures, non_constant_identifier_names, deprecated_member_use, library_private_types_in_public_api

import 'dart:io';
import 'dart:developer';
import 'dart:async';

import 'package:flutter_localizations/flutter_localizations.dart' as locale;
import 'package:wsa_pacman/android/android_utils.dart';
import 'package:wsa_pacman/apk_installer.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_value/shared_value.dart';
import 'package:wsa_pacman/io/isolate_runner.dart';
import 'package:wsa_pacman/utils/misc_utils.dart';
import 'package:wsa_pacman/utils/wsa_utils.dart';
import 'package:wsa_pacman/utils/locale_utils.dart';
import 'package:wsa_pacman/windows/win_info.dart';
import 'package:wsa_pacman/windows/win_reg.dart';
import 'package:wsa_pacman/windows/wsa_status.dart';
import 'package:wsa_pacman/utils/env.dart';
import 'global_state.dart';

import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';

import 'screens/wsa.dart';
import 'screens/settings.dart';
import 'screens/app_manager.dart';
import 'screens/apk_uninstaller.dart'; // Add the uninstaller screen
import 'utils/string_utils.dart';
import 'sync_apps.dart';

import 'theme.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart' as fsi;
import 'package:flutter/material.dart' show Icons;
// 衝突を避けるために hide を追加します
import 'dart:ffi' hide Size;
import 'package:ffi/ffi.dart';
import 'package:win32/win32.dart' hide MoveWindow;

const String appTitle = 'WSA Package Manager';
const String appVersion = '1.6.0';

late bool darkMode;

class WSAStatusAlert {
  WSAStatusAlert(this.type, this.severity, this.title, this.desc);

  final ConnectionStatus type;
  final InfoBarSeverity severity;
  final String Function(AppLocalizations lang) title;
  final String Function(AppLocalizations lang) desc;

  bool get isConnected => type == ConnectionStatus.CONNECTED;
  bool get isDisconnected => type != ConnectionStatus.CONNECTED;
  bool get isPoweredOn =>
      isConnected ||
      type == ConnectionStatus.DISCONNECTED ||
      type == ConnectionStatus.OFFLINE ||
      type == ConnectionStatus.UNAUTHORIZED;
}

enum ConnectionStatus {
  UNSUPPORTED,
  MISSING,
  UNKNOWN,
  ARRESTED,
  STARTING,
  OFFLINE,
  DISCONNECTED,
  CONNECTED,
  UNAUTHORIZED
}

extension ConnectionStatusExt on ConnectionStatus {
  // ⭕ 名前を付けてパブリックにする
  static final Map<ConnectionStatus, WSAStatusAlert> _statusAlers = {
    ConnectionStatus.UNSUPPORTED: WSAStatusAlert(
        ConnectionStatus.UNSUPPORTED,
        InfoBarSeverity.error,
        (l) => l.status_unsupported,
        (l) => l.status_unsupported_desc(WinVer.isWindows10OrGreater
            ? l.status_subtext_winver_10
            : l.status_subtext_winver_older)),
    ConnectionStatus.MISSING: WSAStatusAlert(
        ConnectionStatus.MISSING,
        InfoBarSeverity.error,
        (l) => l.status_missing,
        (l) => l.status_missing_desc),
    ConnectionStatus.UNKNOWN: WSAStatusAlert(
        ConnectionStatus.UNKNOWN,
        InfoBarSeverity.info,
        (l) => l.status_unknown,
        (l) => l.status_unknown_desc),
    ConnectionStatus.STARTING: WSAStatusAlert(
        ConnectionStatus.STARTING,
        InfoBarSeverity.info,
        (l) => l.status_starting,
        (l) => l.status_starting_desc),
    ConnectionStatus.ARRESTED: WSAStatusAlert(
        ConnectionStatus.ARRESTED,
        InfoBarSeverity.warning,
        (l) => l.status_arrested,
        (l) => l.status_arrested_desc),
    ConnectionStatus.OFFLINE: WSAStatusAlert(
        ConnectionStatus.OFFLINE,
        InfoBarSeverity.warning,
        (l) => l.status_offline,
        (l) => l.status_offline_desc),
    ConnectionStatus.DISCONNECTED: WSAStatusAlert(
        ConnectionStatus.DISCONNECTED,
        InfoBarSeverity.error,
        (l) => l.status_disconnected,
        (l) => l.status_disconnected_desc),
    ConnectionStatus.CONNECTED: WSAStatusAlert(
        ConnectionStatus.CONNECTED,
        InfoBarSeverity.success,
        (l) => l.status_connected,
        (l) => l.status_connected_desc),
    ConnectionStatus.UNAUTHORIZED: WSAStatusAlert(
        ConnectionStatus.UNAUTHORIZED,
        InfoBarSeverity.warning,
        (l) => l.status_unauthorized,
        (l) => '${l.status_unauthorized_desc}\n'),
  };

  WSAStatusAlert get statusAlert =>
      _statusAlers[this] ??
      WSAStatusAlert(
          this,
          InfoBarSeverity.error,
          (l) => "Unmapped status",
          (l) =>
              "Encountered WSA connection status $this, the status is missing an alert message");
}

extension __EnumExtension on Enum {
  String name() {
    return toString().split('.').last.toLowerCase();
  }
}

class WSAPeriodicConnector {
  static const PERIODIC_CHECK_BOOT_DURATION = Duration(milliseconds: 500);
  static const PERIODIC_CHECK_SLEEPING_DURATION = Duration(milliseconds: 750);
  static const PERIODIC_CHECK_CONNECT_DURATION = Duration(seconds: 5);
  static int lastStart = 0;
  static bool get shouldWaitStart =>
      DateTime.now().millisecondsSinceEpoch - lastStart < 15000;
  static final DynamicTimer timer =
      DynamicTimer((Timer t) => WSAPeriodicConnector._checkConnectionStatus());
  static ConnectionStatus status = ConnectionStatus.UNKNOWN;
  static WSAStatusAlert alertStatus = ConnectionStatus.UNKNOWN.statusAlert;
  static bool _statusInitialized = false;

  /// Immediately triggers a connection status check and waits for it to finish.
  /// Useful for UI-driven "Refresh" actions.
  static Future<void> checkNow() async => _checkConnectionStatus();

  static void _checkConnectionStatus() async {
    if (_statusInitialized) {
      Process.run('${Env.SYSTEM_ROOT}\\System32\\tasklist.exe', [])
          .then((result) {
        if (!result.stdout.toString().contains(RegExp(r'(^|\n)adb.exe\s+'))) {
          status = ConnectionStatus.UNKNOWN;
          GState.connectionStatus.update((p0) => status.statusAlert);
        }
      });
    }

    // ── 3-step pre-connection check (async, never blocks the UI thread) ─────
    final wsaStatus = await WSAStatus.waitForStatus();

    // STARTING override: keep "starting" state for up to 15 s after a boot
    // request so the UI does not flash ARRESTED during a slow WSA startup.
    if (shouldWaitStart &&
        (wsaStatus == ConnectionStatus.MISSING ||
            wsaStatus == ConnectionStatus.ARRESTED ||
            wsaStatus == ConnectionStatus.OFFLINE)) {
      timer.setDuration(PERIODIC_CHECK_BOOT_DURATION);
      if (status != ConnectionStatus.STARTING)
        GState.connectionStatus.$ =
            (status = ConnectionStatus.STARTING).statusAlert;
      return;
    }

    // Step 1 result: package not present
    if (wsaStatus == ConnectionStatus.MISSING) {
      timer.setDuration(PERIODIC_CHECK_BOOT_DURATION);
      final ConnectionStatus newStatus = WinVer.isWindows11OrGreater
          ? ConnectionStatus.MISSING
          : ConnectionStatus.UNSUPPORTED;
      if (status != newStatus)
        GState.connectionStatus.$ = (status = newStatus).statusAlert;
      return;
    }

    // Step 2 result: package present but no WSA process running
    if (wsaStatus == ConnectionStatus.ARRESTED) {
      timer.setDuration(PERIODIC_CHECK_SLEEPING_DURATION);
      if (status != ConnectionStatus.ARRESTED)
        GState.connectionStatus.$ =
            (status = ConnectionStatus.ARRESTED).statusAlert;
      return;
    }

    // Step 3 result: process running but ADB port not open
    if (wsaStatus == ConnectionStatus.OFFLINE) {
      timer.setDuration(PERIODIC_CHECK_SLEEPING_DURATION);
      if (status != ConnectionStatus.OFFLINE)
        GState.connectionStatus.$ =
            (status = ConnectionStatus.OFFLINE).statusAlert;
      return;
    }

    final prevStatus = status;
    final process = await ADBUtils.devices();
    final output = process.stdout.toString();
    if (output.contains(
        RegExp('(^|\\n)(localhost|127.0.0.1):${GState.androidPort.$}\\s+'))) {
      if (output.contains(RegExp(
          '(^|\\n)(localhost|127.0.0.1):${GState.androidPort.$}\\s+offline(\$|\\n|\\s)')))
        status = (status == ConnectionStatus.ARRESTED ||
                    status == ConnectionStatus.STARTING) &&
                shouldWaitStart
            ? ConnectionStatus.STARTING
            : ConnectionStatus.OFFLINE;
      else if (output.contains(RegExp(
          '(^|\\n)(localhost|127.0.0.1):${GState.androidPort.$}\\s+host(\$|\\n|\\s)'))) {
        reconnect();
      } else if (output.contains(RegExp(
          '(^|\\n)(localhost|127.0.0.1):${GState.androidPort.$}\\s+unauthorized(\$|\\n|\\s)'))) {
        status = ConnectionStatus.UNAUTHORIZED;
        if (prevStatus == ConnectionStatus.UNKNOWN) reconnect();
      } else {
        status = ConnectionStatus.CONNECTED;
        if (output
            .contains(RegExp('(^|\\n)127.0.0.1:${GState.androidPort.$}\\s+'))) {
          if (GState.ipAddress.$ != "127.0.0.1")
            GState.ipAddress.update((old) => "127.0.0.1");
        } else if (GState.ipAddress.$ != "localhost")
          GState.ipAddress.update((old) => "localhost");
      }
    } else
      await _tryConnect();
    if (status != prevStatus)
      GState.connectionStatus.update((p0) => status.statusAlert);
    _statusInitialized = false;
    log("Connection status: ${status.name()}");
  }

  static Future<void> reconnect() async {
    await ADBUtils.disconnectWSA();
    await _tryConnect();
  }

  static Future<void> _tryConnect() async {
    ProcessResult? process = await ADBUtils.connectWSA()
        .processTimeout(const Duration(milliseconds: 200));
    if (process.stdout
            ?.toString()
            .contains(RegExp(r'(^|\n)(cannot|failed to) connect\s.*')) ??
        true)
      status = Env.WSA_INSTALLED
          ? (status == ConnectionStatus.ARRESTED ||
                      status == ConnectionStatus.STARTING) &&
                  shouldWaitStart
              ? ConnectionStatus.STARTING
              : ConnectionStatus.OFFLINE
          : ConnectionStatus.DISCONNECTED;
    else if (process.stdout
            ?.toString()
            .contains(RegExp(r'(^|\n)(cannot|failed to) authenticate\s.*')) ??
        true)
      status = ConnectionStatus.UNAUTHORIZED;
    else
      status = ConnectionStatus.CONNECTED;
  }
}

bool get isDesktop {
  if (kIsWeb) return false;
  return [
    TargetPlatform.windows,
    TargetPlatform.linux,
    TargetPlatform.macOS,
  ].contains(defaultTargetPlatform);
}

class Constants {
  static late final String packageFile;
  static late final AppPackage packageType;
  static late final bool installMode;
  static late final bool uninstallMode;
  static late final String uninstallPackage;
  static late final IsolateRef<dynamic, APK_READER_FLAGS>? isolate;
}

void main(List<String> arguments) async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (isDesktop) {
    await windowManager.ensureInitialized();
  }

  AppOptions.init();

  final bool isSyncMode = arguments.contains('--sync');
  if (isSyncMode) {
    await runSyncApps();
    exit(0);
  }

  Constants.uninstallMode =
      arguments.length >= 2 && arguments.first == '--uninstall';
  Constants.uninstallPackage = Constants.uninstallMode ? arguments[1] : '';
  Constants.installMode = !Constants.uninstallMode && arguments.isNotEmpty;
  Constants.packageFile = Constants.installMode ? arguments.first : '';
  Constants.packageType = AppPackageType.fromArguments(arguments);
  Constants.isolate = Constants.installMode
      ? Constants.packageType.read(arguments.first)
      : null;

  WSAPeriodicConnector._checkConnectionStatus();

  darkMode = WidgetsBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;

  if (isDesktop) {
    windowManager.waitUntilReadyToShow(const WindowOptions(
      size: Size(740, 540),
      minimumSize: Size(640, 500),
      center: true,
      title: appTitle,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    ), () async {
      if (Constants.installMode || Constants.uninstallMode) {
        await windowManager.setSize(const Size(500, 335));
        await windowManager.setMinimumSize(const Size(500, 335));
        await windowManager.setMaximumSize(const Size(500, 335));
      }
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(SharedValue.wrapApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = GState.theme.of(context).mode;
    final bool isDark =
        theme == ThemeMode.system ? darkMode : theme == ThemeMode.dark;

    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) {
        final appTheme = context.watch<AppTheme>();
        return FluentApp(
          title: appTitle,
          themeMode: theme,
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          locale: GState.locale.of(context),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            locale.GlobalMaterialLocalizations.delegate,
            FluentLocalizations.delegate,
          ],
          supportedLocales: LocaleUtils.supportedLocales,
          localeResolutionCallback: LocaleUtils.localeResolutionCallback,
          routes: {
            '/': (_) => Constants.uninstallMode
                ? const ApkUninstaller()
                : Constants.installMode
                    ? const ApkInstaller()
                    : const MyHomePage()
          },
          theme: FluentThemeData(
            fontFamily: 'Yu Gothic UI',
            accentColor: appTheme.getColor(isDark),
            brightness: isDark ? Brightness.dark : Brightness.light,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
          ),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool value = false;
  int index = 0;
  final colorsController = ScrollController();
  final settingsController = ScrollController();

  @override
  void dispose() {
    colorsController.dispose();
    settingsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lang = AppLocalizations.of(context)!;
    final appTheme = context.watch<AppTheme>();
    final theme = FluentTheme.of(context);

    return Column(
      children: [
        Expanded(
          child: NavigationView(
            pane: NavigationPane(
              selected: index,
              onChanged: (i) => setState(() => index = i),
              displayMode: PaneDisplayMode.top,
              header: Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedContainer(
                      width: 24,
                      height: 24,
                      duration: const Duration(milliseconds: 750),
                      curve: Curves.fastOutSlowIn,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo.png")),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text("WSA PacMan", style: theme.typography.bodyLarge),
                    const SizedBox(width: 20),
                  ],
                ),
              ),
              indicator: () {
                switch (appTheme.indicator) {
                  case NavigationIndicators.end:
                    return const EndNavigationIndicator();
                  case NavigationIndicators.sticky:
                    return const StickyNavigationIndicator();
                }
              }(),
              items: [
                PaneItem(
                  icon: const Icon(Icons.android, size: 18),
                  title: const Text('WSA'),
                  body: const ScreenWSA(),
                ),
                PaneItem(
                  icon: const Icon(fsi.FluentIcons.delete_24_regular, size: 18),
                  title: const Text('Uninstall'),
                  body: const ScreenAppManager(),
                ),
              ],
              footerItems: [
                PaneItemHeader(
                  header: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      width: 1,
                      height: 16,
                      color: theme.inactiveColor.withOpacity(0.3),
                    ),
                  ),
                ),
                PaneItem(
                  icon:
                      const Icon(fsi.FluentIcons.settings_24_regular, size: 18),
                  title: Text(lang.screen_settings),
                  body: ScreenSettings(controller: settingsController),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
