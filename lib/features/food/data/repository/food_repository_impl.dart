import 'package:yum_quick/core/error/error_gaurd.dart';
import 'package:yum_quick/core/error/failure.dart';
import 'package:yum_quick/core/error/result.dart';
import 'package:yum_quick/features/food/data/data_source.dart/food_local_data_source.dart';
import 'package:yum_quick/features/food/data/data_source.dart/food_remote_data_source.dart';
import 'package:yum_quick/features/food/data/models/recipe_model.dart';
import 'package:yum_quick/features/food/domain/entities/food_item.dart';
import 'package:yum_quick/features/food/domain/entities/food_query.dart';
import 'package:yum_quick/features/food/domain/repository/food_repository.dart';


class FoodRepositoryImpl implements FoodRepository {
  FoodRepositoryImpl({
    required FoodRemoteDataSource remote,
    required FoodLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final FoodRemoteDataSource _remote;
  final FoodLocalDataSource _local;

  static const int pageSize = 10;

  @override
  Future<Result<FoodPage>> getFoods({
    required FoodQuery query,
    required int skip,
  }) async {
    // Only the first page of the default list (the screen the app opens
    // on) is cached for offline use.
    final isCacheable = skip == 0 && query == const FoodQuery();

    final result = await guard(() => _fetch(query, skip));
    switch (result) {
      case Success(:final data):
        if (isCacheable) {
          // Best effort: a failed cache write must not hide fresh results.
          await guard(() => _local.writeFirstPage(data.recipes));
        }
        return Success(data.page);
      case Err(:final failure):
        if (isCacheable && failure is NetworkFailure) {
          return _cachedFirstPage(failure);
        }
        return Err(failure);
    }
  }

  @override
  Future<Result<FoodItem>> getFood(int id) {
    return guard(() async => (await _remote.fetchRecipe(id)).toEntity());
  }

  /// Fetches one page. Also returns the raw recipes, so the first page
  /// can be cached as received.
  Future<({List<RecipeModel> recipes, FoodPage page})> _fetch(
    FoodQuery query,
    int skip,
  ) async {
    final category = query.category;

    if (category == null) {
      // Plain list or search: paginate on the server.
      final response = await _remote.fetchRecipes(
        search: query.search,
        sort: query.sort,
        skip: skip,
        limit: pageSize,
      );
      final recipes = response.recipes;
      return (
        recipes: recipes,
        page: FoodPage(
          items: _toItems(recipes),
          hasMore: skip + recipes.length < response.total,
        ),
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
    final items = _toItems(response.recipes).where(category.matches).toList();
    return (
      recipes: response.recipes,
      page: FoodPage(items: items, hasMore: false),
    );
  }

  /// Offline fallback: the saved first page, or the original failure when
  /// nothing has been saved yet.
  Future<Result<FoodPage>> _cachedFirstPage(Failure failure) async {
    final cached = await guard(() async => _local.readFirstPage());
    if (cached case Success(data: final recipes?) when recipes.isNotEmpty) {
      return Success(
        FoodPage(items: _toItems(recipes), hasMore: false, isFromCache: true),
      );
    }
    return Err(failure);
  }

  static List<FoodItem> _toItems(List<RecipeModel> recipes) {
    return [for (final recipe in recipes) recipe.toEntity()];
  }
}