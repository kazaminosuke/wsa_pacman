// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
// 以下を追加
import 'package:wsa_pacman/global_state.dart';
import 'package:wsa_pacman/android/android_utils.dart';
import 'package:synchronized/synchronized.dart';

class _IsolateMessage<E extends Enum> {
  final E flag;
  final bool value;
  _IsolateMessage(this.flag, this.value);
}

class _IsolateData<O, FLAGS extends Enum> {
  O? data;
  final SendPort _isolateToUiPort; // Completerを消して、安全なSendPortだけにする
  
  _IsolateData(this.data, this._isolateToUiPort);

  //Listener has to execute this in the main thread
  void _executeInUi(VoidCallback callback) {
    _isolateToUiPort.send(callback);
  }
}

class IsolateRef<O, FLAGS extends Enum> {
  final _IsolateData<O, FLAGS> _data;
  final Completer<SendPort> _uiToIsolatePortCompleter; // ここにCompleterを引っ越し
  SendPort? _uiToIsolatePort;

  IsolateRef._(this._data, this._uiToIsolatePortCompleter);

  void sendFlag(FLAGS flag, bool value) async {
    (_uiToIsolatePort ?? (_uiToIsolatePort = await _uiToIsolatePortCompleter.future)).send(_IsolateMessage(flag, value));
  }
}

/// Simplifies running an isolate
/// Allows running a callback in the UI thread
/// Allows waiting for a signal from the UI thread
/// Most fields are static not to be caught up in the executeInUi method
abstract class IsolateRunner<O, FLAGS extends Enum> {
  static final _flags = <Enum, Completer<bool>>{};
  static final _flagsLock = Lock();
  static late final dynamic _data;
  static late final _IsolateData _pData;

  /// Data passed to the start method
  @nonVirtual O get data => _data;
  /// Main runner, must be overridden
  @visibleForOverriding FutureOr<void> run();
  /// Executed in the UI thread after starting the isolate
  FutureOr<void> postStartCallback(IsolateRef<O, FLAGS> isolate) {}
  /// Waits for a flag from the UI thread, may stay locked indefinitely
  @nonVirtual Future<bool> waitFlag(FLAGS flag) async => await (await _flagsLock.synchronized(()=>_flags.putIfAbsent(flag, ()=>Completer()))).future;
  /// Executes a callback in the UI thread
  /// Will load all local variables in the current scope if one is referenced, therefore use carefully
  @nonVirtual void executeInUi(VoidCallback callback) => _pData._executeInUi(callback);

  void _runInitIsolate(_IsolateData<O, FLAGS> pData) async {
    (_pData = pData)._isolateToUiPort.send((ReceivePort()..listen((message) {
      if (message is _IsolateMessage<FLAGS>) _flagsLock.synchronized(() {
        _flags.putIfAbsent(message.flag, ()=>Completer()).complete(message.value);
      });
    })).sendPort);
    _data = pData.data;
    // Should prevent this data from beins sent when launching executeInUi
    pData.data = null;
    await run();
  }

  @nonVirtual
  IsolateRef<O, FLAGS> start(O data) => IsolateRunner._start(this, data);

static IsolateRef<O, FLAGS> _start<O, FLAGS extends Enum>(IsolateRunner<O, FLAGS> runner, O data) {
    final receivePort = ReceivePort();
    final portCompleter = Completer<SendPort>();

    // UI側でメッセージを受け取る処理
    receivePort.listen((message) {
      if (message is VoidCallback) {
        message();
      } else if (message is SendPort) {
        if (!portCompleter.isCompleted) portCompleter.complete(message);
      }
    });

    // Isolateに送るための、Completerを含まない安全なデータ
    final minimalData = _IsolateData<O, FLAGS>(data, receivePort.sendPort);
    final isolateRef = IsolateRef._(minimalData, portCompleter);

    compute(runner._runInitIsolate, minimalData).catchError((e, stack) {
      print("🚨🚨🚨 COMPUTE FATAL ERROR: $e");
      print("🚨🚨🚨 STACK TRACE:\n$stack");
      
      // 画面側にもエラーを表示させる
      GState.apkTitle.$ = "Isolate 起動失敗";
      GState.apkInstallState.$ = InstallState.ERROR;
      GState.errorCode.$ = "COMPUTE_ERR";
      GState.errorDesc.$ = "Isolateの起動時にクラッシュしました:\n$e";
      GState.apkInstallType.$ = InstallType.INSTALL;
    });
    
    runner.postStartCallback(isolateRef);
    return isolateRef;
  }
}