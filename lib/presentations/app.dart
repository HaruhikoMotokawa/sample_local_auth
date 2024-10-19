import 'package:flutter/material.dart';
import 'package:sample_local_auth/presentations/initial_screen/initial_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: InitialScreen(),
    );
  }
}
