import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_local_auth/data/repositories/auth_repository/provider.dart';
import 'package:sample_local_auth/data/repositories/local_auth_repository/provider.dart';
import 'package:sample_local_auth/data/repositories/lock_settings_repository/provider.dart';
import 'package:sample_local_auth/domains/local_auth_status.dart';
import 'package:sample_local_auth/domains/lock_type.dart';

part 'view_model.g.dart';

@Riverpod(keepAlive: true)
class SettingsViewModel extends _$SettingsViewModel {
  @override
  void build() {}

  /// ログアウト開始
  Future<void> startLogout() async {
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    final auth = ref.read(authRepositoryProvider);
    await auth.setIsLoggedIn(value: false);
  }

  /// ロックを切り替える
  Future<void> toggleLock(bool value) async {
    final lockSettings = ref.read(lockSettingsRepositoryProvider);
    await lockSettings.setIsLocked(value);
  }

  /// ロックの種類を設定する
  Future<LocalAuthStatus> setLockType(LockType type) async {
    final localAuth = ref.read(localAuthRepositoryProvider);
    final status = await localAuth.status;
    if (type == LockType.biometric && status != LocalAuthStatus.available) {
      return status;
    }

    await ref.read(lockSettingsRepositoryProvider).setLockType(type);
    return status;
  }
}
