// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$lockSettingsRepositoryHash() =>
    r'8ef0d6854fff748b3a86f08118e98fbb23bed04d';

/// See also [lockSettingsRepository].
@ProviderFor(lockSettingsRepository)
final lockSettingsRepositoryProvider =
    Provider<LockSettingsRepositoryBase>.internal(
  lockSettingsRepository,
  name: r'lockSettingsRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lockSettingsRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LockSettingsRepositoryRef = ProviderRef<LockSettingsRepositoryBase>;
String _$isLockedHash() => r'8d6798d48ae1a7c3c9e23e1db34eae882122aa23';

/// See also [isLocked].
@ProviderFor(isLocked)
final isLockedProvider = AutoDisposeStreamProvider<bool>.internal(
  isLocked,
  name: r'isLockedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isLockedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef IsLockedRef = AutoDisposeStreamProviderRef<bool>;
String _$lockTypeHash() => r'1be4f6dc0f87ca9bcf0a7f0bce50cdcb08d446ef';

/// See also [lockType].
@ProviderFor(lockType)
final lockTypeProvider = AutoDisposeStreamProvider<UnlockType>.internal(
  lockType,
  name: r'lockTypeProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$lockTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LockTypeRef = AutoDisposeStreamProviderRef<UnlockType>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
