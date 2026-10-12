import 'package:equatable/equatable.dart';

/// Typed failures returned by repositories.
///
/// Raw exceptions never reach the UI: data sources throw, repositories
/// catch and map to one of these, and Blocs only ever see a [Failure].
sealed class Failure extends Equatable {
  const Failure(this.message);

  /// User-facing message, safe to show as is.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// No connection, DNS failure or timeout.
final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'No internet connection. Check your network and try again.',
  ]);
}

/// The server rejected the token (HTTP 401).
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([
    super.message = 'Your session has expired. Please log in again.',
  ]);
}

/// The server answered with an error, or with a payload we could not read.
final class ServerFailure extends Failure {
  const ServerFailure({
    String message = 'Something went wrong on our side. Please try again.',
    this.statusCode,
  }) : super(message);

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Reading or writing local storage (Hive, secure storage) failed.
final class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Could not read saved data.']);
}

/// The request was cancelled on purpose, for example a superseded search.
/// Blocs ignore this one instead of showing an error.
final class CancelledFailure extends Failure {
  const CancelledFailure() : super('');
}

/// Anything we did not anticipate.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([
    super.message = 'Something unexpected happened. Please try again.',
  ]);
}