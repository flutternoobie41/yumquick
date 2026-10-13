import 'package:json_annotation/json_annotation.dart';
import 'package:yum_quick/features/cart/domain/entities/cart_items.dart';

part 'cart_item_model.g.dart';

/// Stored shape of a cart line.
@JsonSerializable()
class CartItemModel {
  const CartItemModel({
    required this.foodId,
    required this.name,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  factory CartItemModel.fromEntity(CartItem item) => CartItemModel(
        foodId: item.foodId,
        name: item.name,
        imageUrl: item.imageUrl,
        unitPrice: item.unitPrice,
        quantity: item.quantity,
      );

  final int foodId;
  final String name;
  final String imageUrl;
  final double unitPrice;
  final int quantity;

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  CartItem toEntity() => CartItem(
        foodId: foodId,
        name: name,
        imageUrl: imageUrl,
        unitPrice: unitPrice,
        quantity: quantity,
      );
}