import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yum_quick/core/di/di.dart';
import 'package:yum_quick/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yum_quick/features/auth/presentation/screens/login_screen.dart';
import 'package:yum_quick/features/auth/presentation/screens/splash_screen.dart';
import 'package:yum_quick/features/cart/presentation/screens/cart_screen.dart';
import 'package:yum_quick/features/cart/presentation/screens/confirm_order_screen.dart';
import 'package:yum_quick/features/food/domain/entities/food_item.dart';
import 'package:yum_quick/features/food/presentation/bloc/food_list_bloc.dart';
import 'package:yum_quick/features/food/presentation/cubit/food_detail_cubit.dart';
import 'package:yum_quick/features/food/presentation/screens/food_detail_screen.dart';
import 'package:yum_quick/features/food/presentation/screens/home_screen.dart';

abstract final class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/';
  static String foodDetail(int id) => '/food/$id';
  static const String cart = '/cart';
  static const String confirmOrder = '/cart/confirm';
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
        AuthUnknown() => location == AppRoutes.splash ? null : AppRoutes.splash,
        AuthAuthenticating() ||
        AuthUnauthenticated() =>
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
        builder: (context, state) => BlocProvider(
          create: (_) =>
              FoodListBloc(repository: getIt())..add(const FoodListStarted()),
          child: const HomeScreen(),
        ),
        routes: [
          GoRoute(
            path: 'food/:id',
            builder: (context, state) {
              final extra = state.extra;
              return BlocProvider(
                create: (_) => FoodDetailCubit(
                  repository: getIt(),
                  id: int.tryParse(state.pathParameters['id'] ?? '') ?? 0,
                  // The list passes the item it already has.
                  initialItem: extra is FoodItem ? extra : null,
                )..start(),
                child: const FoodDetailScreen(),
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: AppRoutes.cart,
        builder: (context, state) => const CartScreen(),
        routes: [
          GoRoute(
            path: 'confirm',
            builder: (context, state) => const ConfirmOrderScreen(),
          ),
        ],
      ),
    ],
  );
}
