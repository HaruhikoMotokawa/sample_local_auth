import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_local_auth/applications/app_lock_service/service.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
AppLockServiceBase appLockService(AppLockServiceRef ref) {
  return AppLockService(ref);
}

@riverpod
Stream<bool> lockState(LockStateRef ref) =>
    ref.read(appLockServiceProvider).lockState;
