import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_local_auth/data/repositories/lock_settings_repository/repository.dart';
import 'package:sample_local_auth/domains/lock_type.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
LockSettingsRepositoryBase lockSettingsRepository(
  LockSettingsRepositoryRef ref,
) {
  return LockSettingsRepository(ref);
}

@riverpod
Stream<bool> isLocked(IsLockedRef ref) =>
    ref.read(lockSettingsRepositoryProvider).watchIsLocked();

@riverpod
Stream<LockType> lockType(LockTypeRef ref) =>
    ref.read(lockSettingsRepositoryProvider).watchLockType();
