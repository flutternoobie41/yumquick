import 'package:equatable/equatable.dart';
import 'package:yum_quick/features/food/domain/entities/food_category.dart';
import 'package:yum_quick/features/food/domain/entities/food_item.dart';

enum FoodSort {
  topRated('Top rated'),
  name('Name A–Z'),
  quickest('Quickest');

  const FoodSort(this.label);

  final String label;
}

/// What the food list is showing: an optional category, a sort order and
/// a search text (empty for no search).
class FoodQuery extends Equatable {
  const FoodQuery({
    this.category,
    this.sort = FoodSort.topRated,
    this.search = '',
  });

  final FoodCategory? category;
  final FoodSort sort;
  final String search;

  @override
  List<Object?> get props => [category, sort, search];
}

/// One page of results.
class FoodPage extends Equatable {
  const FoodPage({
    required this.items,
    required this.hasMore,
    this.isFromCache = false,
  });

  final List<FoodItem> items;
  final bool hasMore;

  /// True when the network was unreachable and these are saved items.
  final bool isFromCache;

  @override
  List<Object?> get props => [items, hasMore, isFromCache];
}