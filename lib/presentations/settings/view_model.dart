import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_local_auth/data/repositories/auth_repository/provider.dart';

part 'view_model.g.dart';

@Riverpod(keepAlive: true)
class SettingsViewModel extends _$SettingsViewModel {
  @override
  void build() {}

  /// ログアウト開始
  Future<void> startLogout() async {
    // ignore: avoid_manual_providers_as_generated_provider_dependency
    final auth = ref.read(authRepositoryProvider);
    await auth.setIsLoggedIn(value: false);
  }
}
