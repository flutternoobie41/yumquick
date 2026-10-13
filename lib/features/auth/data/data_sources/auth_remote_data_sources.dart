import 'package:dio/dio.dart';
import 'package:yum_quick/core/network/api_endpoints.dart';
import 'package:yum_quick/features/auth/data/models/user_model.dart';

/// Talks to DummyJSON's auth endpoints. Throws [DioException] or
/// [FormatException]; the repository maps those to failures.
class AuthRemoteDataSource {
  AuthRemoteDataSource(this._dio);

  final Dio _dio;

  /// Access token lifetime requested at login. Set it to 1 to see the
  /// log-out-on-401 flow within a minute.
  static const int sessionMinutes = 60;

  Future<LoginResponseModel> login({
    required String username,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      ApiEndpoints.login,
      data: {
        'username': username,
        'password': password,
        'expiresInMins': sessionMinutes,
      },
    );
    return LoginResponseModel.fromJson(_body(response));
  }

  Future<UserModel> me() async {
    final response = await _dio.get<Map<String, dynamic>>(ApiEndpoints.me);
    return UserModel.fromJson(_body(response));
  }

  Map<String, dynamic> _body(Response<Map<String, dynamic>> response) {
    return response.data ?? (throw const FormatException('Empty response'));
  }
}