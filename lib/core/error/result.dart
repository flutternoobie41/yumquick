import 'package:equatable/equatable.dart';
import 'package:yum_quick/core/error/failure.dart';

/// Outcome of a repository call: either [Success] with data or [Err] with
/// a typed [Failure].
sealed class Result<T> extends Equatable {
  const Result();

  /// Handles both outcomes in one expression.
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) {
    return switch (this) {
      Success<T>(:final data) => onSuccess(data),
      Err<T>(:final failure) => onFailure(failure),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;

  @override
  List<Object?> get props => [data];
}

final class Err<T> extends Result<T> {
  const Err(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}