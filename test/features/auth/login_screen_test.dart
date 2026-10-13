import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yum_quick/app/theme/app_theme.dart';
import 'package:yum_quick/core/error/failure.dart';
import 'package:yum_quick/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yum_quick/features/auth/presentation/screens/login_screen.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

void main() {
  late _MockAuthBloc authBloc;

  setUpAll(() => registerFallbackValue(const AuthStarted()));

  setUp(() {
    authBloc = _MockAuthBloc();
    whenListen(
      authBloc,
      const Stream<AuthState>.empty(),
      initialState: const AuthUnauthenticated(),
    );
  });

  Future<void> pumpLogin(WidgetTester tester) {
    return tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: BlocProvider<AuthBloc>.value(
          value: authBloc,
          child: const LoginScreen(),
        ),
      ),
    );
  }

  Future<void> tapLogIn(WidgetTester tester) async {
    final button = find.byKey(const Key('login_submit'));
    await tester.ensureVisible(button);
    await tester.tap(button);
    await tester.pump();
  }

  testWidgets('shows validation errors and does not submit an empty form',
      (tester) async {
    await pumpLogin(tester);

    await tapLogIn(tester);

    expect(find.text('Enter your username'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    verifyNever(() => authBloc.add(any()));
  });

  testWidgets('submits the trimmed username and the password',
      (tester) async {
    await pumpLogin(tester);

    await tester.enterText(find.byKey(const Key('login_username')), ' emilys ');
    await tester.enterText(
      find.byKey(const Key('login_password')),
      'emilyspass',
    );
    await tapLogIn(tester);

    verify(
      () => authBloc.add(
        const AuthLoginSubmitted(username: 'emilys', password: 'emilyspass'),
      ),
    ).called(1);
  });

  testWidgets('shows the server message when login fails', (tester) async {
    whenListen(
      authBloc,
      Stream<AuthState>.fromIterable(const [
        AuthUnauthenticated(
          failure: ServerFailure(
            message: 'Invalid credentials',
            statusCode: 400,
          ),
        ),
      ]),
      initialState: const AuthUnauthenticated(),
    );

    await pumpLogin(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Invalid credentials'), findsOneWidget);
  });
}