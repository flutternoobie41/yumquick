import 'package:yum_quick/features/food/domain/entities/food_item.dart';

/// The design's five categories, mapped onto the API's `mealType` and
/// `tags` values. See the README for the reasoning.
enum FoodCategory {
  snacks('Snacks'),
  meal('Meal'),
  vegan('Vegan'),
  dessert('Dessert'),
  drinks('Drinks');

  const FoodCategory(this.label);

  final String label;

  bool matches(FoodItem item) {
    return switch (this) {
      FoodCategory.snacks => item.mealTypes.any(_snackTypes.contains),
      FoodCategory.meal => item.mealTypes.any(_mealTypes.contains),
      FoodCategory.vegan =>
        !item.ingredients.any(_animalProduct.hasMatch),
      FoodCategory.dessert =>
        item.mealTypes.contains('Dessert') || item.tags.contains('Dessert'),
      FoodCategory.drinks => item.mealTypes.contains('Beverage'),
    };
  }

  // The API spells it both "Snack" and "Snacks".
  static const Set<String> _snackTypes = {'Snack', 'Snacks', 'Appetizer'};
  static const Set<String> _mealTypes = {'Breakfast', 'Lunch', 'Dinner'};

  /// The API has no vegan tag, so an item counts as vegan when no
  /// ingredient names an animal product. Word boundaries keep
  /// "eggplant" from matching "egg".
  static final RegExp _animalProduct = RegExp(
    r'\b(chicken|beef|lamb|pork|bacon|ham|sausage|shrimp|prawns?|fish|'
    r'salmon|tuna|anchov\w*|crab|oyster|eggs?|milk|cream|butter|cheese|'
    r'mozzarella|parmesan|feta|cotija|mascarpone|yogh?urt|ghee|honey|'
    r'mayonnaise|gelatin)\b',
    caseSensitive: false,
  );
}