import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_local_auth/data/repositories/auth_repository/provider.dart';

part 'view_model.g.dart';

@Riverpod(keepAlive: true)
class InitialViewModel extends _$InitialViewModel {
  @override
  void build() {}

  /// ログイン開始
  Future<void> startLogin() async {
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    final auth = ref.read(authRepositoryProvider);
    await auth.setIsLoggedIn(value: true);
  }
}
