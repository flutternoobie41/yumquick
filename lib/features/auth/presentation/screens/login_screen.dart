import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yum_quick/core/error/failure.dart';
import 'package:yum_quick/core/widgets/header_scaffold.dart';
import 'package:yum_quick/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yum_quick/features/auth/presentation/widgets/login_form.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderScaffold(
      title: 'Log In',
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state case AuthUnauthenticated(failure: final Failure failure)) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(failure.message)));
          }
        },
        child: const LoginForm(),
      ),
    );
  }
}