import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:get_it/get_it.dart';
import 'package:yum_quick/core/network/auth_interceptor.dart';
import 'package:yum_quick/core/network/dio_client.dart';
import 'package:yum_quick/core/session/session_event.dart';
import 'package:yum_quick/core/storage/token_storage.dart';

/// Service locator for data sources and repositories.
/// Blocs are not registered here; they are provided with BlocProvider.
final GetIt getIt = GetIt.instance;

/// Registers app-wide services. Async because later phases open Hive here.
Future<void> setupDependencies() async {
  getIt
    ..registerLazySingleton<FlutterSecureStorage>(
      () => const FlutterSecureStorage(),
    )
    ..registerLazySingleton<TokenStorage>(() => TokenStorage(getIt()))
    ..registerLazySingleton<SessionEvents>(
      SessionEvents.new,
      dispose: (events) => events.dispose(),
    )
    ..registerLazySingleton<AuthInterceptor>(
      () => AuthInterceptor(tokenStorage: getIt(), sessionEvents: getIt()),
    )
    ..registerLazySingleton<Dio>(
      () => createDio(authInterceptor: getIt()),
    );
}