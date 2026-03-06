// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures, constant_identifier_names

import 'dart:async';
import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:shared_value/shared_value.dart';
import 'package:wsa_pacman/io/isolate_runner.dart';
import 'package:wsa_pacman/utils/future_utils.dart';
import 'package:wsa_pacman/utils/wsa_utils.dart';
import 'package:wsa_pacman/windows/nt_io.dart';
import 'package:wsa_pacman/windows/win_io.dart';
import 'package:wsa_pacman/windows/win_path.dart';

import 'android_utils.dart';
import 'permissions.dart';
import 'package:wsa_pacman/global_state.dart';
import 'package:wsa_pacman/main.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'dart:developer';
import 'dart:convert';
import 'package:jovial_svg/jovial_svg.dart';
import '../utils/regexp_utils.dart';
import '../utils/string_utils.dart';
import '../utils/misc_utils.dart';

/// Reads apk file data on a different process and updates global state
/// Must call [ApkReader.start] to start the process
class ApkReader extends IsolateRunner<String, APK_READER_FLAGS> {
  //I just put '&& true' there so I could conveniently switch it off
  static bool DEBUG = !kReleaseMode && true;
  static String APK_FILE = '';
  static late Future<Map<String, Resource>> _resourceDump;
  static late Future<Map<int, String>> _stringDump;
  static late Future<Archive> _apkArchive;
  static int _versionCode = 0;

  static const String REGEX_QUOTED_TYPE = r'["' ']type[0-9]+/([0-9]*)["' ']';

  /// Run operation on UI thread
  /// Local variables should never be called
  void setInUIThread<T>(T value, Function(T val) setter) => executeInUi(() {
        setter(value);
      });

  /// Changes shared value on UI thread
  /// Local variables should never be called
  void updateState<T>(SharedValue<T> Function() valGetter, T dataIn) =>
      executeInUi(() {
        valGetter().$ = dataIn;
      });

  /// Changes shared value on UI thread via a callback
  /// Local variables should never be called
  void updateStateWith<T, E>(SharedValue<T> Function() valGetter, E dataIn,
          [T Function(E data)? provider]) =>
      executeInUi(() {
        final sharedValue = valGetter();
        provider != null
            ? sharedValue.$ = provider(dataIn)
            : sharedValue.$ = dataIn as T;
      });

  static Future<Archive> _initArchiveFile(File file) async {
    // This fixes issues when loading huge files (I'm allowing sync reads on SSDs only, and setting a 320MB limit)
    return file.isInSSD() && file.lengthSync() < 335544321
        ? ZipDecoder().decodeBytes(file.readAsBytesSync())
        : ZipDecoder().decodeStream(InputFileStream(file.absolute.path));
  }

  static void _initArchive() {
    //Maintain a lock on the file
    File file = File(APK_FILE)..open();
    _apkArchive = _initArchiveFile(file);
  }

  /// Decodes a binary xml
  static Future<Uint8List> _decodeXml(List<int> encoded) async {
    var axmldec = await Process.start('${Env.TOOLS_DIR}\\axmldec.exe', []);
    axmldec.stdin.add(encoded);
    //For some reason i need this
    axmldec.stdin.writeln();
    await axmldec.stdin.flush();
    await axmldec.stdin.close();
    var builder = BytesBuilder();
    //Encoded is just there not to create a new empty list
    await axmldec.stdout.fold(encoded, (prev, newv) {
      builder.add(newv);
      return prev;
    });
    return builder.takeBytes();
  }

