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
String _$lockStateHash() => r'b482dbb012a5df1dd64c8d99c5091168efdc3d37';

/// See also [lockState].
@ProviderFor(lockState)
final lockStateProvider = AutoDisposeStreamProvider<bool>.internal(
  lockState,
  name: r'lockStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$lockStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef LockStateRef = AutoDisposeStreamProviderRef<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
