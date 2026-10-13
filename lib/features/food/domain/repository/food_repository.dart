import 'package:yum_quick/core/error/result.dart';
import 'package:yum_quick/features/food/domain/entities/food_item.dart';
import 'package:yum_quick/features/food/domain/entities/food_query.dart';

abstract interface class FoodRepository {
  /// Loads the page of items for [query] starting at [skip].
  Future<Result<FoodPage>> getFoods({
    required FoodQuery query,
    required int skip,
  });
    /// Loads one item by id, for the detail screen.
  Future<Result<FoodItem>> getFood(int id);
}