  /// Returns the gradient as an aapt xml element
  static Future<String> getGradient(String gradientId) async {
    Resource? gradientRes = await getResources(gradientId);
    if (gradientRes == null) return "";
    String resValue = gradientRes.values.first;
    // TODO this is a dirty hack because I did not foresee the 'type1' resource to refer to plain color resources and not just gradients
    if (!resValue.endsWith(".xml"))
      return gradientRes.type == ResType.COLOR
          ? '<aapt:attr name="android:fillColor"><gradient android:type="linear" android:startX="0" android:startY="0" android:endX="1" android:endY="1"><item android:color="#$resValue" android:offset="0"/></gradient></aapt:attr>'
          : '';
    Archive apkFile = await _apkArchive;
    ArchiveFile? gradientFile = apkFile.findFile(gradientRes.values.first);
    if (gradientFile == null) return "";
    String gradient = RegExp("<gradient.*", multiLine: true, dotAll: true)
            .firstMatch(await decodeXml(gradientFile.content, true))
            ?.group(0) ??
        "";
    return '<aapt:attr name="android:fillColor">$gradient</aapt:attr>';
  }

  /// Starts asyncronous task to retrieve the gradient xml, returns a placeholder string containing gradent ID
  static String _getGradientPlaceholder(
      Map<String, Future<String>> gradients, String gradientId) {
    String placeholder = "@@FUTURE_GRADIENT_$gradientId@@";
    if (gradients.containsKey(gradientId))
      return placeholder;
    else
      gradients[gradientId] = getGradient(gradientId);
    return placeholder;
  }

  /// Returns xml string, clears errors and normalizes fields
  static Future<String> decodeXml(Uint8List encoded,
      [bool isGradient = false]) async {
    Map<String, Future<String>>? futureGradients = isGradient ? null : {};
    var xml = utf8.decode(await _decodeXml(encoded), allowMalformed: true);
    if (!isGradient)
      xml = xml
          .replaceAllMapped(
              RegExp('([\\s\\n]android:pathData=[\'"])[^M]*(M\\s*-?[0-9])'),
              (m) => m.group(1)! + m.group(2)!)
          // ★ 修正: m.group(6) を tryParse に変更
          .replaceAllMapped(
              RegExp(
                  '<(([a-zA-Z0-9]*)\\s+$REGEX_XML_NOCLOSE)(android:fillColor=[\'"])(type1/([0-9]*)[\'"])($REGEX_XML_NOCLOSE)>',
                  multiLine: true,
                  dotAll: true),
              (m) =>
                  '<${m.group(1)!}${m.group(7)!.endsWith("/") ? m.group(7)!.substring(0, m.group(7)!.length - 1) : m.group(7)!}>\n${_getGradientPlaceholder(futureGradients!, "0x${(int.tryParse(m.group(6)!) ?? 0).toRadixString(16).padLeft(8, '0')}")}${m.group(7)!.endsWith("/") ? "\n</${m.group(2)}>" : "\n"}')
          // ★ 修正: m.group(4) を tryParse に変更
          .replaceAllMapped(
              RegExp('([cC]olor=[\'"])(type([0-9])+/([0-9]*))'),
              (m) =>
                  '${m.group(1)!}#${(int.tryParse(m.group(4)!) ?? 0).toRadixString(16).padLeft(8, '0')}')
          .replaceAllMapped(RegExp('([\\s\\n]android:fillType=[\'"])([0-9]*)'),
              (m) => m.group(1)! + (fillType[m.group(2)!] ?? "winding"));
    else
      xml = xml
          .replaceAllMapped(
              RegExp('([cC]olor=[\'"])(type([0-9])+/([0-9]*))'),
              (m) =>
                  '${m.group(1)!}#${(int.tryParse(m.group(4)!) ?? 0).toRadixString(16).padLeft(8, '0')}')
          .replaceAll(
              RegExp(
                  "(xmlns:[^=\\s]*|android:angle)\\s*=\\s*$REGEX_XML_QUOTED"),
              "")
          .replaceAllMapped(RegExp('(android:type\\s*=\\s*[\'"])([0-9]*)'),
              (m) => m.group(1)! + (gradientType[m.group(2)!] ?? "linear"));

    if (!isGradient) {
      var gradientList = await Future.wait(futureGradients!.values);
      Map<String, String> gradientMap = {};
      int i = 0;
      for (var gradient in futureGradients.keys)
        gradientMap[gradient] = gradientList[i++];
      xml = xml.replaceAllMapped(RegExp("@@FUTURE_GRADIENT_([a-zA-Z0-9]*)@@"),
          (m) => gradientMap[m.group(1)] ?? "");
    }
    return xml;
  }

