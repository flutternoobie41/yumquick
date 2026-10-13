import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yum_quick/app/app.dart';
import 'package:yum_quick/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yum_quick/features/cart/presentation/cubit/cart_cubit.dart';

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  testWidgets('shows the splash while the session is restored',
      (tester) async {
    final authBloc = _MockAuthBloc();
    whenListen(
      authBloc,
      const Stream<AuthState>.empty(),
      initialState: const AuthUnknown(),
    );
    final cartCubit = _MockCartCubit();
    whenListen(
      cartCubit,
      const Stream<CartState>.empty(),
      initialState: const CartState(),
    );

    await tester.pumpWidget(
      YumQUickApp(authBloc: authBloc, cartCubit: cartCubit),
    );
    await tester.pumpAndSettle();

    expect(find.text('YUMQUICK'), findsOneWidget);
  });
}