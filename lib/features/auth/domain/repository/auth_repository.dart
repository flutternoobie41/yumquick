import 'package:yum_quick/core/error/result.dart';
import 'package:yum_quick/features/auth/domain/entity/user.dart';

/// Auth contract the presentation layer depends on.
abstract interface class AuthRepository {
  /// Logs in and stores the session securely.
  Future<Result<User>> login({
    required String username,
    required String password,
  });

  /// Restores a saved session on app start.
  ///
  /// Succeeds with `null` when there is no saved session. When the server
  /// cannot be reached, falls back to the cached user so the app still
  /// opens offline.
  Future<Result<User?>> restoreSession();

  /// Clears the stored session.
  Future<void> logout();
}