import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yum_quick/core/error/failure.dart';
import 'package:yum_quick/core/session/session_event.dart';
import 'package:yum_quick/features/auth/domain/entity/user.dart';
import 'package:yum_quick/features/auth/domain/repository/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Owns the session for the whole app. go_router redirects on its state.
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required AuthRepository authRepository,
    required SessionEvents sessionEvents,
  })  : _authRepository = authRepository,
        super(const AuthUnknown()) {
    on<AuthStarted>(_onStarted);
    // Ignore extra taps while a login is in flight.
    on<AuthLoginSubmitted>(_onLoginSubmitted, transformer: droppable());
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthSessionExpired>(_onSessionExpired);

    _sessionSubscription = sessionEvents.onExpired.listen(
      (_) => add(const AuthSessionExpired()),
    );
  }

  final AuthRepository _authRepository;
  late final StreamSubscription<void> _sessionSubscription;

  Future<void> _onStarted(AuthStarted event, Emitter<AuthState> emit) async {
    final result = await _authRepository.restoreSession();
    emit(
      result.fold(
        (failure) => AuthUnauthenticated(failure: failure),
        (user) => user == null
            ? const AuthUnauthenticated()
            : AuthAuthenticated(user),
      ),
    );
  }

  Future<void> _onLoginSubmitted(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthAuthenticating());
    final result = await _authRepository.login(
      username: event.username,
      password: event.password,
    );
    emit(
      result.fold(
        (failure) => AuthUnauthenticated(failure: failure),
        AuthAuthenticated.new,
      ),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _authRepository.logout();
    emit(const AuthUnauthenticated());
  }

  Future<void> _onSessionExpired(
    AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    // During start-up, restoreSession already reports the 401 itself.
    if (state is! AuthAuthenticated) {
      return;
    }
    await _authRepository.logout();
    emit(const AuthUnauthenticated(failure: UnauthorizedFailure()));
  }

  @override
  Future<void> close() async {
    await _sessionSubscription.cancel();
    return super.close();
  }
}