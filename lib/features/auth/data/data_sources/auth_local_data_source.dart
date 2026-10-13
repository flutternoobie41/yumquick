import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yum_quick/core/storage/token_storage.dart';
import 'package:yum_quick/features/auth/data/models/user_model.dart';

/// Persists the session: tokens through [TokenStorage], plus the last known
/// user so the app can open offline.
class AuthLocalDataSource {
  AuthLocalDataSource({
    required TokenStorage tokenStorage,
    required FlutterSecureStorage secureStorage,
  })  : _tokenStorage = tokenStorage,
        _secureStorage = secureStorage;

  final TokenStorage _tokenStorage;
  final FlutterSecureStorage _secureStorage;

  static const String _userKey = 'cached_user';

  Future<bool> hasToken() async {
    return await _tokenStorage.readAccessToken() != null;
  }

  Future<void> saveSession({
    required String accessToken,
    required String? refreshToken,
    required UserModel user,
  }) async {
    await _tokenStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
    await saveUser(user);
  }

  Future<void> saveUser(UserModel user) {
    return _secureStorage.write(
      key: _userKey,
      value: jsonEncode(user.toJson()),
    );
  }

  Future<UserModel?> readUser() async {
    final raw = await _secureStorage.read(key: _userKey);
    if (raw == null) {
      return null;
    }
    final json = jsonDecode(raw);
    return json is Map<String, dynamic> ? UserModel.fromJson(json) : null;
  }

  Future<void> clear() async {
    await _tokenStorage.clear();
    await _secureStorage.delete(key: _userKey);
  }
}