  /// Retrieves a resource from the resource ID
  static Future<Resource?> getResources(String resId) async {
    Map<String, Resource> resources = await _resourceDump;
    if (DEBUG) log("checking RES-ID: $resId");
    var resource = resources[resId];
    if (resource != null) {
      if (DEBUG)
        log("found RES-VALUES: ${resource.values} of RES-TYPE: ${resource.type} for RES-ID: $resId");
      if (resource.type == ResType.COLOR)
        return resource;
      // TODO I'm assuming the resource references are all of the same type
      else if (resource.type == ResType.POINTER)
        return resource.values
            .map((e) => getResources('0x$e'))
            .foldFuturesSkipNulls(
                (e1, e2) => e1..values = [...e1.values, ...e2.values]);
      Map<int, String> strings = await _stringDump;
      // ★ 修正: 例のクラッシュ原因！ parse を tryParse に変更し、ダメなら 0 にする
      Iterable<String> files = strings.getAll(
          resource.values.map((e) => (int.tryParse(e, radix: 16) ?? 0)));
      if (DEBUG)
        log("found RES-FILES: $files of RES-TYPE: ${resource.type} for RES-ID: $resId");
      return files.isNotEmpty ? Resource(files, resource.type) : null;
    } else
      return null;
  }

  /// Retrieves non-adaptive icon image
  Future _getIconFile(String fileName) async {
    bool isXml = fileName.endsWith(".xml");
    Archive apkFile = await _apkArchive;
    ArchiveFile IconFile = apkFile.findFile(fileName)!;

    Uint8List image = IconFile.content;
    String xmlData = isXml ? await decodeXml(image) : "";
    Widget? widget = isXml ? null : Image.memory(image);
    updateStateWith(
        () => GState.apkIcon,
        isXml ? xmlData : widget,
        !isXml
            ? null
            : (data) => ScalableImageWidget(
                si: ScalableImage.fromAvdString(data as String)));
  }

  /// Retrieves adaptive icon background and foreground images
  Future _getAdaptiveIconFiles(
      String? backgroundId, String foregroundId) async {
    Future<Resource?>? futureBackground =
        backgroundId != null ? getResources(backgroundId) : null;
    Future<Resource?> futureForeground = getResources(foregroundId);
    Resource? background =
        futureBackground != null ? await futureBackground : null;
    Resource foreground = (await futureForeground)!;
    bool isBackColor = background?.type == ResType.COLOR;
    bool isBackXml = !isBackColor &&
        (background?.values.isNotEmpty ?? false) &&
        background!.values.first.endsWith(".xml");
    bool isForeXml = foreground.values.isNotEmpty &&
        foreground.values.first.endsWith(".xml");

    Archive apkFile = await _apkArchive;
    List<ArchiveFile>? backFiles =
        isBackColor ? [] : apkFile.getFiles(background?.values);
    List<ArchiveFile> foreFiles = apkFile.getFiles(foreground.values);

    Uint8List foreImg =
        isForeXml ? foreFiles.first.content : foreFiles.last.content;
    Uint8List? backImg = (backFiles.isEmpty)
        ? null
        : isBackXml
            ? backFiles.first.content
            : backFiles.last.content;
    var foreXml = isForeXml ? decodeXml(foreImg) : null;
    var backXml = isBackXml && backImg != null ? decodeXml(backImg) : null;
    Widget? backWidget;
    Widget? foreWidget;

    if (!isForeXml) foreWidget = Image.memory(foreImg);
    if (!isBackXml)
      backWidget = isBackColor
          ? null
          : (backImg != null)
              ? Image.memory(backImg)
              : null;

    String backXmlData = isBackXml && backXml != null ? await backXml : "";
    String foreXmlData = isForeXml ? await foreXml! : "";

    if (isBackColor) {
      // ★ 修正: ここも tryParse に変更
      final color =
          Color((int.tryParse(background!.values.first, radix: 16) ?? 0));
      updateState(() => GState.apkBackgroundColor, color);
    } else if (backWidget != null || backXml != null)
      updateStateWith(
          () => GState.apkBackgroundIcon,
          isBackXml ? backXmlData : backWidget,
          !isBackXml
              ? null
              : (data) => ScalableImageWidget(
                  si: ScalableImage.fromAvdString(data as String)));
    updateStateWith(
        () => GState.apkForegroundIcon,
        isForeXml ? foreXmlData : foreWidget,
        !isForeXml
            ? null
            : (data) => ScalableImageWidget(
                si: ScalableImage.fromAvdString(data as String)));
  }

