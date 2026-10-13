import 'package:equatable/equatable.dart';
import 'package:yum_quick/features/cart/domain/entities/cart_items.dart';


/// Cart totals. Pure Dart, so the pricing rules are easy to unit test.
///
/// Tax and fees and delivery are fixed mock values, as the task allows.
class Cart extends Equatable {
  const Cart(this.items);

  final List<CartItem> items;

  /// Tax and service fees, as a share of the subtotal.
  static const double taxAndFeesRate = 0.05;

  /// Flat delivery charge for a non-empty cart.
  static const double deliveryFee = 2.99;

  bool get isEmpty => items.isEmpty;

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _round(items.fold(0.0, (sum, item) => sum + item.lineTotal));

  double get taxAndFees => _round(subtotal * taxAndFeesRate);

  double get delivery => isEmpty ? 0.0 : deliveryFee;

  double get total => _round(subtotal + taxAndFees + delivery);

  /// Rounds to cents so displayed parts always add up to the total.
  static double _round(double value) => (value * 100).roundToDouble() / 100;

  @override
  List<Object?> get props => [items];
}