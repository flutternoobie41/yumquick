import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yum_quick/app/router.dart';
import 'package:yum_quick/app/router_refresh.dart';
import 'package:yum_quick/app/theme/app_theme.dart';
import 'package:yum_quick/features/auth/presentation/bloc/auth_bloc.dart';

/// Root widget of the app.
///
/// [authBloc] is created in `main` and lives as long as the app. It is
/// passed in so tests can supply a mock.
class YumQUickApp extends StatefulWidget {
  const YumQUickApp({super.key, required this.authBloc});

  final AuthBloc authBloc;

  @override
  State<YumQUickApp> createState() => _YumQUickAppState();
}

class _YumQUickAppState extends State<YumQUickApp> {
  late final RouterRefresh _routerRefresh =
      RouterRefresh(widget.authBloc.stream);
  late final GoRouter _router = createRouter(
    authBloc: widget.authBloc,
    refreshListenable: _routerRefresh,
  );

  @override
  void dispose() {
    _router.dispose();
    _routerRefresh.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.authBloc,
      child: MaterialApp.router(
        title: 'YumQuick',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: _router,
      ),
    );
  }
}