import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_local_auth/applications/app_lock_service/provider.dart';
import 'package:sample_local_auth/applications/app_lock_service/service.dart';
import 'package:sample_local_auth/data/repositories/local_auth_repository/provider.dart';

part 'view_model.g.dart';

@Riverpod(keepAlive: true)
class AppLockedViewModel extends _$AppLockedViewModel {
  @override
  void build() {}

  AppLockServiceBase get _appLockService => ref.read(appLockServiceProvider);

  /// ボタンタップでロックを解除する
  void unlock() => _appLockService.unlock();

  // FIXME: このメソッドを使うかは微妙で、できるなら全ての条件を確認したほうがいいかもしれない
  /// 生体認証できるかどうかを返す
  Future<bool> checkBiometrics() async =>
      ref.read(localAuthRepositoryProvider).isAvailable;

  /// 生体認証でロックを解除する
  Future<void> unlockWithBiometrics() async =>
      _appLockService.unlockWithBiometrics();
}
