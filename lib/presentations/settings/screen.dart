import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_local_auth/data/repositories/lock_settings_repository/provider.dart';
import 'package:sample_local_auth/domains/local_auth_status.dart';
import 'package:sample_local_auth/domains/lock_type.dart';
import 'package:sample_local_auth/presentations/_shared/loading_overlay.dart';
import 'package:sample_local_auth/presentations/settings/view_model.dart';
import 'package:utility_widgets/utility_widgets.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(settingsViewModelProvider.notifier);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ロックを設定するスイッチ
            Consumer(
              builder: (context, ref, child) {
                final isLocked = ref.watch(isLockedProvider).maybeWhen(
                      orElse: () => false,
                      data: (value) => value,
                    );

                return SwitchListTile(
                  title: const Text('ロックを設定する'),
                  value: isLocked,
                  onChanged: (value) async {
                    await viewModel.toggleLock(value);
                  },
                );
              },
            ),

            Consumer(
              builder: (context, ref, child) {
                final lockType = ref.watch(lockTypeProvider).maybeWhen(
                      orElse: () => LockType.button,
                      data: (value) => value,
                    );
                return Column(
                  children: [
                    RadioListTile(
                      title: const Text('ボタンタップで解除する'),
                      value: LockType.button,
                      groupValue: lockType,
                      onChanged: (value) async {
                        await viewModel.setLockType(LockType.button);
                      },
                      // ラジオボタンを右側に配置する
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                    RadioListTile(
                      title: const Text('生体認証で解除する'),
                      value: LockType.biometric,
                      groupValue: lockType,
                      onChanged: (value) async {
                        final status =
                            await viewModel.setLockType(LockType.biometric);
                        if (status != LocalAuthStatus.available &&
                            context.mounted) {
                          await PlatformDialog.show<void>(
                            title: const Text('設定エラー'),
                            content: Text(status.message),
                            context: context,
                            actionsBuilder: (context) => [
                              const AdaptiveAction(text: Text('閉じる')),
                            ],
                          );
                        }
                      },
                      // ラジオボタンを右側に配置する
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  ],
                );
              },
            ),

            const Gap(40),
            ElevatedButton(
              onPressed: () async {
                // ローディングオーバーレイを表示
                LoadingOverlay.show(context);

                // 3秒待つ
                await Future<void>.delayed(const Duration(seconds: 2));

                // ローディングオーバーレイを非表示
                LoadingOverlay.hide();

                // ログアウト処理を実行
                await viewModel.startLogout();
              },
              child: const Text('ログアウト'),
            ),
          ],
        ),
      ),
    );
  }
}
