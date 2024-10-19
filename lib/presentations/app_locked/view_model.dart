import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_local_auth/applications/app_lock_service/provider.dart';

part 'view_model.g.dart';

@Riverpod(keepAlive: true)
class AppLockedViewModel extends _$AppLockedViewModel {
  @override
  void build() {}

  /// ボタンタップでロックを解除する
  void unlock() => ref.read(appLockServiceProvider).unlock();
}
