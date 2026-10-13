part of 'cart_cubit.dart';

final class CartState extends Equatable {
  const CartState({this.items = const [], this.lastRemoved});

  final List<CartItem> items;

  /// The line removed most recently, kept so it can be undone. Cleared by
  /// any other change.
  final RemovedCartItem? lastRemoved;

  Cart get cart => Cart(items);

  @override
  List<Object?> get props => [items, lastRemoved];
}

final class RemovedCartItem extends Equatable {
  const RemovedCartItem(this.item, this.index);

  final CartItem item;

  /// Where the line was, so undo puts it back in the same place.
  final int index;

  @override
  List<Object?> get props => [item, index];
}