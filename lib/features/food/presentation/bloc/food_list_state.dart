part of 'food_list_bloc.dart';

enum FoodListStatus { loading, success, failure }

/// One state class (not sealed subclasses) so loaded items survive while
/// the next page loads or a refresh runs.
final class FoodListState extends Equatable {
  const FoodListState({
    this.status = FoodListStatus.loading,
    this.query = const FoodQuery(),
    this.items = const [],
    this.hasMore = false,
    this.isLoadingMore = false,
    this.failure,
  });

  final FoodListStatus status;
  final FoodQuery query;
  final List<FoodItem> items;
  final bool hasMore;
  final bool isLoadingMore;

  /// The latest error. With no items the screen shows an error view;
  /// with items it is shown as a snackbar.
  final Failure? failure;

  /// [failure] is not carried over: every new state clears it unless one
  /// is passed, so an error is reported exactly once.
  FoodListState copyWith({
    FoodListStatus? status,
    FoodQuery? query,
    List<FoodItem>? items,
    bool? hasMore,
    bool? isLoadingMore,
    Failure? failure,
  }) {
    return FoodListState(
      status: status ?? this.status,
      query: query ?? this.query,
      items: items ?? this.items,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      failure: failure,
    );
  }

  @override
  List<Object?> get props =>
      [status, query, items, hasMore, isLoadingMore, failure];
}