import 'dart:io';

import 'package:dio/dio.dart';
import 'package:yum_quick/core/error/failure.dart';

/// Maps a [DioException] to a typed [Failure].
Failure mapDioException(DioException exception) {
  return switch (exception.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout ||
    DioExceptionType.transformTimeout ||
    DioExceptionType.connectionError =>
      const NetworkFailure(),
    DioExceptionType.badResponse => _fromResponse(exception.response),
    DioExceptionType.cancel => const CancelledFailure(),
    DioExceptionType.badCertificate => const ServerFailure(),
    DioExceptionType.unknown => exception.error is SocketException
        ? const NetworkFailure()
        : const UnexpectedFailure(),
  };
}

Failure _fromResponse(Response<dynamic>? response) {
  final statusCode = response?.statusCode;

  if (statusCode == 401) {
    return const UnauthorizedFailure();
  }
  if (statusCode != null && statusCode >= 500) {
    return ServerFailure(statusCode: statusCode);
  }

  // DummyJSON explains 4xx errors in a `message` field,
  // e.g. {"message": "Invalid credentials"} on a failed login.
  final message = _serverMessage(response?.data);
  return message == null
      ? ServerFailure(statusCode: statusCode)
      : ServerFailure(message: message, statusCode: statusCode);
}

String? _serverMessage(Object? data) {
  if (data case {'message': final String message} when message.isNotEmpty) {
    return message;
  }
  return null;
}
