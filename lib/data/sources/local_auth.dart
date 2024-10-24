import 'package:local_auth/local_auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_auth.g.dart';

@Riverpod(keepAlive: true)
LocalAuthentication localAuthentication(Ref ref) {
  return LocalAuthentication();
}
