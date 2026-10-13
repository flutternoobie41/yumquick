import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yum_quick/core/error/result.dart';
import 'package:yum_quick/features/cart/domain/entities/cart.dart';
import 'package:yum_quick/features/cart/domain/entities/cart_items.dart';
import 'package:yum_quick/features/cart/domain/repository/cart_repository.dart';


part 'cart_state.dart';

/// App-wide cart. Every change is saved, so the cart survives restarts.
class CartCubit extends Cubit<CartState> {
  CartCubit({required CartRepository repository})
      : _repository = repository,
        super(const CartState());

  final CartRepository _repository;

  static const int maxQuantity = 20;

  /// Restores the saved cart. An unreadable cart simply starts empty.
  Future<void> load() async {
    final result = await _repository.load();
    if (result case Success(:final data)) {
      emit(CartState(items: data));
    }
  }

  /// Adds [item], merging with an existing line for the same food.
  Future<void> add(CartItem item) {
    final items = [...state.items];
    final index = items.indexWhere((line) => line.foodId == item.foodId);
    if (index == -1) {
      items.add(item.copyWith(quantity: min(item.quantity, maxQuantity)));
    } else {
      final merged = min(items[index].quantity + item.quantity, maxQuantity);
      items[index] = items[index].copyWith(quantity: merged);
    }
    return _update(items);
  }

  /// Sets a line's quantity, kept between 1 and [maxQuantity].
  /// Removing a line is a separate action, so it can be undone.
  Future<void> setQuantity(int foodId, int quantity) {
    final clamped = quantity.clamp(1, maxQuantity);
    return _update([
      for (final line in state.items)
        line.foodId == foodId ? line.copyWith(quantity: clamped) : line,
    ]);
  }

  Future<void> remove(int foodId) async {
    final index = state.items.indexWhere((line) => line.foodId == foodId);
    if (index == -1) {
      return;
    }
    final items = [...state.items]..removeAt(index);
    emit(
      CartState(
        items: items,
        lastRemoved: RemovedCartItem(state.items[index], index),
      ),
    );
    await _save(items);
  }

  Future<void> undoRemove() async {
    final removed = state.lastRemoved;
    if (removed == null) {
      return;
    }
    final items = [...state.items]
      ..insert(min(removed.index, state.items.length), removed.item);
    await _update(items);
  }

  /// Empties the cart after an order is placed.
  Future<void> clear() => _update(const []);

  Future<void> _update(List<CartItem> items) async {
    emit(CartState(items: items));
    await _save(items);
  }

  Future<void> _save(List<CartItem> items) async {
    // A failed write keeps the cart in memory; the next change saves again.
    await _repository.save(items);
  }
}