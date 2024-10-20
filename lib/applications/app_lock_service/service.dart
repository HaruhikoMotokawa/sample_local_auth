import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_local_auth/core/log/logger.dart';
import 'package:sample_local_auth/data/repositories/local_auth_repository/provider.dart';
import 'package:sample_local_auth/data/repositories/local_auth_repository/repository.dart';
import 'package:sample_local_auth/data/repositories/lock_settings_repository/provider.dart';

abstract interface class AppLockServiceBase {
  /// 現在のロック状態を監視する
  Stream<bool> get lockState;

  /// ロックを解除する
  void unlock();

  /// ロックをかける
  void lock();

  /// 生体認証でロックを解除する
  Future<void> unlockWithBiometrics();

  /// ロックの初期化
  Future<void> init();
}

class AppLockService implements AppLockServiceBase {
  AppLockService(this.ref);

  final ProviderRef<dynamic> ref;

  final _lockStateController = StreamController<bool>();

  LocalAuthRepositoryBase get _localAuthRepository =>
      ref.read(localAuthRepositoryProvider);

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

  @override
  Future<void> init() async {
    final lockSettingsRepository = ref.read(lockSettingsRepositoryProvider);
    final isLocked = await lockSettingsRepository.getIsLocked();
    _lockStateController.add(isLocked);
  }

  @override
  Future<void> unlockWithBiometrics() async {
    // FIXME: このメソッドを使うかは微妙で、できるなら全ての条件を確認したほうがいいかもしれない
    final isAvailable = await _localAuthRepository.isAvailable;
    if (isAvailable == false) {
      logger.i('生体認証が設定されていません。');
      return;
    }

    try {
      final result = await _localAuthRepository.authenticate();
      if (result == false) return;

      unlock();
    } catch (e) {
      logger.e('原因不明のエラー', error: e, stackTrace: StackTrace.current);
    }
  }
}
