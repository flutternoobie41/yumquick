import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:yum_quick/core/network/api_endpoints.dart';
import 'package:yum_quick/core/network/auth_interceptor.dart';

/// Builds the single [Dio] instance used by every remote data source.
Dio createDio({required AuthInterceptor authInterceptor}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      contentType: Headers.jsonContentType,
    ),
  );

  dio.interceptors.add(authInterceptor);

  if (kDebugMode) {
    dio.interceptors.add(
      LogInterceptor(
        // Headers carry the bearer token, so keep them out of the log.
        requestHeader: false,
        requestBody: true,
        logPrint: (object) => debugPrint(object.toString()),
      ),
    );
  }

  return dio;
}