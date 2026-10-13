import 'package:equatable/equatable.dart';

/// One line in the cart. Keeps its own copy of name, image and price so the
/// cart can be shown and restored without the food list.
class CartItem extends Equatable {
  const CartItem({
    required this.foodId,
    required this.name,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
  });

  final int foodId;
  final String name;
  final String imageUrl;
  final double unitPrice;
  final int quantity;

  double get lineTotal => unitPrice * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      foodId: foodId,
      name: name,
      imageUrl: imageUrl,
      unitPrice: unitPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [foodId, name, imageUrl, unitPrice, quantity];
}