import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_local_auth/data/repositories/lock_settings_repository/provider.dart';
import 'package:sample_local_auth/domains/lock_type.dart';
import 'package:sample_local_auth/presentations/app_locked/view_model.dart';

class AppLockedScreen extends ConsumerWidget {
  const AppLockedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(appLockedViewModelProvider.notifier);

    final lockType = ref.watch(lockTypeProvider).maybeWhen(
          orElse: () => LockType.button,
          data: (value) => value,
        );

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            const Icon(Icons.lock, size: 100),
            const Gap(40),
            switch (lockType) {
              LockType.button => ElevatedButton(
                  onPressed: viewModel.unlock,
                  child: const Text('ボタンタップで解除する'),
                ),
              LockType.biometric => ElevatedButton(
                  child: const Text('生体認証で解除する'),
                  onPressed: () {},
                ),
            },
          ],
        ),
      ),
    );
  }
}
