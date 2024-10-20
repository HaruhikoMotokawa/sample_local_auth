import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_local_auth/data/sources/shared_preference.dart';
import 'package:sample_local_auth/domains/lock_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LockSettingsRepositoryBase {
  /// ロックの状態を監視する
  Stream<bool> watchIsLocked();

  /// ロックの種類を監視する
  Stream<LockType> watchLockType();

  /// ロックの状態を保存する
  Future<void> setIsLocked(bool isLocked);

  /// ロックの状態を取得する
  Future<bool> getIsLocked();

  /// ロックの種類を保存する
  Future<void> setLockType(LockType type);

  /// ロックの種類を取得する
  Future<LockType> getLockType();
}

class LockSettingsRepository implements LockSettingsRepositoryBase {
  LockSettingsRepository(this.ref);

  final ProviderRef<dynamic> ref;

  /// ロックの状態のキー
  static const isLockedKey = 'isLocked';

  /// ロックの種類のキー
  static const lockTypeKey = 'lockType';

  Future<SharedPreferences> get _sharedPreferences =>
      ref.read(sharedPreferencesProvider.future);

  final _lockStateController = StreamController<bool>.broadcast();

  final _lockTypeController = StreamController<LockType>.broadcast();

  @override
  Stream<bool> watchIsLocked() async* {
    yield await getIsLocked();

    yield* _lockStateController.stream;
  }

  @override
  Stream<LockType> watchLockType() async* {
    yield await getLockType();

    yield* _lockTypeController.stream;
  }

  @override
  Future<bool> getIsLocked() async {
    final pref = await _sharedPreferences;
    final isLocked = pref.getBool(isLockedKey);
    if (isLocked != null) return isLocked;

    await setIsLocked(false);
    return false;
  }

  @override
  Future<void> setIsLocked(bool isLocked) async {
    final pref = await _sharedPreferences;
    await pref.setBool(isLockedKey, isLocked);
    _lockStateController.add(isLocked);
  }

  @override
  Future<LockType> getLockType() async {
    final pref = await _sharedPreferences;
    final typeIndex = pref.getInt(lockTypeKey);
    if (typeIndex != null) return LockType.values[typeIndex];

    await setLockType(LockType.button);
    return LockType.button;
  }

  @override
  Future<void> setLockType(LockType type) async {
    final pref = await _sharedPreferences;
    await pref.setInt(lockTypeKey, type.index);
    _lockTypeController.add(type);
  }
}