  /// Retrieves installation type (whether installing for the first time, reinstalling the same version, upgrading or downgrading)
  static Future loadInstallType(String package, int versionCode) async {
    if (package.isEmpty) return;
    try {
      String ipAddress = await GState.ipAddress.whenReady();
      int port = await GState.androidPort.whenReady();

      var result = await ADBUtils.shellToAddress(
          ipAddress, port, 'dumpsys package $package');
      var verMatch = RegExp(
              r'(\n|\s|^)versionCode=([0-9]*)[^\n]*(\n([^\s\n]*\s)*versionName=([^\n\s_$]*))?')
          .firstMatch(result.stdout.toString());
      int? oldVersionCode = int.tryParse(verMatch?.group(2) ?? "");

      if (oldVersionCode != null) {
        GState.apkInstallType.update((_) => (oldVersionCode < versionCode)
            ? InstallType.UPDATE
            : (oldVersionCode > versionCode)
                ? InstallType.DOWNGRADE
                : InstallType.REINSTALL);
        String oldVersion = verMatch!.group(5) ?? "???";
        GState.oldVersion.update((_) => oldVersion);
      } else {
        GState.apkInstallType.update((_) => InstallType.INSTALL);
      }
    } catch (e) {
      // エラー時は強制的に新規インストール扱いにしてぐるぐるを止める
      GState.apkInstallType.update((_) => InstallType.INSTALL);
    }
  }

  void loadInstallInfoOnUIThread(String package, int versionCode) =>
      package.isNotEmpty
          ? executeInUi(() {
              GState.package.update((_) => package);
              loadInstallType(package, versionCode);
            })
          : null;

  // =========================================================
  // UI更新時の「Future変数の巻き込みクラッシュ」を防ぐための静的ヘルパー関数
  // =========================================================
  static void _reportEmptyPackage(ApkReader reader) {
    reader.executeInUi(() {
      GState.apkTitle.$ = "エラー (パッケージ空)";
      GState.errorCode.$ = "EMPTY_PKG";
      GState.errorDesc.$ = "パッケージ情報がありません。";
      GState.apkInstallState.$ = InstallState.ERROR;
      GState.apkInstallType.$ = InstallType.INSTALL;
    });
  }

  static void _reportAaptError(ApkReader reader, int exitCode, String stderr) {
    reader.executeInUi(() {
      GState.apkTitle.$ = "AAPT エラー";
      GState.apkInstallState.$ = InstallState.ERROR;
      GState.errorCode.$ = "AAPT_ERR ($exitCode)";
      GState.errorDesc.$ = stderr;
      GState.apkInstallType.$ = InstallType.INSTALL;
    });
  }

  static void _reportCrash(ApkReader reader, String errMsg, String errStack) {
    reader.executeInUi(() {
      GState.apkTitle.$ = "Isolate 突然死";
      GState.apkInstallState.$ = InstallState.ERROR;
      GState.errorCode.$ = "CRASH";
      // RenderFlex overflow (UI崩れ) を防ぐため、エラーログが長すぎる場合は切り詰める
      String shortStack =
          errStack.length > 400 ? "${errStack.substring(0, 400)}..." : errStack;
      GState.errorDesc.$ = "裏方処理クラッシュ:\n$errMsg\n$shortStack";
      GState.apkInstallType.$ = InstallType.INSTALL;
    });
  }

