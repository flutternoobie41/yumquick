
part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// App launched: try to restore a saved session (auto-login).
final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthLoginSubmitted extends AuthEvent {
  const AuthLoginSubmitted({required this.username, required this.password});

  final String username;
  final String password;

  @override
  List<Object?> get props => [username, password];
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

/// The server rejected the token (401) during normal use.
final class AuthSessionExpired extends AuthEvent {
  const AuthSessionExpired();
}