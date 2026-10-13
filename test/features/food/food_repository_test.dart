import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yum_quick/core/error/failure.dart';
import 'package:yum_quick/core/error/result.dart';
import 'package:yum_quick/features/food/data/data_source.dart/food_local_data_source.dart';
import 'package:yum_quick/features/food/data/data_source.dart/food_remote_data_source.dart';
import 'package:yum_quick/features/food/data/models/recipe_model.dart';
import 'package:yum_quick/features/food/data/repository/food_repository_impl.dart';
import 'package:yum_quick/features/food/domain/entities/food_query.dart';

class _MockRemote extends Mock implements FoodRemoteDataSource {}

class _MockLocal extends Mock implements FoodLocalDataSource {}

const _recipe = RecipeModel(
  id: 1,
  name: 'Pizza',
  image: '',
  rating: 4.5,
  reviewCount: 10,
  prepTimeMinutes: 10,
  cookTimeMinutes: 15,
  servings: 2,
  difficulty: 'Easy',
  cuisine: 'Italian',
  caloriesPerServing: 300,
  ingredients: [],
  instructions: [],
  tags: [],
  mealType: ['Dinner'],
);

void main() {
  late _MockRemote remote;
  late _MockLocal local;
  late FoodRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(FoodSort.topRated);
    registerFallbackValue(<RecipeModel>[]);
  });

  setUp(() {
    remote = _MockRemote();
    local = _MockLocal();
    repository = FoodRepositoryImpl(remote: remote, local: local);
    when(() => local.writeFirstPage(any())).thenAnswer((_) async {});
  });

  void whenFetch(Future<RecipesResponseModel> Function() answer) {
    when(
      () => remote.fetchRecipes(
        search: any(named: 'search'),
        sort: any(named: 'sort'),
        skip: any(named: 'skip'),
        limit: any(named: 'limit'),
      ),
    ).thenAnswer((_) => answer());
  }

  DioException dioError(DioExceptionType type, {int? statusCode}) {
    final options = RequestOptions(path: '/auth/recipes');
    return DioException(
      requestOptions: options,
      type: type,
      response: statusCode == null
          ? null
          : Response<dynamic>(requestOptions: options, statusCode: statusCode),
    );
  }

  group('FoodRepositoryImpl.getFoods', () {
    test('returns the first page and caches it for offline use', () async {
      whenFetch(
        () async => const RecipesResponseModel(
          recipes: [_recipe],
          total: 1,
          skip: 0,
          limit: 10,
        ),
      );

      final result = await repository.getFoods(
        query: const FoodQuery(),
        skip: 0,
      );

      expect(
        result,
        Success(FoodPage(items: [_recipe.toEntity()], hasMore: false)),
      );
      verify(() => local.writeFirstPage([_recipe])).called(1);
    });

    test('serves the cached page when the network is down', () async {
      whenFetch(() => throw dioError(DioExceptionType.connectionError));
      when(() => local.readFirstPage()).thenReturn([_recipe]);

      final result = await repository.getFoods(
        query: const FoodQuery(),
        skip: 0,
      );

      expect(
        result,
        Success(
          FoodPage(
            items: [_recipe.toEntity()],
            hasMore: false,
            isFromCache: true,
          ),
        ),
      );
    });

    test('reports the network failure when nothing is cached', () async {
      whenFetch(() => throw dioError(DioExceptionType.connectionError));
      when(() => local.readFirstPage()).thenReturn(null);

      final result = await repository.getFoods(
        query: const FoodQuery(),
        skip: 0,
      );

      expect(result, const Err<FoodPage>(NetworkFailure()));
    });

    test('does not hide a 401 behind the cache', () async {
      whenFetch(
        () => throw dioError(DioExceptionType.badResponse, statusCode: 401),
      );

      final result = await repository.getFoods(
        query: const FoodQuery(),
        skip: 0,
      );

      expect(result, const Err<FoodPage>(UnauthorizedFailure()));
      verifyNever(() => local.readFirstPage());
    });

    test('does not cache searches', () async {
      whenFetch(
        () async => const RecipesResponseModel(
          recipes: [_recipe],
          total: 1,
          skip: 0,
          limit: 10,
        ),
      );

      await repository.getFoods(
        query: const FoodQuery(search: 'pizza'),
        skip: 0,
      );

      verifyNever(() => local.writeFirstPage(any()));
    });
  });
}