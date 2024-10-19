import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_local_auth/data/repositories/auth_repository/repository.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
AuthRepositoryBase authRepository(AuthRepositoryRef ref) {
  return AuthRepository(ref);
}

@Riverpod(keepAlive: true)
Stream<bool> isLoggedIn(IsLoggedInRef ref) {
  final repository = ref.read(authRepositoryProvider);
  return repository.isLoggedInStream;
}
