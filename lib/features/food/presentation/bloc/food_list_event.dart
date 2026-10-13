part of 'food_list_bloc.dart';





sealed class FoodListEvent extends Equatable {
  const FoodListEvent();

  @override
  List<Object?> get props => [];
}

/// First load, and retry after an error.
final class FoodListStarted extends FoodListEvent {
  const FoodListStarted();
}

/// Pull-to-refresh. [completer] finishes when the load ends, so the
/// refresh indicator knows when to hide.
final class FoodListRefreshed extends FoodListEvent {
  const FoodListRefreshed(this.completer);

  final Completer<void> completer;
}

/// The user scrolled near the end of the list.
final class FoodListNextPageRequested extends FoodListEvent {
  const FoodListNextPageRequested();
}

/// `null` shows every category.
final class FoodListCategorySelected extends FoodListEvent {
  const FoodListCategorySelected(this.category);

  final FoodCategory? category;

  @override
  List<Object?> get props => [category];
}

final class FoodListSortChanged extends FoodListEvent {
  const FoodListSortChanged(this.sort);

  final FoodSort sort;

  @override
  List<Object?> get props => [sort];
}

final class FoodListSearchChanged extends FoodListEvent {
  const FoodListSearchChanged(this.text);

  final String text;

  @override
  List<Object?> get props => [text];
}