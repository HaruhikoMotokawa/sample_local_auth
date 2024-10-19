import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_local_auth/data/sources/shared_preference.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class AuthRepositoryBase {
  /// ログイン状態の変更を配信
  Stream<bool> get isLoggedInStream;

  /// 初期化
  Future<void> init();

  /// ユーザーのログイン状態を取得
  Future<bool?> getIsLoggedIn();

  /// ユーザーのログイン状態を保存
  Future<void> setIsLoggedIn({required bool value});
}

class AuthRepository implements AuthRepositoryBase {
  AuthRepository(this.ref);

  final ProviderRef<dynamic> ref;

  /// ログイン状態のキー
  static const isLoggedInKey = 'isLoggedIn';

  Future<SharedPreferences> get _sharedPreferences =>
      ref.read(sharedPreferencesProvider.future);

  final _authStatusController = StreamController<bool>();

  @override
  Stream<bool> get isLoggedInStream => _authStatusController.stream;

  @override
  Future<void> init() async {
    final isLoggedIn = await getIsLoggedIn();
    if (isLoggedIn == null) {
      return setIsLoggedIn(value: false);
    }
    _authStatusController.add(isLoggedIn);
  }

  @override
  Future<bool?> getIsLoggedIn() async {
    final pref = await _sharedPreferences;
    final isLoggedIn = pref.getBool(isLoggedInKey);
    return isLoggedIn;
  }

  @override
  Future<void> setIsLoggedIn({required bool value}) async {
    final pref = await _sharedPreferences;
    await pref.setBool(isLoggedInKey, value);
    _authStatusController.add(value);
  }
}
