import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_local_auth/applications/app_lock_service/provider.dart';
import 'package:sample_local_auth/applications/app_lock_service/service.dart';

part 'view_model.g.dart';

@Riverpod(keepAlive: true)
class AppLockedViewModel extends _$AppLockedViewModel {
  @override
  void build() {}

  AppLockServiceBase get _appLockService => ref.read(appLockServiceProvider);

  /// ボタンタップでロックを解除する
  void unlock() => _appLockService.unlock();

  /// 生体認証でロックを解除する
  void unlockWithBiometrics() => _appLockService.unlockWithBiometrics();
}
