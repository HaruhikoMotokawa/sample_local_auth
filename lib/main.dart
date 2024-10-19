import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sample_local_auth/presentations/app.dart';
import 'package:sample_local_auth/presentations/app_start_up/screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: AppStartupScreen(onLoaded: (context) => const App()),
    ),
  );
}
