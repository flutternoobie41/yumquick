import 'package:flutter/material.dart';
import 'package:yum_quick/app/app.dart';
import 'package:yum_quick/core/di/di.dart';
import 'package:yum_quick/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yum_quick/features/cart/presentation/cubit/cart_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();

  final authBloc = AuthBloc(
    authRepository: getIt(),
    sessionEvents: getIt(),
  )..add(const AuthStarted());

  final cartCubit = CartCubit(repository: getIt());
  await cartCubit.load();

  runApp(YumQUickApp(authBloc: authBloc, cartCubit: cartCubit));
}