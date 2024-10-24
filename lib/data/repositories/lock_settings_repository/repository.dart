import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_local_auth/data/sources/shared_preference.dart';
import 'package:sample_local_auth/domains/unlock_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LockSettingsRepositoryBase {
  /// ロックの状態を監視する
  Stream<bool> watchIsLocked();

  /// ロックの種類を監視する
  Stream<UnlockType> watchLockType();

  /// ロックの状態を保存する
  Future<void> setIsLocked(bool isLocked);

  /// ロックの状態を取得する
  Future<bool> getIsLocked();

  /// ロックの種類を保存する
  Future<void> setLockType(UnlockType type);

  /// ロックの種類を取得する
  Future<UnlockType> getLockType();
}

class LockSettingsRepository implements LockSettingsRepositoryBase {
  LockSettingsRepository(this.ref);

  final Ref ref;

  /// ロックの状態のキー
  static const isLockedKey = 'isLocked';

  /// ロックの種類のキー
  static const lockTypeKey = 'lockType';

  Future<SharedPreferences> get _sharedPreferences =>
      ref.read(sharedPreferencesProvider.future);

  final _lockStateController = StreamController<bool>.broadcast();

  final _lockTypeController = StreamController<UnlockType>.broadcast();

  @override
  Stream<bool> watchIsLocked() async* {
    yield await getIsLocked();

    yield* _lockStateController.stream;
  }

  @override
  Stream<UnlockType> watchLockType() async* {
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
  Future<UnlockType> getLockType() async {
    final pref = await _sharedPreferences;
    final typeIndex = pref.getInt(lockTypeKey);
    if (typeIndex != null) return UnlockType.values[typeIndex];

    await setLockType(UnlockType.button);
    return UnlockType.button;
  }

  @override
  Future<void> setLockType(UnlockType type) async {
    final pref = await _sharedPreferences;
    await pref.setInt(lockTypeKey, type.index);
    _lockTypeController.add(type);
  }
}
