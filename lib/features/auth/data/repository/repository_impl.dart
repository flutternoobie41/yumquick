import 'package:yum_quick/core/error/error_gaurd.dart';
import 'package:yum_quick/core/error/failure.dart';
import 'package:yum_quick/core/error/result.dart';
import 'package:yum_quick/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:yum_quick/features/auth/data/data_sources/auth_remote_data_sources.dart';
import 'package:yum_quick/features/auth/data/models/user_model.dart';
import 'package:yum_quick/features/auth/domain/entity/user.dart';
import 'package:yum_quick/features/auth/domain/repository/auth_repository.dart';


class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<Result<User>> login({
    required String username,
    required String password,
  }) {
    return guard(() async {
      final response = await _remote.login(
        username: username,
        password: password,
      );
      await _local.saveSession(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
        user: response.user,
      );
      return response.user.toEntity();
    });
  }

  @override
  Future<Result<User?>> restoreSession() async {
    final tokenCheck = await guard(_local.hasToken);
    switch (tokenCheck) {
      case Err(:final failure):
        return Err(failure);
      case Success(data: false):
        return const Success(null);
      case Success():
        break;
    }

    final fresh = await guard(() async {
      final user = await _remote.me();
      await _local.saveUser(user);
      return user.toEntity();
    });

    switch (fresh) {
      case Success(:final data):
        return Success(data);
      case Err(failure: final UnauthorizedFailure failure):
        await guard(_local.clear);
        return Err(failure);
      case Err(:final failure):
        // Offline or server trouble: open the app with the cached user,
        // so cached food items can still be shown.
        final cached = await guard(_local.readUser);
        if (cached case Success(data: final UserModel user)) {
          return Success(user.toEntity());
        }
        return Err(failure);
    }
  }

  @override
  Future<void> logout() async {
    await guard(_local.clear);
  }
}