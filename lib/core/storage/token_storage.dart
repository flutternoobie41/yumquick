import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// The access token is cached in memory after the first read so the auth
/// interceptor does not hit secure storage on every request.
class TokenStorage {
  TokenStorage(this._storage);

  final FlutterSecureStorage _storage;

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  String? _cachedAccessToken;

  Future<String?> readAccessToken() async {
    return _cachedAccessToken ??= await _storage.read(key: _accessTokenKey);
  }

  Future<String?> readRefreshToken() {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<void> saveTokens({
    required String accessToken,
    String? refreshToken,
  }) async {
    _cachedAccessToken = accessToken;
    await _storage.write(key: _accessTokenKey, value: accessToken);
    if (refreshToken != null) {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
    }
  }

  Future<void> clear() async {
    _cachedAccessToken = null;
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}