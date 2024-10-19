import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_local_auth/core/router/app_navigation_bar.dart';
import 'package:sample_local_auth/presentations/app_locked/screen.dart';
import 'package:sample_local_auth/presentations/app_route/screen.dart';
import 'package:sample_local_auth/presentations/home/screen.dart';
import 'package:sample_local_auth/presentations/initial/screen.dart';
import 'package:sample_local_auth/presentations/settings/screen.dart';

part 'route.g.dart';

/// アプリケーション全体のナビゲーションを管理するためのキー。
/// このキーを使うことで、アプリケーションのどこからでも
/// ナビゲーターに直接アクセスし、画面遷移を制御することができる。
final rootNavigationKey = GlobalKey<NavigatorState>();

// 大元のルート
@TypedShellRoute<AppShellRoute>(
  routes: [
    // ログイン後の画面 ここから ---->
    TypedStatefulShellRoute<NavigationShellRoute>(
      branches: [
        TypedStatefulShellBranch<HomeBranch>(
          routes: [
            TypedGoRoute<HomeRoute>(
              path: '/',
              name: 'home_screen',
            ),
          ],
        ),
        TypedStatefulShellBranch<SettingsBranch>(
          routes: [
            TypedGoRoute<SettingsRoute>(
              path: '/settings',
              name: 'settings_screen',
            ),
          ],
        ),
      ],
    ),
    // ログイン後の画面 ここまで ---->
    // 初期画面
    TypedGoRoute<InitialRoute>(
      path: '/initial',
      name: 'initial_screen',
    ),

    // ロック画面
    TypedGoRoute<AppLockedRoute>(
      path: '/locked',
      name: 'locked_screen',
    ),
  ],
)

/// アプリの大元のルート
class AppShellRoute extends ShellRouteData {
  const AppShellRoute();

  static final $navigationKey = rootNavigationKey;

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    Widget navigator,
  ) {
    return Scaffold(
      body: AppRouteScreen(child: navigator),
    );
  }
}

// Branchはタブのルートの入れ物

class HomeBranch extends StatefulShellBranchData {
  const HomeBranch();
}

class SettingsBranch extends StatefulShellBranchData {
  const SettingsBranch();
}

/// タブのナビゲーターを設定
class NavigationShellRoute extends StatefulShellRouteData {
  const NavigationShellRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppNavigationBar(
        navigationShell: navigationShell,
      ),
    );
  }
}

// それぞれの画面を設定

class HomeRoute extends GoRouteData {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const HomeScreen();
  }
}

class SettingsRoute extends GoRouteData {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const SettingsScreen();
  }
}

class InitialRoute extends GoRouteData {
  const InitialRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const InitialScreen();
  }
}

class AppLockedRoute extends GoRouteData {
  const AppLockedRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const AppLockedScreen();
  }
}
