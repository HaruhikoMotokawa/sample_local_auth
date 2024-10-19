import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_local_auth/presentations/initial/view_model.dart';

class InitialScreen extends ConsumerWidget {
  const InitialScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(initialViewModelProvider.notifier);
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: viewModel.startLogin,
          child: const Text('login'),
        ),
      ),
    );
  }
}
