// ignore_for_file: non_constant_identifier_names, curly_braces_in_flow_control_structures, constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:archive/archive_io.dart';
import 'package:collection/collection.dart';

import 'package:flutter/cupertino.dart';
import 'package:wsa_pacman/android/android_utils.dart';
import 'package:wsa_pacman/android/permissions.dart';
import 'package:wsa_pacman/android/reader_apk.dart';
import 'package:wsa_pacman/global_state.dart';
import 'package:wsa_pacman/io/isolate_runner.dart';
import 'package:wsa_pacman/main.dart';
import 'package:wsa_pacman/utils/misc_utils.dart';
import 'package:wsa_pacman/proto/manifest_xapk.pb.dart';
import 'package:wsa_pacman/utils/wsa_utils.dart';
import 'package:wsa_pacman/windows/win_io.dart';
import 'package:wsa_pacman/windows/win_path.dart';
import 'package:path/path.dart' as path;
import 'dart:typed_data'; // ★これを追加

enum Architecture {
  amd64, i386, aarch64, arm, ppc64, ppc
}

extension Architectures on Architecture {
  static final fullRegex = '(${[for (final arch in Architecture.values) for (final label in arch.labels) label].join('|')})';
  get regex => '(${[for (final label in labels) label].join('|')})';
  List<String> get labels => (){switch (this) {
    case Architecture.i386: return ["i386", "i686", "i586", "i486", "x86"];
    case Architecture.amd64: return ["x86_64", "amd64"];
    case Architecture.arm: return ["aarch32", "arm"];
    case Architecture.aarch64: return ["arm64", "aarch64"];
    case Architecture.ppc: return ["powerpc", "ppc"];
    case Architecture.ppc64: return ["powerpc64", "ppc64"];
  }}();
}

class XapkReader extends IsolateRunner<String, APK_READER_FLAGS> {
  static int _versionCode = 0;
  static late Future<Archive> _xapkArchive;
  static final Directory _xapkTempDir = Directory(WinPath.tempSubdir).createTempSync("XAPK-Extracted@$pid@");

  Future<Archive> _initArchiveFile(File file) async => ZipDecoder().decodeBuffer(InputFileStream(file.path));
  void _initArchive() {
    //Maintain a lock on the file
    File file = File(data)..open();
    _xapkArchive = _initArchiveFile(file);
  }

  static ManifestXapk _decodeManifest(List<int> bytes) => ManifestXapk.create()
    ..mergeFromProto3Json(utf8.decoder.fuse(json.decoder).convert(bytes));

