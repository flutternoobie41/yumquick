import 'dart:async';

/// Carries session events from the network layer to the auth layer.
///
/// The auth interceptor reports an expired session here and AuthBloc
/// listens, so Dio never depends on Bloc and vice versa.
class SessionEvents {
  final StreamController<void> _expired = StreamController<void>.broadcast();

  /// Emits whenever the server rejects the current token.
  Stream<void> get onExpired => _expired.stream;

  void expire() => _expired.add(null);

  Future<void> dispose() => _expired.close();
}