import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_local_auth/data/repositories/local_auth_repository/repository.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
LocalAuthRepositoryBase localAuthRepository(Ref ref) {
  return LocalAuthRepository(ref);
}
