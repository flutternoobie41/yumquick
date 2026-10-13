import 'package:dio/dio.dart';
import 'package:yum_quick/core/network/api_endpoints.dart';
import 'package:yum_quick/features/food/data/models/recipe_model.dart';
import 'package:yum_quick/features/food/domain/entities/food_query.dart';

/// Talks to DummyJSON's recipe endpoints. Throws [DioException] or
/// [FormatException]; the repository maps those to failures.
class FoodRemoteDataSource {
  FoodRemoteDataSource(this._dio);

  final Dio _dio;

  /// Fetches recipes, searching when [search] is not empty.
  /// A [limit] of 0 returns every recipe (DummyJSON convention).
  Future<RecipesResponseModel> fetchRecipes({
    required String search,
    required FoodSort sort,
    required int skip,
    required int limit,
  }) async {
    final (sortBy, order) = switch (sort) {
      FoodSort.topRated => ('rating', 'desc'),
      FoodSort.name => ('name', 'asc'),
      FoodSort.quickest => ('cookTimeMinutes', 'asc'),
    };

    final response = await _dio.get<Map<String, dynamic>>(
      search.isEmpty ? ApiEndpoints.recipes : ApiEndpoints.searchRecipes,
      queryParameters: {
        if (search.isNotEmpty) 'q': search,
        'skip': skip,
        'limit': limit,
        'sortBy': sortBy,
        'order': order,
      },
    );

    final body = response.data ?? (throw const FormatException('Empty body'));
    return RecipesResponseModel.fromJson(body);
  }

  Future<RecipeModel> fetchRecipe(int id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      ApiEndpoints.recipe(id),
    );
    final body = response.data ?? (throw const FormatException('Empty body'));
    return RecipeModel.fromJson(body);
  }
}
