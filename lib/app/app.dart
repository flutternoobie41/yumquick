import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yum_quick/app/router.dart';
import 'package:yum_quick/app/router_refresh.dart';
import 'package:yum_quick/app/theme/app_theme.dart';
import 'package:yum_quick/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yum_quick/features/cart/presentation/cubit/cart_cubit.dart';

/// Root widget of the app.
///
/// [authBloc] and [cartCubit] are created in `main` and live as long as
/// the app. They are passed in so tests can supply mocks.
class YumQUickApp extends StatefulWidget {
  const YumQUickApp({
    super.key,
    required this.authBloc,
    required this.cartCubit,
  });

  final AuthBloc authBloc;
  final CartCubit cartCubit;

  @override
  State<YumQUickApp> createState() => _YumQUickAppState();
}

class _YumQUickAppState extends State<YumQUickApp> {
  late final RouterRefresh _routerRefresh =
      RouterRefresh(widget.authBloc.stream);
  final _splashDone = ValueNotifier<bool>(false); // ← new
  late final GoRouter _router = createRouter(
    authBloc: widget.authBloc,
    refreshListenable: _routerRefresh,
    splashDone: _splashDone, // ← new
  );

  @override
  void dispose() {
    _router.dispose();
    _routerRefresh.dispose();
    _splashDone.dispose(); // ← new
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: widget.authBloc),
        BlocProvider.value(value: widget.cartCubit),
      ],
      child: MaterialApp.router(
        title: 'YumQuick',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}
