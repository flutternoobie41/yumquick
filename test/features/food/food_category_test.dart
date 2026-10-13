import 'package:flutter_test/flutter_test.dart';
import 'package:yum_quick/features/food/domain/entities/food_category.dart';
import 'package:yum_quick/features/food/domain/entities/food_item.dart';

FoodItem _item({
  List<String> mealTypes = const [],
  List<String> tags = const [],
  List<String> ingredients = const [],
}) {
  return FoodItem(
    id: 1,
    name: 'Test',
    imageUrl: '',
    price: 9.99,
    rating: 4.5,
    reviewCount: 10,
    prepMinutes: 10,
    cookMinutes: 10,
    servings: 2,
    difficulty: 'Easy',
    cuisine: 'Test',
    caloriesPerServing: 200,
    ingredients: ingredients,
    instructions: const [],
    tags: tags,
    mealTypes: mealTypes,
  );
}

void main() {
  group('FoodCategory.matches', () {
    test('snacks accepts both API spellings and appetizers', () {
      expect(FoodCategory.snacks.matches(_item(mealTypes: ['Snack'])), isTrue);
      expect(FoodCategory.snacks.matches(_item(mealTypes: ['Snacks'])), isTrue);
      expect(
        FoodCategory.snacks.matches(_item(mealTypes: ['Appetizer'])),
        isTrue,
      );
      expect(FoodCategory.snacks.matches(_item(mealTypes: ['Dinner'])), isFalse);
    });

    test('dessert matches on meal type or tag', () {
      expect(
        FoodCategory.dessert.matches(_item(mealTypes: ['Dessert'])),
        isTrue,
      );
      expect(FoodCategory.dessert.matches(_item(tags: ['Dessert'])), isTrue);
    });

    test('vegan rejects animal products but not eggplant', () {
      expect(
        FoodCategory.vegan.matches(_item(ingredients: ['Tofu', 'Eggplant'])),
        isTrue,
      );
      expect(
        FoodCategory.vegan.matches(_item(ingredients: ['Tofu', 'Eggs'])),
        isFalse,
      );
      expect(
        FoodCategory.vegan.matches(_item(ingredients: ['Heavy cream'])),
        isFalse,
      );
    });
  });
}