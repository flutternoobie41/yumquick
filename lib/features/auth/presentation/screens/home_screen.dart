import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yum_quick/core/widgets/empty_view.dart';
import 'package:yum_quick/core/widgets/header_scaffold.dart';
import 'package:yum_quick/features/auth/presentation/bloc/auth_bloc.dart';

/// Placeholder home so the auth flow can be tried end to end.
/// Replaced by the real Home screen in Phase 3.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final firstName = context.select<AuthBloc, String>(
      (bloc) => switch (bloc.state) {
        AuthAuthenticated(:final user) => user.firstName,
        _ => '',
      },
    );

    return HeaderScaffold(
      title: 'Home',
      body: EmptyView(
        icon: Icons.restaurant_rounded,
        title: firstName.isEmpty ? 'Hi there' : 'Hi, $firstName',
        message: 'The menu arrives in the next build.',
        action: FilledButton(
          onPressed: () =>
              context.read<AuthBloc>().add(const AuthLogoutRequested()),
          child: const Text('Log Out'),
        ),
      ),
    );
  }
}