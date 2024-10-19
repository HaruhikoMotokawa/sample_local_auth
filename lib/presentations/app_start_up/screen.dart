import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sample_local_auth/presentations/app_start_up/provider.dart';

/// 初期化を待つためのウィジェット
class AppStartupScreen extends ConsumerWidget {
  const AppStartupScreen({required this.onLoaded, super.key});

  static const _prefix = 'AppStartupScreen';
  static const errorWidgetKey = ValueKey('$_prefix.errorWidget');
  static const loadWidgetKey = ValueKey('$_prefix.loadWidget');
  static const retryButtonKey = ValueKey('$_prefix.retryButton');

  final WidgetBuilder onLoaded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);
    return switch (appStartupState) {
      AsyncData() => onLoaded(context),
      AsyncError(:final error) => _AppStartUpError(
          errorWidgetKey: errorWidgetKey,
          retryButtonKey: retryButtonKey,
          error: error,
        ),
      _ => const _AppStartUpLoading(loadWidgetKey: loadWidgetKey),
    };
  }
}

class _AppStartUpLoading extends StatelessWidget {
  const _AppStartUpLoading({required this.loadWidgetKey});

  final ValueKey<String> loadWidgetKey;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      key: loadWidgetKey,
      home: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class _AppStartUpError extends ConsumerWidget {
  const _AppStartUpError({
    required this.errorWidgetKey,
    required this.retryButtonKey,
    required this.error,
  });

  final ValueKey<String> errorWidgetKey;
  final ValueKey<String> retryButtonKey;
  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      key: errorWidgetKey,
      home: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error.toString()),
            const SizedBox(height: 16),
            ElevatedButton(
              key: retryButtonKey,
              onPressed: () {
                ref.invalidate(appStartupProvider);
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
