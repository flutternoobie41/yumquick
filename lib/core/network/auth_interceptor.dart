import 'package:dio/dio.dart';
import 'package:yum_quick/core/network/api_endpoints.dart';
import 'package:yum_quick/core/session/session_event.dart';
import 'package:yum_quick/core/storage/token_storage.dart';

/// Adds the bearer token to requests and ends the session on a 401.
///
/// On a 401 it clears the stored tokens and reports the expiry through
/// [SessionEvents]; AuthBloc then sends the user back to the login screen.
/// Token refresh is intentionally out of scope (see README).
class AuthInterceptor extends Interceptor {
  AuthInterceptor({
    required TokenStorage tokenStorage,
    required SessionEvents sessionEvents,
  })  : _tokenStorage = tokenStorage,
        _sessionEvents = sessionEvents;

  final TokenStorage _tokenStorage;
  final SessionEvents _sessionEvents;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!ApiEndpoints.isPublic(options.path)) {
      final token = await _tokenStorage.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isUnauthorized = err.response?.statusCode == 401;
    if (isUnauthorized && !ApiEndpoints.isPublic(err.requestOptions.path)) {
      await _tokenStorage.clear();
      _sessionEvents.expire();
    }
    handler.next(err);
  }
}