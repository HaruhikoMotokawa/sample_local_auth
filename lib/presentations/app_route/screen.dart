import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_local_auth/applications/app_lock_service/provider.dart';
import 'package:sample_local_auth/data/repositories/lock_settings_repository/provider.dart';

class AppRouteScreen extends HookConsumerWidget {
  const AppRouteScreen({required this.child, super.key});

  final Widget child;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLockService = ref.watch(appLockServiceProvider);

    final isLocked = ref.watch(isLockedProvider).maybeWhen(
          orElse: () => false,
          data: (value) => value,
        );

    // ロック機能を有効にしていた場合
    if (isLocked) {
      useOnAppLifecycleStateChange((_, AppLifecycleState currentState) {
        switch (currentState) {
          // アプリがバックグラウンドに移動した場合、ロックをかける
          case AppLifecycleState.inactive:
            appLockService.lock();
          // アプリが一時停止（デバイスがスリープ）した場合、ロックをかける
          case AppLifecycleState.paused:
            appLockService.lock();
          // それ以外は何もしない
          case _:
            return;
        }
      });
    }
    return Scaffold(
      body: child,
    );
  }
}
