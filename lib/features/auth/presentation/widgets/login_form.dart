import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_dimens.dart';
import 'package:yum_quick/core/widgets/app_text_field.dart';
import 'package:yum_quick/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yum_quick/features/auth/presentation/widgets/login_validators.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return;
    }
    context.read<AuthBloc>().add(
          AuthLoginSubmitted(
            username: _usernameController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isSubmitting = context.select<AuthBloc, bool>(
      (bloc) => bloc.state is AuthAuthenticating,
    );

    return Form(
      key: _formKey,
      child: AutofillGroup(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            40,
            AppSpacing.screenHorizontal,
            24,
          ),
          children: [
            Text('Welcome', style: textTheme.titleLarge),
            const SizedBox(height: 12),
            Text(
              "Log in to browse today's menu and order in a few taps.",
              style: textTheme.bodyMedium?.copyWith(height: 1.4),
            ),
            const SizedBox(height: 32),
            AppTextField(
              key: const Key('login_username'),
              label: 'Username',
              hintText: 'emilys',
              controller: _usernameController,
              validator: LoginValidators.username,
              enabled: !isSubmitting,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.username],
            ),
            const SizedBox(height: 20),
            AppTextField(
              key: const Key('login_password'),
              label: 'Password',
              hintText: '••••••••',
              controller: _passwordController,
              validator: LoginValidators.password,
              obscureText: true,
              enabled: !isSubmitting,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.password],
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: 40),
            Center(
              child: FilledButton(
                key: const Key('login_submit'),
                onPressed: isSubmitting ? null : _submit,
                child: isSubmitting
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: AppColors.orangeBase,
                        ),
                      )
                    : const Text('Log In'),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Test account: emilys / emilyspass',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.text2),
            ),
          ],
        ),
      ),
    );
  }
}