  static Future<List<ProcessResult>> copyApkResources(List<ManifestXapk_ApkExpansion> expansions, String workingDir, String ipAddress, int port) => Future.wait(() sync* {
    int index = 0;
    for (ManifestXapk_ApkExpansion exp in expansions) {
      if (exp.installPath.isEmpty) exp.installPath = exp.file;
      final tempName = '${path.basename(workingDir)}@${index++}';
      final resourceName = path.basename(exp.installPath);
      final resourceDir = '${exp.installPath.startsWith('/') ? '' : '/sdcard/'}${path.dirname(exp.installPath)}';
      yield ADBUtils.pushToAddress(ipAddress, port, exp.file, '/sdcard/$tempName', workDir: workingDir)
          .timeout(const Duration(seconds: 30)).then((_) =>
          ADBUtils.shellToAddress(ipAddress, port, 'mkdir -p "$resourceDir"; cd "$resourceDir"; mv /sdcard/$tempName ./$resourceName')
              .timeout(const Duration(seconds: 30)));
    }
  }());

static void installXApk(String workingDir /* tempDir */, List<String> apkFiles, List<ManifestXapk_ApkExpansion> expansions, String ipAddress, int port, AppLocalizations lang, int timeout, FileDisposeQueue disposeLock, [bool downgrade = false]) async {
    if (apkFiles.isNotEmpty) log("INSTALLING \"${apkFiles.first}\" on on $ipAddress:$port...");
    disposeLock.clear();
    
    // UIを「インストール中」に変えて操作をブロックする
    GState.apkInstallState.update((_) => InstallState.INSTALLING);

    // ★追加：WSAのパッケージマネージャー（pm）が応答するまで待機する
    bool isBootCompleted = false;
    for (int i = 0; i < 60; i++) { // 最大120秒間（2秒 × 60回）待機
      var pmResult = await ADBUtils.shellToAddress(ipAddress, port, "pm path android")
          .processTimeout(const Duration(seconds: 3))
          .defaultError();
      
      if (!pmResult.isTimeout && pmResult.exitCode == 0 && pmResult.stdout.toString().contains('package:')) {
        isBootCompleted = true;
        break; 
      }
      await Future.delayed(const Duration(seconds: 2));
    }

    if (!isBootCompleted) {
      GState.apkInstallState.update((_) => InstallState.ERROR);
      GState.errorCode.update((_) => "WSA_BOOT_TIMEOUT");
      GState.errorDesc.update((_) => "WSAの起動完了を2分間待ちましたが、応答がありません。WSAを再起動してください。");
      return;
    }

    // 完全に起動したのを確認してから、本来のインストール（複数APK一括転送）コマンドを発行
    var installation = ADBUtils.installMultipleToAddress(ipAddress, port, apkFiles, downgrade: downgrade, workDir: workingDir);
    
    // ★追加：タイムアウトをたっぷり5分(300秒)に延長！
    installation = installation.processTimeout(const Duration(seconds: 300));
    installation = installation.defaultError();

    final resources = copyApkResources(expansions, workingDir, ipAddress, port);

    final result = await installation;
    await resources;

    if (!result.isTimeout) Directory(workingDir).deleteSync(recursive: true);
    log("EXIT CODE: ${result.exitCode}");
    String error = result.stderr.toString();
    log("OUTPUT: ${result.stdout}");
    log("ERROR: $error");
    
    if (result.exitCode == 0) {
      GState.apkInstallState.update((_) => InstallState.SUCCESS);
    } else if (result.isTimeout) {
      GState.apkInstallState.update((_) => InstallState.TIMEOUT);
      GState.errorCode.update((_) => "TIMEOUT");
      GState.errorDesc.update((_) => '${lang.installer_error_timeout}\n\n${lang.installer_warning_dirty(workingDir)}');
    } else {
      GState.apkInstallState.update((_) => InstallState.ERROR);
      RegExpMatch? errorMatch = RegExp(r'(^|\n)\s*adb:\s+failed\s+to\s+install\s+.*:\s+Failure\s+\[([^:]*):\s*([^\s].*[^\s])\s*\]').firstMatch(error);
      
      if (errorMatch != null) {
        String errorCode = errorMatch.group(2) ?? "";
        GState.errorCode.update((_) => errorCode.isNotEmpty ? errorCode : "UNKNOWN_ERROR");
        String errorDesc = errorMatch.group(3) ?? "";
        GState.errorDesc.update((_) => errorDesc.isNotEmpty ? errorDesc : lang.installer_error_nomsg);
      } else {
        GState.errorCode.update((_) => "INSTALL_ERROR (Exit: ${result.exitCode})");
        GState.errorDesc.update((_) => error.trim().isNotEmpty ? error.trim() : "エラーの詳細が取得できませんでした。");
      }
    }
  }

  static List<String> _getApkList(ManifestXapk manifest) {
    final archRegex = RegExp('^config\\.${Architectures.fullRegex}.*');
    final String defaultBaseName = '${manifest.packageName}.apk';
    Iterable<String> apkList;
    if (manifest.splitApks.isNotEmpty) {
      bool isBaseApk(ManifestXapk_ApkFile fileInfo) => fileInfo.id == 'base' || fileInfo.file == defaultBaseName;
      ManifestXapk_ApkFile? baseApk = manifest.splitApks.firstWhereOrNull(isBaseApk);
      if (manifest.splitApks.first == baseApk || baseApk == null) apkList = manifest.splitApks.map((e) => e.file);
      else apkList = [baseApk.file].followedBy(manifest.splitApks.whereNot(isBaseApk).map((e) => e.file));
    }
    else if (manifest.splitConfigs.isNotEmpty) {
      Iterable<String> configFiles = manifest.splitConfigs.map((e) => '$e.apk');
      apkList = manifest.splitConfigs.contains(manifest.packageName) ? configFiles : [defaultBaseName].followedBy(configFiles);
    }
    else apkList = [defaultBaseName];

    final List<String> archApkList = apkList.where((file) => archRegex.hasMatch(file)).toList();
    if (archApkList.isEmpty || archApkList.length == 1) return apkList.toList();
    apkList = apkList.whereNot((file) => archRegex.hasMatch(file));
    for (final arch in Architecture.values) {
      final regex = RegExp('^config\\.${arch.regex}.*');
      for (final file in archApkList) if (regex.hasMatch(file)) return apkList.followedBy([file]).toList();
    }
    return apkList.followedBy([apkList.first]).toList();
  }
  
