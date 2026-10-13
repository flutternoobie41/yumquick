part of 'auth_bloc.dart';


sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Session not checked yet; the splash screen is showing.
final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

/// A login request is in flight.
final class AuthAuthenticating extends AuthState {
  const AuthAuthenticating();
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

/// Logged out. [failure] explains why, when there is something to tell
/// the user (wrong password, expired session, no network).
final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.failure});

  final Failure? failure;

  @override
  List<Object?> get props => [failure];
}