  /// Retrieves APK information
  @override
  void run() async {
    try {
      File APK_FILE_F = File(APK_FILE = data);
      bool ntSymlinkCreated = false;
      String APK_DIRECORY = APK_FILE_F.parent.path;
      String APK_NAME = APK_FILE_F.basename;

      if (!APK_NAME.isASCII) {
        String? shortName = APK_FILE_F.shortBaseName;
        if (shortName != null && shortName.isASCII)
          APK_NAME = shortName;
        else {
          String? ntSymlink = NtIO.createTempShortcut(
              APK_FILE_F.absolute.path, "install-symlink@$pid.apk");
          if (ntSymlink != null) {
            ntSymlinkCreated = true;
            APK_NAME = ntSymlink;
            APK_DIRECORY = WinPath.tempSubdir;
          }
        }
      }

      _resourceDump = Process.run(
              '${Env.TOOLS_DIR}\\aapt.exe', ['dump', 'resources', APK_NAME],
              workingDirectory: APK_DIRECORY)
          .then((p) => p.stdout.toString().foldToMap(
              r'(^|\n)\s*resource\s+(0x[0-9a-zA-Z]*)[\s]+.*\st=0x0*([^\s\n]*).*\sd=0x0*([^\s\n]*)[\s|\n]',
              (m) => m.group(2)!,
              (m, old) => Resource(
                  (old != null)
                      ? ((old.values as ListQueue<String>)
                        ..addAll([m.group(4)!]))
                      : ListQueue<String>.from([m.group(4)!]),
                  old?.type ?? getResType(m.group(3)!))));

      _stringDump = Process.run(
              '${Env.TOOLS_DIR}\\aapt.exe', ['dump', 'strings', APK_NAME],
              workingDirectory: APK_DIRECORY)
          .then((p) => p.stdout.toString().toMap(
              r'(^|\n)\s*String\s+#([0-9]*)\s*:\s*([^\s\n]*)',
              (m) => int.parse(m.group(2)!),
              (m) => m.group(3)!));

      _initArchive();

      bool legacyIcon = false;

      Future? iconUpdThread;
      Future<ProcessResult>? inner;

      var process = Process.run(
              '${Env.TOOLS_DIR}\\aapt.exe', ['dump', 'badging', APK_NAME],
              stdoutEncoding: utf8, workingDirectory: APK_DIRECORY)
          .then((value) async {
        if (ntSymlinkCreated) NtIO.deleteNtTempDirJunction();
        if (value.exitCode == 0) {
          String dump = value.stdout;
          String? info = dump.find(r'(^|\n)package:.*');

          int versionCode = int.parse(
              info?.find(r"(^|\n|\s)versionCode=\s*'([^'\n\s$]*)", 2) ?? "0");
          setInUIThread(versionCode, (int v) => ApkReader._versionCode = v);

          String package =
              info?.find(r"(^|\n|\s)name=\s*'([^'\n\s$]*)", 2) ?? "";
          if (package.isEmpty) {
            _reportEmptyPackage(this);
            return;
          }

          loadInstallInfoOnUIThread(package, versionCode);

          updateStateWith(
              () => GState.version,
              info,
              (String? v) =>
                  v?.find(r"(^|\n|\s)versionName=\s*'([^'\n\s_$]*)", 2) ?? "");
          updateStateWith(
              () => GState.activity,
              dump,
              (String v) =>
                  v.find(
                      r"(^|\n)(leanback-)?launchable-activity:.*name='([^'\n\s$]*)",
                      3) ??
                  "");

          String? application = dump.find(r'(^|\n)application:\s*(.*)');
          String? title = application?.find(r"(^|\n|\s)label='([^']*)'", 2);
          String? icon = application?.find(r"(^|\n|\s)icon='([^']*)'", 2);
          updateState(() => GState.apkTitle, title ?? "UNKNOWN_TITLE");

          Set<AndroidPermission> permissions = dump.toSet(
              "(^|\\n)\\s*uses-permission(-[^:]*)?:\\s+name=[\"']([^\"'\\n]*)",
              (m) => AndroidPermissionList.get(m.group(3)!),
              (a, b) => a.index - b.index);
          if (permissions.isEmpty) permissions.add(AndroidPermission.NONE);
          updateState(() => GState.permissions, permissions);

          if (icon?.endsWith(".xml") ?? false)
            inner = Process.run('${Env.TOOLS_DIR}\\aapt2.exe',
                ['dump', 'xmltree', '--file', icon!, APK_FILE])
              ..then((value) {
                if (value.exitCode != 0) return;
                String iconData = value.stdout.toString();
                String? background = iconData.find(
                    r'(^|\n|\s)*E:[\s]?background\s[^\n]*\n\s*A:.*=@([^\s\n]*)',
                    2);
                String? foreground = iconData.find(
                    r'(^|\n|\s)*E:[\s]?foreground\s[^\n]*\n\s*A:.*=@([^\s\n]*)',
                    2);
                if (foreground != null)
                  iconUpdThread = _getAdaptiveIconFiles(background, foreground);
                else
                  iconUpdThread = _getIconFile(icon);
              });
          else if (icon != null && icon.isNotEmpty) {
            iconUpdThread = _getIconFile(icon);
          }
        } else {
          _reportAaptError(this, value.exitCode, value.stderr.toString());
        }
      });

      await process;
      if (inner != null) await inner;
      if (iconUpdThread != null) await iconUpdThread;
      setInUIThread(legacyIcon, (bool v) => setDefaultIcon(v));
    } catch (e, stack) {
      // Future変数の巻き込みを防ぐため、静的メソッド経由でUIに通知する
      _reportCrash(this, e.toString(), stack.toString());
    }
  }