  void updateManifest(ManifestXapk manifest, Set<AndroidPermission> permissions) {
    executeInUi(() {
      _versionCode = manifest.versionCode;
      GState.apkTitle.$ = manifest.name;
      GState.version.$ = manifest.versionName;
      GState.package.$ = manifest.packageName;
      GState.permissions.$ = permissions;
    });
  }

  void updateIcon(Image? image) {
    executeInUi(() async {
      if (image != null) {
        GState.apkAdaptiveNoScale.$ = true;
        GState.apkBackgroundIcon.$ = image;
        GState.apkForegroundIcon.$ = const SizedBox();
      }
      else ApkReader.setDefaultIcon(await GState.legacyIcons.whenReady());
    });
  }

  void updateInstallInfo(ManifestXapk manifest, String installDir, List<String> apkList, FileDisposeQueue disposeLock) {
    executeInUi(() {
      if (manifest.packageName.isNotEmpty) ApkReader.loadInstallType(manifest.packageName, manifest.versionCode);
      GState.installCallback.$ = (ipAddress, port, lang, timeout, [downgrade = false]) => installXApk(installDir, apkList, manifest.expansions, ipAddress, port, lang, timeout, disposeLock, downgrade);
      GState.apkInstallType.$ = InstallType.INSTALL;
    });
  }

@override
  void run() async { try {
    _initArchive();
    final archive = (await _xapkArchive);
    log("LOADING MANIFEST");
    final manifestFile = archive.findFile('manifest.json');
    
    // ▼▼ .apks / .apkm 用の最強フォールバック処理 ▼▼
    // ▼▼ .apks / .apkm 用の最強フォールバック処理 ▼▼
    if (manifestFile == null) {
      log("MANIFEST NOT FOUND. FALLBACK TO RAW APK EXTRACTION.");
      final apkFiles = archive.files.where((f) => f.name.toLowerCase().endsWith('.apk')).toList();
      if (apkFiles.isEmpty) throw Exception("No APK files found in archive");

      final baseApk = apkFiles.firstWhereOrNull((f) => f.name.toLowerCase() == 'base.apk') 
          ?? apkFiles.reduce((a, b) => a.size > b.size ? a : b);
      
      baseApk.extractSync(_xapkTempDir, replaceExisting: true);
      final extractedBaseApkPath = path.join(_xapkTempDir.path, baseApk.name);

      String parsedPackage = "";
      String parsedTitle = path.basename(data);
      String parsedVersion = "Split APK Bundle";
      int parsedVersionCode = 0; // ★ 追加：システム用バージョンコード
      Image? parsedIcon;
      Set<AndroidPermission> parsedPermissions = {AndroidPermission.NONE};

      try {
        final result = Process.runSync('${Env.TOOLS_DIR}\\aapt.exe', ['dump', 'badging', extractedBaseApkPath]);
        if (result.exitCode == 0) {
          final out = result.stdout.toString();
          parsedPackage = RegExp(r"package:\s*name='([^']+)'").firstMatch(out)?.group(1) ?? "";
          // ★ versionCodeをaaptから取得！
          parsedVersionCode = int.tryParse(RegExp(r"versionCode='([^']+)'").firstMatch(out)?.group(1) ?? "0") ?? 0;
          parsedVersion = RegExp(r"versionName='([^']+)'").firstMatch(out)?.group(1) ?? "1.0";
          
          final appMatch = RegExp(r"application:.*?label='([^']+)'.*?icon='([^']+)'").firstMatch(out);
          String? iconPath;
          if (appMatch != null) {
            parsedTitle = appMatch.group(1) ?? parsedTitle;
            iconPath = appMatch.group(2);
          } else {
            parsedTitle = RegExp(r"application-label:'([^']+)'").firstMatch(out)?.group(1) ?? parsedTitle;
            iconPath = RegExp(r"icon='([^']+)'").firstMatch(out)?.group(1);
          }
          
          // ★ アイコン取得の超強化！
          var iconFile = archive.findFile('icon.png'); // apkm直下に親切に置いてある場合はそれを使う
          if (iconFile == null && iconPath != null) {
             if (iconPath.endsWith('.png') || iconPath.endsWith('.webp')) {
                 iconFile = archive.findFile(iconPath);
             } else if (iconPath.endsWith('.xml')) {
                 // xml(Adaptive Icon)の場合は描画できないので、ZIP内から同じ名前のpngを探し出す！
                 final baseName = path.basenameWithoutExtension(iconPath);
                 iconFile = archive.files.firstWhereOrNull((f) => f.name.contains(baseName) && f.name.endsWith('.png'));
             }
          }
          if (iconFile != null) {
              // ★ Uint8List.fromList(...) で包んで型を変換する！
              parsedIcon = Image.memory(Uint8List.fromList(iconFile.content as List<int>));
          }
          
          final permMatches = RegExp(r"uses-permission:\s*name='([^']+)'").allMatches(out);
          final permNames = permMatches.map((m) => m.group(1)!).toList();
          if (permNames.isNotEmpty) {
             parsedPermissions = AndroidPermissionList.fromNames(permNames);
          }
        }
      } catch (e) {
        log("aapt badging error: $e");
      }

      // info.jsonがあれば補完する
      final infoJsonFile = archive.findFile('info.json');
      if (infoJsonFile != null) {
        try {
          final info = jsonDecode(utf8.decode(infoJsonFile.content as List<int>));
          if (info['pname'] != null) parsedPackage = info['pname'];
          if (info['version'] != null) parsedVersion = info['version'];
          if (info['versionCode'] != null) parsedVersionCode = int.parse(info['versionCode'].toString()); // ★ info.jsonからも取得
          if (info['label'] != null) parsedTitle = info['label'];
        } catch (_) {}
      }

      executeInUi(() {
        _versionCode = parsedVersionCode; // ★ 0ではなく本物のVersionCodeをセット！
        GState.apkTitle.$ = parsedTitle;
        GState.version.$ = parsedVersion;
        GState.package.$ = parsedPackage;
        GState.permissions.$ = parsedPermissions;
      });
      
      if (parsedIcon != null) {
        updateIcon(parsedIcon);
      } else {
        ApkReader.setDefaultIcon(await waitFlag(APK_READER_FLAGS.LEGACY_ICON));
      }

      final apkList = apkFiles.map((f) => f.name).toList();
      String installDir = _xapkTempDir.absolute.path;
      final disposeLock = FileDisposeQueue();
      
      await waitFlag(APK_READER_FLAGS.UI_LOADED);
      archive.extractAllSync(_xapkTempDir, disposeLock: disposeLock);
      
      executeInUi(() {
        if (parsedPackage.isNotEmpty) ApkReader.loadInstallType(parsedPackage, parsedVersionCode); // ★ ここも修正
        GState.installCallback.$ = (ipAddress, port, lang, timeout, [downgrade = false]) => 
            installXApk(installDir, apkList, [], ipAddress, port, lang, timeout, disposeLock, downgrade);
        GState.apkInstallType.$ = InstallType.INSTALL;
      });

      log("DIRECTORY: ${_xapkTempDir.path}");
      return;
    }
    // ▲▲ ここまで ▲▲

    log("READING MANIFEST");
    final manifest = _decodeManifest(manifestFile.content as List<int>);
    final permissions = AndroidPermissionList.fromNames(manifest.permissions);
    updateManifest(manifest, permissions);
    String iconFile = manifest.icon.isNotEmpty ? manifest.icon : "icon.png";
    final icon = archive.findFile(iconFile);
    final image = icon != null ? Image.memory(icon.content) : null;
    updateIcon(image);

    final apkList = _getApkList(manifest);
    String installDir = _xapkTempDir.absolute.path;
    final disposeLock = FileDisposeQueue();
    
    await waitFlag(APK_READER_FLAGS.UI_LOADED);
    archive.extractAllSync(_xapkTempDir, disposeLock: disposeLock);
    updateInstallInfo(manifest, installDir, apkList, disposeLock);

    log("DIRECTORY: ${_xapkTempDir.path}");
  } catch (e) {
    _xapkTempDir.deleteSync(recursive: true);
    //(await _xapkArchive).clear();
  }}


  @override
  FutureOr<void> postStartCallback(IsolateRef<String, APK_READER_FLAGS> isolate) {
    late StreamSubscription sub; sub = GState.connectionStatus.stream.listen((event) async {
      String package = GState.package.$;
      InstallType? installType = GState.apkInstallType.$;
      if (GState.apkInstallType.$ == InstallType.UNKNOWN) {
        await ApkReader.loadInstallType(GState.package.$, _versionCode);
        if (GState.apkInstallType.$ != InstallType.UNKNOWN) sub.cancel();
      }
      else if (installType != null) sub.cancel();
    });
  }
}