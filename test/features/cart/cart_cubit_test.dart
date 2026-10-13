import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yum_quick/core/error/result.dart';
import 'package:yum_quick/features/cart/domain/entities/cart.dart';
import 'package:yum_quick/features/cart/domain/entities/cart_items.dart';
import 'package:yum_quick/features/cart/domain/repository/cart_repository.dart';

import 'package:yum_quick/features/cart/presentation/cubit/cart_cubit.dart';

class _MockCartRepository extends Mock implements CartRepository {}

const _pizza = CartItem(
  foodId: 1,
  name: 'Pizza',
  imageUrl: '',
  unitPrice: 10,
  quantity: 1,
);

const _salad = CartItem(
  foodId: 2,
  name: 'Salad',
  imageUrl: '',
  unitPrice: 5.5,
  quantity: 2,
);

void main() {
  late _MockCartRepository repository;

  setUpAll(() => registerFallbackValue(<CartItem>[]));

  setUp(() {
    repository = _MockCartRepository();
    when(() => repository.save(any()))
        .thenAnswer((_) async => const Success<void>(null));
  });

  CartCubit build() => CartCubit(repository: repository);

  group('CartCubit', () {
    blocTest<CartCubit, CartState>(
      'load restores the saved cart',
      setUp: () => when(() => repository.load())
          .thenAnswer((_) async => const Success([_pizza])),
      build: build,
      act: (cubit) => cubit.load(),
      expect: () => [
        const CartState(items: [_pizza]),
      ],
    );

    blocTest<CartCubit, CartState>(
      'adding the same food twice merges quantities and saves each change',
      build: build,
      act: (cubit) async {
        await cubit.add(_pizza);
        await cubit.add(_pizza.copyWith(quantity: 2));
      },
      expect: () => [
        const CartState(items: [_pizza]),
        CartState(items: [_pizza.copyWith(quantity: 3)]),
      ],
      verify: (_) => verify(() => repository.save(any())).called(2),
    );

    blocTest<CartCubit, CartState>(
      'quantity is capped at maxQuantity',
      build: build,
      seed: () => const CartState(items: [_pizza]),
      act: (cubit) => cubit.setQuantity(_pizza.foodId, 99),
      expect: () => [
        CartState(
          items: [_pizza.copyWith(quantity: CartCubit.maxQuantity)],
        ),
      ],
    );

    blocTest<CartCubit, CartState>(
      'quantity never drops below 1',
      build: build,
      seed: () => CartState(items: [_pizza.copyWith(quantity: 2)]),
      act: (cubit) => cubit.setQuantity(_pizza.foodId, 0),
      expect: () => [
        const CartState(items: [_pizza]),
      ],
    );

    blocTest<CartCubit, CartState>(
      'undo puts a removed line back in the same place',
      build: build,
      seed: () => const CartState(items: [_pizza, _salad]),
      act: (cubit) async {
        await cubit.remove(_pizza.foodId);
        await cubit.undoRemove();
      },
      expect: () => [
        const CartState(
          items: [_salad],
          lastRemoved: RemovedCartItem(_pizza, 0),
        ),
        const CartState(items: [_pizza, _salad]),
      ],
    );

    blocTest<CartCubit, CartState>(
      'clear empties the cart',
      build: build,
      seed: () => const CartState(items: [_pizza, _salad]),
      act: (cubit) => cubit.clear(),
      expect: () => [const CartState()],
    );
  });

  group('Cart totals', () {
    test('subtotal, 5% tax and fees, flat delivery and total', () {
      const cart = Cart([_pizza, _salad]);

      expect(cart.itemCount, 3);
      expect(cart.subtotal, 21.0);
      expect(cart.taxAndFees, 1.05);
      expect(cart.delivery, Cart.deliveryFee);
      expect(cart.total, 25.04);
    });

    test('an empty cart costs nothing', () {
      const cart = Cart([]);

      expect(cart.delivery, 0);
      expect(cart.total, 0);
    });
  });
}