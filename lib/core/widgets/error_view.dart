import 'package:flutter/material.dart';
import 'package:yum_quick/core/error/failure.dart';
import 'package:yum_quick/core/widgets/status_view.dart';


/// Friendly full-screen error for a [Failure], with an optional retry.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.failure, this.onRetry});

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final (icon, title) = switch (failure) {
      NetworkFailure() => (Icons.wifi_off_rounded, "You're offline"),
      UnauthorizedFailure() => (Icons.lock_outline_rounded, 'Session expired'),
      _ => (Icons.error_outline_rounded, 'Something went wrong'),
    };
    final onRetry = this.onRetry;

    return StatusView(
      icon: icon,
      title: title,
      message: failure.message,
      action: onRetry == null
          ? null
          : FilledButton(onPressed: onRetry, child: const Text('Try again')),
    );
  }
}