import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_local_auth/data/repositories/lock_settings_repository/repository.dart';
import 'package:sample_local_auth/domains/unlock_type.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
LockSettingsRepositoryBase lockSettingsRepository(Ref ref) {
  return LockSettingsRepository(ref);
}

@riverpod
Stream<bool> isLocked(Ref ref) =>
    ref.read(lockSettingsRepositoryProvider).watchIsLocked();

@riverpod
Stream<UnlockType> lockType(Ref ref) =>
    ref.read(lockSettingsRepositoryProvider).watchLockType();
