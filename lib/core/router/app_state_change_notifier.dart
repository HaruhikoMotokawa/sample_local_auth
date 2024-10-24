import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_local_auth/applications/app_lock_service/provider.dart';
import 'package:sample_local_auth/core/router/route.dart';
import 'package:sample_local_auth/data/repositories/auth_repository/provider.dart';

/// アプリケーションの状態変化に基づいてルートを管理するためのプロバイダ
final appStateChangeNotifierProvider =
    ChangeNotifierProvider<AppStateChangeNotifier>(AppStateChangeNotifier.new);

/// アプリの状態に伴うルート変更を管理する`ChangeNotifier`
///
/// `notifyListeners`が呼び出されると、`GoRouter`が`refresh`され、
/// 必要に応じてリダイレクト処理が行われます。
class AppStateChangeNotifier extends ChangeNotifier {
  AppStateChangeNotifier(this.ref) {
    // `isLoggedInProvider`の変更を監視し、変更があれば`notifyListeners`を非同期に呼び出す
    final isLoggedInSubscription = ref.listen(isLoggedInProvider, (_, __) {
      Future.microtask(notifyListeners);
    });

    // ロック状態を監視し、変更があれば`notifyListeners`を非同期に呼び出す
    final isLockedSubscription = ref.listen(lockStateProvider, (_, __) {
      Future.microtask(notifyListeners);
    });

    // このNotifierが破棄されるときに`isLoggedInSubscription`もクリーンアップされるようにする
    ref.onDispose(() {
      isLoggedInSubscription.close();
      isLockedSubscription.close();
    });
  }

  // このクラスが依存するプロバイダを操作するためのレフ
  final Ref<AppStateChangeNotifier> ref;

  /// ルート遷移時に呼び出され、リダイレクト先のパスを返す非同期メソッド
  ///
  /// ログイン状態に基づいて、適切なリダイレクトルールを適用します。
  /// - `return`: リダイレクト先のパス。リダイレクトが不要な場合は`null`を返します。
  Future<String?> redirect(BuildContext context, GoRouterState state) async {
    final isLoggedIn = await ref.read(isLoggedInProvider.future);
    final isLocked = await ref.read(lockStateProvider.future);

    final status = (isLoggedIn, isLocked);

    switch (status) {
      case (true, false):
        return _authGuard(state);
      case (false, false):
        return _noAuthGuard(state);
      case (_, true):
        return const AppLockedRoute().location;
    }
  }

  /// ログイン済みユーザー向けのリダイレクトルール
  ///
  /// ログイン済みの場合、ログイン画面にアクセスしようとするとホーム画面にリダイレクトします。
  /// - `state`: 現在のルートの状態を保持する`GoRouterState`
  /// - `return`: リダイレクト先のパス。リダイレクトが不要な場合は`null`を返します。
  Future<String?> _authGuard(
    GoRouterState state,
  ) async {
    // 初期画面にアクセスしようとした場合、ホーム画面にリダイレクト
    if (state.fullPath == const InitialRoute().location ||
        state.fullPath == const AppLockedRoute().location) {
      return const HomeRoute().location;
    }

    return null; // リダイレクトが不要な場合
  }

  /// 未ログインユーザー向けのリダイレクトルール
  ///
  /// 未ログインの場合、ログイン画面以外のアクセスを試みるとログイン画面にリダイレクトします。
  /// - `return`: リダイレクト先のパス。リダイレクトが不要な場合は`null`を返します。
  Future<String?> _noAuthGuard(
    GoRouterState state,
  ) async {
    // 初期画面以外にアクセスしようとした場合、初期画面にリダイレクト
    if (state.fullPath != const InitialRoute().location) {
      return const InitialRoute().location;
    }
    return null; // リダイレクトが不要な場合
  }
}
