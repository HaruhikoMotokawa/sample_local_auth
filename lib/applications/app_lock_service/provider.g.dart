// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appLockServiceHash() => r'c47b92031d66000d04ce7a1a94d7b0f86f60bd61';

/// See also [appLockService].
@ProviderFor(appLockService)
final appLockServiceProvider = Provider<AppLockServiceBase>.internal(
  appLockService,
  name: r'appLockServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appLockServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef AppLockServiceRef = ProviderRef<AppLockServiceBase>;
String _$lockStateHash() => r'e0b919c5a7e0387d8eb64dd4699d2fcb206be136';

/// See also [lockState].
@ProviderFor(lockState)
final lockStateProvider = StreamProvider<bool>.internal(
  lockState,
  name: r'lockStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$lockStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LockStateRef = StreamProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
