part of 'food_detail_cubit.dart';

final class FoodDetailState extends Equatable {
  const FoodDetailState({this.item, this.quantity = 1, this.failure});

  /// `null` while loading or after a failed load.
  final FoodItem? item;
  final int quantity;
  final Failure? failure;

  double get total => (item?.price ?? 0) * quantity;

  FoodDetailState copyWith({int? quantity}) {
    return FoodDetailState(
      item: item,
      quantity: quantity ?? this.quantity,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [item, quantity, failure];
}