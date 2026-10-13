import 'package:equatable/equatable.dart';

/// A dish on the menu.
class FoodItem extends Equatable {
  const FoodItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.prepMinutes,
    required this.cookMinutes,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.caloriesPerServing,
    required this.ingredients,
    required this.instructions,
    required this.tags,
    required this.mealTypes,
  });

  final int id;
  final String name;
  final String imageUrl;
  final double price;
  final double rating;
  final int reviewCount;
  final int prepMinutes;
  final int cookMinutes;
  final int servings;
  final String difficulty;
  final String cuisine;
  final int caloriesPerServing;
  final List<String> ingredients;
  final List<String> instructions;
  final List<String> tags;
  final List<String> mealTypes;

  int get totalMinutes => prepMinutes + cookMinutes;

  @override
  List<Object?> get props => [id, name, price, rating];
}