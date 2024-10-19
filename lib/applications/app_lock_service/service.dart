import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

abstract interface class AppLockServiceBase {
  /// 現在のロック状態を監視する
  Stream<bool> get lockState;

  /// ロックを解除する
  void unlock();

  /// ロックをかける
  void lock();
}

class AppLockService implements AppLockServiceBase {
  AppLockService(this.ref);

  final ProviderRef<dynamic> ref;

  final _lockStateController = StreamController<bool>();

  @override
  Stream<bool> get lockState => _lockStateController.stream;

  @override
  void lock() {
    _lockStateController.add(true);
  }

  @override
  void unlock() {
    _lockStateController.add(false);
  }
}
