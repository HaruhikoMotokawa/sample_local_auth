import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_local_auth/presentations/_shared/loading_overlay.dart';
import 'package:sample_local_auth/presentations/settings/view_model.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(settingsViewModelProvider.notifier);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
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
      ),
    );
  }
}
