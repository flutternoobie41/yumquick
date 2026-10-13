import 'package:json_annotation/json_annotation.dart';
import 'package:yum_quick/features/food/domain/entities/food_item.dart';

part 'recipe_model.g.dart';

/// Recipe as returned by DummyJSON `/recipes`.
@JsonSerializable()
class RecipeModel {
  const RecipeModel({
    required this.id,
    required this.name,
    required this.image,
    required this.rating,
    required this.reviewCount,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.servings,
    required this.difficulty,
    required this.cuisine,
    required this.caloriesPerServing,
    required this.ingredients,
    required this.instructions,
    required this.tags,
    required this.mealType,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) =>
      _$RecipeModelFromJson(json);

  final int id;
  final String name;
  final String image;
  final double rating;
  final int reviewCount;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final int servings;
  final String difficulty;
  final String cuisine;
  final int caloriesPerServing;

  @JsonKey(defaultValue: <String>[])
  final List<String> ingredients;

  @JsonKey(defaultValue: <String>[])
  final List<String> instructions;

  @JsonKey(defaultValue: <String>[])
  final List<String> tags;

  @JsonKey(defaultValue: <String>[])
  final List<String> mealType;

  Map<String, dynamic> toJson() => _$RecipeModelToJson(this);

  FoodItem toEntity() => FoodItem(
        id: id,
        name: name,
        imageUrl: image,
        price: mockPriceFor(id),
        rating: rating,
        reviewCount: reviewCount,
        prepMinutes: prepTimeMinutes,
        cookMinutes: cookTimeMinutes,
        servings: servings,
        difficulty: difficulty,
        cuisine: cuisine,
        caloriesPerServing: caloriesPerServing,
        ingredients: ingredients,
        instructions: instructions,
        tags: tags,
        mealTypes: mealType,
      );
}

/// The API has no prices, so each recipe gets a stable price from its id:
/// $4.99 to $23.99, always the same for the same item.
double mockPriceFor(int id) => 4.99 + (id * 37) % 20;

/// Paged envelope: `{recipes, total, skip, limit}`.
@JsonSerializable(createToJson: false)
class RecipesResponseModel {
  const RecipesResponseModel({
    required this.recipes,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory RecipesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RecipesResponseModelFromJson(json);

  final List<RecipeModel> recipes;
  final int total;
  final int skip;
  final int limit;
}