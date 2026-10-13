
import 'package:yum_quick/core/error/error_gaurd.dart';
import 'package:yum_quick/core/error/result.dart';
import 'package:yum_quick/features/food/data/data_source.dart/food_remote_data_source.dart';
import 'package:yum_quick/features/food/domain/entities/food_item.dart';
import 'package:yum_quick/features/food/domain/entities/food_query.dart';
import 'package:yum_quick/features/food/domain/repository/food_repository.dart';


class FoodRepositoryImpl implements FoodRepository {
  FoodRepositoryImpl({required FoodRemoteDataSource remote}) : _remote = remote;

  final FoodRemoteDataSource _remote;

  static const int pageSize = 10;

  @override
  Future<Result<FoodPage>> getFoods({
    required FoodQuery query,
    required int skip,
  }) {
    return guard(() async {
      final category = query.category;

      if (category == null) {
        // Plain list or search: paginate on the server.
        final response = await _remote.fetchRecipes(
          search: query.search,
          sort: query.sort,
          skip: skip,
          limit: pageSize,
        );
        final items = response.recipes.map((r) => r.toEntity()).toList();
        return FoodPage(
          items: items,
          hasMore: skip + items.length < response.total,
        );
      }

      // A category merges several API values (see FoodCategory), so the
      // filter runs on the device. The whole collection is 50 recipes, so
      // one request for all of them replaces pagination here.
      final response = await _remote.fetchRecipes(
        search: query.search,
        sort: query.sort,
        skip: 0,
        limit: 0,
      );
      final items = response.recipes
          .map((r) => r.toEntity())
          .where(category.matches)
          .toList();
      return FoodPage(items: items, hasMore: false);
    });
  }
    @override
  Future<Result<FoodItem>> getFood(int id) {
    return guard(() async => (await _remote.fetchRecipe(id)).toEntity());
  }
}