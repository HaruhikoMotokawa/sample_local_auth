import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'provider.g.dart';

@Riverpod(keepAlive: true)
Future<void> appStartup(AppStartupRef ref) async {
  // アプリ起動前に初期化したい処理を書く

  // sharedPreferencesを初期化
  // await ref.read(sharedPreferencesProvider.future);
}
