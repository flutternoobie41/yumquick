import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:yum_quick/core/error/error_mapper.dart';
import 'package:yum_quick/core/error/failure.dart';
import 'package:yum_quick/core/error/result.dart';

/// Runs [body] and turns any expected exception into a typed [Failure].
///
/// Every repository call goes through this, so no raw exception can
/// reach a Bloc or the UI.
Future<Result<T>> guard<T>(Future<T> Function() body) async {
  try {
    return Success(await body());
  } on DioException catch (exception) {
    return Err(mapDioException(exception));
  } on PlatformException {
    // Secure storage / plugin errors.
    return const Err(CacheFailure());
  } on FormatException {
    return const Err(ServerFailure());
  } on TypeError {
    // A field had an unexpected type while parsing JSON.
    return const Err(ServerFailure());
  }
}