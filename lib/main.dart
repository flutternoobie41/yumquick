import 'package:flutter/material.dart';
import 'package:yum_quick/app/app.dart';
import 'package:yum_quick/core/di/di.dart';
import 'package:yum_quick/features/auth/presentation/bloc/auth_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();

  final authBloc = AuthBloc(
    authRepository: getIt(),
    sessionEvents: getIt(),
  )..add(const AuthStarted());

  runApp(YumQUickApp(authBloc: authBloc));
}