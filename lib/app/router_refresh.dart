import 'dart:async';

import 'package:flutter/foundation.dart';

/// Turns a stream into a [Listenable] so go_router re-runs its redirect
/// whenever the stream emits (here: every AuthBloc state change).
class RouterRefresh extends ChangeNotifier {
  RouterRefresh(Stream<Object?> stream) {
    _subscription = stream.listen((_) => notifyListeners());
  }

  late final StreamSubscription<Object?> _subscription;

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}