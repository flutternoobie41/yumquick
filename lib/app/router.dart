import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:yum_quick/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yum_quick/features/auth/presentation/screens/home_screen.dart';
import 'package:yum_quick/features/auth/presentation/screens/login_screen.dart';
import 'package:yum_quick/features/auth/presentation/screens/splash_screen.dart';

abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/';
}

/// App router. Auth decides where the user may go:
/// unknown session → splash, logged out → login, logged in → app.
GoRouter createRouter({
  required AuthBloc authBloc,
  required Listenable refreshListenable,
}) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final location = state.matchedLocation;
      return switch (authBloc.state) {
        AuthUnknown() =>
          location == AppRoutes.splash ? null : AppRoutes.splash,
        AuthAuthenticating() || AuthUnauthenticated() =>
          location == AppRoutes.login ? null : AppRoutes.login,
        AuthAuthenticated() =>
          location == AppRoutes.login || location == AppRoutes.splash
              ? AppRoutes.home
              : null,
      };
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}