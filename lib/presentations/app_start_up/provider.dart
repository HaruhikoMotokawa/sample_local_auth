import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sample_local_auth/data/repositories/auth_repository/provider.dart';
import 'package:sample_local_auth/data/sources/shared_preference.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  // アプリ起動前に初期化したい処理を書く

  // sharedPreferencesを初期化
  await ref.read(sharedPreferencesProvider.future);

  // authの初期化
  // ignore: avoid_manual_providers_as_generated_provider_dependency
  await ref.read(authRepositoryProvider).init();
}
