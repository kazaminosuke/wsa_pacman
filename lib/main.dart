// ignore_for_file: constant_identifier_names, curly_braces_in_flow_control_structures, non_constant_identifier_names, deprecated_member_use, library_private_types_in_public_api

import 'dart:io';
import 'dart:developer';
import 'dart:async';

import 'package:mdi/mdi.dart';
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
import 'global_state.dart';

import 'package:provider/provider.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart' as flutter_acrylic;

import 'screens/wsa.dart';
import 'screens/settings.dart';
import 'screens/app_manager.dart';
import 'screens/apk_uninstaller.dart'; // Add the uninstaller screen
import 'utils/string_utils.dart';
import 'sync_apps.dart';

import 'theme.dart';
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

class Env {
  static final String SYSTEM_ROOT = Platform.environment["SystemRoot"] ?? "";
  static final String USER_PROFILE = Platform.environment["UserProfile"] ?? "";

  // 実行ファイル（.exe）があるディレクトリを取得
  static String get EXEC_DIR => File(Platform.resolvedExecutable).parent.path;

  // 絶対パスでツールフォルダを指定（末尾の \\ を削除）
  static String get TOOLS_DIR => "$EXEC_DIR\\embedded-tools";

  static final String POWERSHELL = WinReg.getString(
              RegHKey.HKEY_LOCAL_MACHINE,
              r'SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell',
              'Path')
          ?.value ??
      '$SYSTEM_ROOT\\System32\\WindowsPowerShell\\v1.0\\powershell.exe';

  static final String WSA_SYSTEM_PATH = RegExp(
              r'^(.*)[\\/]+[^\\/]*[\\/]+[^\\/]*$')
          .firstMatch(WinReg.getString(
                      RegHKey.HKEY_LOCAL_MACHINE,
                      r'SYSTEM\CurrentControlSet\Services\WsaService',
                      'ImagePath')
                  ?.value
                  .unquoted ??
              WinReg.getString(
                      RegHKey.HKEY_CURRENT_USER,
                      r'Software\Microsoft\Windows\CurrentVersion\App Paths\WsaClient.exe',
                      null)
                  ?.value ??
              '')
          ?.group(1) ??
      '';

  static final String WSA_EXECUTABLE =
      '$WSA_SYSTEM_PATH\\WsaClient\\WsaClient.exe';
  static final bool WSA_INSTALLED =
      File('$WSA_SYSTEM_PATH\\AppxManifest.xml').existsSync();
  static final WSA_INFO = WSAPkgInfo.fromSystemPath(WSA_SYSTEM_PATH);
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

    // ── 3-step pre-connection check ──────────────────────────────────────────
    final wsaStatus = WSAStatus.getStatus();

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
  await flutter_acrylic.Window.initialize();

  const app = MyApp();
  final wrappedApp = SharedValue.wrapApp(app);
  darkMode = WidgetsBinding.instance.platformDispatcher.platformBrightness ==
      Brightness.dark;
  runApp(wrappedApp);

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

  flutter_acrylic.Window.hideWindowControls();