  /// Uses the default application icon if no icon has been found
  /// Has to be called in the UI thread
  static void setDefaultIcon(bool legacyIcon) async {
    if (GState.apkForegroundIcon.$ == null && GState.apkIcon.$ == null) {
      if (legacyIcon) {
        final legacy = await ScalableImage.fromSIAsset(
            rootBundle, "assets/icons/missing_icon_legacy.si");
        GState.apkIcon.update((p0) => (ScalableImageWidget(si: legacy)));
      } else {
        final fBackground = ScalableImage.fromSIAsset(
            rootBundle, "assets/icons/missing_icon_background.si");
        final fForeground = ScalableImage.fromSIAsset(
            rootBundle, "assets/icons/missing_icon_foreground.si");
        final background = await fBackground, foreground = await fForeground;
        GState.apkBackgroundIcon
            .update((p0) => (ScalableImageWidget(si: background)));
        GState.apkForegroundIcon
            .update((p0) => (ScalableImageWidget(si: foreground)));
      }
    }
  }

  FutureOr<R> computeOrDebug<Q, R>(ComputeCallback<Q, R> callback, Q message,
          {String? debugLabel}) =>
      (DEBUG)
          ? callback(message)
          : compute(callback, message, debugLabel: debugLabel);

  @override
  FutureOr<void> postStartCallback(
      IsolateRef<String, APK_READER_FLAGS> isolate) {
    GState.legacyIcons.doWhenReady((value) {
      isolate.sendFlag(APK_READER_FLAGS.LEGACY_ICON, value);
    });
    late StreamSubscription sub;
    sub = GState.connectionStatus.stream.listen((event) async {
      InstallType? installType = GState.apkInstallType.$;
      if (GState.apkInstallType.$ == InstallType.UNKNOWN) {
        await loadInstallType(GState.package.$, _versionCode);
        if (GState.apkInstallType.$ != InstallType.UNKNOWN) sub.cancel();
      } else if (installType != null) sub.cancel();
    });
  }
}
