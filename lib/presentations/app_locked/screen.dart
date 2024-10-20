import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_local_auth/data/repositories/lock_settings_repository/provider.dart';
import 'package:sample_local_auth/domains/lock_type.dart';
import 'package:sample_local_auth/presentations/app_locked/view_model.dart';
import 'package:utility_widgets/utility_widgets.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 100),
            const Gap(40),
            switch (lockType) {
              LockType.button => ElevatedButton(
                  onPressed: viewModel.unlock,
                  child: const Text('ボタンタップで解除する'),
                ),
              LockType.biometric => ElevatedButton(
                  onPressed: () async {
                    // FIXME: このメソッドを使うかは微妙で、できるなら全ての条件を確認したほうがいいかもしれない
                    final result = await viewModel.checkBiometrics();
                    if (result == false && context.mounted) {
                      return PlatformDialog.show<void>(
                        title: const Text('生体認証の設定がされていません'),
                        content: const Text('設定画面で生体認証を設定してください'),
                        context: context,
                        actionsBuilder: (context) => [
                          const AdaptiveAction(text: Text('閉じる')),
                        ],
                      );
                    }
                    await viewModel.unlockWithBiometrics();
                  },
                  child: const Text('生体認証で解除する'),
                ),
            },
          ],
        ),
      ),
    );
  }
}