  if (isDesktop) {
    doWhenWindowReady(() {
      final win = appWindow;
      if (!Constants.installMode && !Constants.uninstallMode) {
        win.minSize = const Size(640, 500);
        win.size = const Size(740, 540);
        win.title = appTitle;
      } else {
        win.minSize = win.maxSize = win.size = const Size(500, 335);
      }
      win.alignment = Alignment.center;
      win.show();
      late final SET_VISIBLE =
          Constants.isolate?.sendFlag(APK_READER_FLAGS.UI_LOADED, true);
      late final Timer uiTimer;
      uiTimer = Timer.periodic(const Duration(milliseconds: 100), (t) {
        if (win.isVisible) {
          SET_VISIBLE;
          uiTimer.cancel();
        }
      });
    });
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // ★ 修正1: setStateを使わずに値を監視できる ValueNotifier に変更
  final ValueNotifier<bool> _isFocused = ValueNotifier(true);
  Timer? _focusTimer;

  @override
  void initState() {
    super.initState();
    if (isDesktop) {
      _focusTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
        _checkFocus();
      });
    }
  }

  @override
  void dispose() {
    _focusTimer?.cancel();
    _isFocused.dispose(); // メモリリーク防止
    super.dispose();
  }

  void _checkFocus() {
    final foregroundHwnd = GetForegroundWindow();
    if (foregroundHwnd == 0) return;

    final pidPtr = calloc<Uint32>();
    GetWindowThreadProcessId(foregroundHwnd, pidPtr);
    final foregroundPid = pidPtr.value;
    free(pidPtr);

    final isFocused = (foregroundPid == pid);
    // ★ 修正2: setStateを削除し、valueを直接書き換えるだけにする
    if (_isFocused.value != isFocused) {
      _isFocused.value = isFocused;
    }
  }

  void setMicaEffect(bool micaEnabled, [bool dark = true]) {
    if (WinVer.isWindows11OrGreater) {
      flutter_acrylic.Window.setEffect(
        effect: micaEnabled
            ? flutter_acrylic.WindowEffect.mica
            : flutter_acrylic.WindowEffect.disabled,
        color: dark ? const Color(0x00000000) : const Color(0x00FFFFFF),
        dark: dark,
      );
    } else {
      flutter_acrylic.Window.setEffect(
        effect: flutter_acrylic.WindowEffect.disabled,
        color: dark ? const Color(0xFF202020) : const Color(0xFFF3F3F3),
        dark: dark,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = GState.theme.of(context).mode;
    final mica = GState.mica.of(context);

    final bool isDark =
        theme == ThemeMode.system ? darkMode : theme == ThemeMode.dark;
    setMicaEffect(mica.enabled, isDark);

    final bool isMicaActive = mica.enabled && WinVer.isWindows11OrGreater;
    // Explorer-like extreme transparency: almost clear to let Mica completely shine through
    final Color fallbackColor =
        isDark ? const Color(0x111E1E1E) : const Color(0x33F9F9F9);

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
          builder: (context, child) {
            // ★ 修正3: ValueListenableBuilderで包むことで「背景のコンテナだけ」を再描画する
            return ValueListenableBuilder<bool>(
              valueListenable: _isFocused,
              builder: (context, isFocused, _) {
                final Color bgColor = (isFocused && isMicaActive)
                    ? Colors.transparent
                    : fallbackColor;
                return Container(
                  color: bgColor,
                  child: child,
                );
              },
            );
          },
          theme: FluentThemeData(
            fontFamily: 'Yu Gothic UI',
            scaffoldBackgroundColor:
                mica.full ? Colors.transparent : fallbackColor,
            micaBackgroundColor: Colors.transparent,
            navigationPaneTheme: const NavigationPaneThemeData(
              backgroundColor: Colors.transparent,
            ),
            accentColor: appTheme.getColor(isDark),
            brightness: isDark ? Brightness.dark : Brightness.light,
            visualDensity: VisualDensity.standard,
            focusTheme: FocusThemeData(
              glowFactor: is10footScreen(context) ? 2.0 : 0.0,
            ),
            buttonTheme: ButtonThemeData(
              defaultButtonStyle: ButtonStyle(
                shadowColor: const WidgetStatePropertyAll(Colors.transparent),
                shape: WidgetStateProperty.resolveWith((states) {
                  BorderSide side;
                  if (isDark) {
                    if (states.contains(WidgetState.disabled))
                      side = const BorderSide(
                          width: 0.5, color: Color(0x0Df0f0f0));
                    else if (states.isEmpty ||
                        (states.contains(WidgetState.hovered) &&
                            !states.contains(WidgetState.pressed)))
                      side = const BorderSide(
                          width: 0.5, color: Color(0x09f0f0f0));
                    else
                      side = const BorderSide(
                          width: 0.5, color: Color(0x12f0f0f0));
                  } else {
                    if (states.contains(WidgetState.disabled))
                      side = const BorderSide(
                          width: 0.5, color: Color(0x1F212121));
                    else if (states.isEmpty ||
                        (states.contains(WidgetState.hovered) &&
                            !states.contains(WidgetState.pressed)))
                      side = const BorderSide(
                          width: 0.5, color: Color(0x38212121));
                    else
                      side = const BorderSide(
                          width: 0.5, color: Color(0x12212121));
                  }
                  return RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0), side: side);
                }),
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (isDark) {
                    if (states.contains(WidgetState.disabled))
                      return const Color(0x08FFFFFF);
                    if (states.contains(WidgetState.pressed))
                      return const Color(0x04FFFFFF);
                    if (states.contains(WidgetState.hovered))
                      return const Color(0x0AFFFFFF);
                    return const Color(0x06FFFFFF);
                  } else {
                    if (states.contains(WidgetState.disabled))
                      return const Color(0x08f9f9f9);
                    if (states.contains(WidgetState.pressed))
                      return const Color(0x33f0f0f0);
                    if (states.contains(WidgetState.hovered))
                      return const Color(0x66f9f9f9);
                    return const Color(0x4DFFFFFF);
                  }
                }),
              ),
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
        // 1段目：ウィンドウのタイトルバー（薄い文字の正式アプリ名と、右端のバツボタン等）
        if (!kIsWeb)
          WindowTitleBarBox(
            child: Row(
              children: [
                Expanded(
                  child: MoveWindow(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Text(
                              appTitle,
                              // captionからbodyに変更し、薄さを解除してクッキリさせました！
                              style: theme.typography.body,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'v$appVersion',
                              // バージョンも少し濃くして見やすく調整
                              style: theme.typography.caption?.copyWith(
                                  color: theme.inactiveColor.withOpacity(0.6)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const WindowButtons(),
              ],
            ),
          ),

        // 2段目：ナビゲーションバー（ロゴ、WSAタブ、右端に区切り線と設定ボタン）
        Expanded(
          child: NavigationView(
            pane: NavigationPane(
              selected: index,
              onChanged: (i) => setState(() => index = i),
              displayMode: PaneDisplayMode.top,
              // 左側のヘッダー部分にロゴと「WSA PacMan」を配置
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
                    const SizedBox(width: 20), // タブとの少しの隙間
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
                  icon: const Icon(Mdi.androidDebugBridge),
                  title: const Text('WSA'),
                  body: const ScreenWSA(),
                ),
                // ★ 修正：アイコンをゴミ箱に、名前をUninstallに
                PaneItem(
                  icon: const Icon(FluentIcons.delete),
                  title: const Text('Uninstall'),
                  body: const ScreenAppManager(),
                ),
              ],
              footerItems: [
                // ★ 消えてしまう標準のSeparatorの代わりに、自作の「棒」を強制的に描画する！
                PaneItemHeader(
                  header: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      width: 1, // 棒の太さ
                      height: 16, // 棒の高さ
                      color: theme.inactiveColor.withOpacity(0.3), // ちょうどいいグレー
                    ),
                  ),
                ),
                PaneItem(
                  icon: const Icon(FluentIcons.settings),
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

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});

  static Color windowButtonAlphaColor(
      FluentThemeData style, Set<WidgetState> states) {
    if (style.brightness == Brightness.light) {
      if (states.contains(WidgetState.pressed))
        return Colors.black.withOpacity(0.075);
      if (states.contains(WidgetState.hovered))
        return Colors.black.withOpacity(0.11);
      return Colors.transparent;
    } else {
      if (states.contains(WidgetState.pressed))
        return Colors.white.withOpacity(0.03);
      if (states.contains(WidgetState.hovered))
        return Colors.white.withOpacity(0.06);
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    assert(debugCheckHasFluentTheme(context));
    assert(debugCheckHasFluentLocalizations(context));
    final FluentThemeData theme = FluentTheme.of(context);
    final mica = GState.mica.of(context);

    final buttonColors = WindowButtonColors(
      iconNormal: theme.inactiveColor,
      iconMouseDown: theme.inactiveColor,
      iconMouseOver: theme.inactiveColor,
      mouseOver: mica.enabled
          ? windowButtonAlphaColor(theme, {WidgetState.hovered})
          : Colors.transparent,
      mouseDown: mica.enabled
          ? windowButtonAlphaColor(theme, {WidgetState.pressed})
          : Colors.transparent,
    );

    final closeButtonColors = WindowButtonColors(
      mouseOver: Colors.red,
      mouseDown: Colors.red.dark,
      iconNormal: theme.inactiveColor,
      iconMouseOver: Colors.red.basedOnLuminance(),
      iconMouseDown: Colors.red.dark.basedOnLuminance(),
    );

    return Row(children: [
      Tooltip(
        message: FluentLocalizations.of(context).minimizeWindowTooltip,
        child: MinimizeWindowButton(colors: buttonColors),
      ),
      Tooltip(
        message: FluentLocalizations.of(context).restoreWindowTooltip,
        child: WindowButton(
          colors: buttonColors,
          iconBuilder: (context) {
            if (appWindow.isMaximized) {
              return RestoreIcon(color: context.iconColor);
            }
            return MaximizeIcon(color: context.iconColor);
          },
          onPressed: appWindow.maximizeOrRestore,
        ),
      ),
      Tooltip(
        message: FluentLocalizations.of(context).closeWindowTooltip,
        child: CloseWindowButton(colors: closeButtonColors),
      ),
    ]);
  }
}
