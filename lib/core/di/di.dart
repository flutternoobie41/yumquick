import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:yum_quick/core/network/auth_interceptor.dart';
import 'package:yum_quick/core/network/dio_client.dart';
import 'package:yum_quick/core/session/session_event.dart';
import 'package:yum_quick/core/storage/token_storage.dart';
import 'package:yum_quick/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:yum_quick/features/auth/data/data_sources/auth_remote_data_sources.dart';
import 'package:yum_quick/features/auth/data/repository/repository_impl.dart';
import 'package:yum_quick/features/auth/domain/repository/auth_repository.dart';
import 'package:yum_quick/features/cart/data/data_source/cart_local_data_source.dart';
import 'package:yum_quick/features/cart/data/repository/cart_repository_impl.dart';
import 'package:yum_quick/features/cart/domain/repository/cart_repository.dart';
import 'package:yum_quick/features/food/data/data_source.dart/food_remote_data_source.dart';
import 'package:yum_quick/features/food/domain/repository/food_repository.dart';
import 'package:yum_quick/features/food/repository/food_repository_impl.dart';

/// Service locator for data sources and repositories.
/// Blocs are not registered here; they are provided with BlocProvider.
final GetIt getIt = GetIt.instance;

/// Registers app-wide services. Async because later phases open Hive here.
Future<void> setupDependencies() async {
  await Hive.initFlutter();
  final cartBox = await Hive.openBox<String>(CartLocalDataSource.boxName);
  // Core
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

  // Auth
  getIt
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSource(getIt()),
    )
    ..registerLazySingleton<AuthLocalDataSource>(
      () => AuthLocalDataSource(tokenStorage: getIt(), secureStorage: getIt()),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remote: getIt(), local: getIt()),
    );

  // Food
  getIt
    ..registerLazySingleton<FoodRemoteDataSource>(
      () => FoodRemoteDataSource(getIt()),
    )
    ..registerLazySingleton<FoodRepository>(
      () => FoodRepositoryImpl(remote: getIt()),
    );

      // Cart
  getIt
    ..registerLazySingleton<CartLocalDataSource>(
      () => CartLocalDataSource(cartBox),
    )
    ..registerLazySingleton<CartRepository>(
      () => CartRepositoryImpl(local: getIt()),
    );
}
