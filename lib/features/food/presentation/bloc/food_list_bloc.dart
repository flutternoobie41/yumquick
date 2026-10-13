import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yum_quick/core/bloc/transformers.dart';
import 'package:yum_quick/core/error/failure.dart';
import 'package:yum_quick/core/error/result.dart';
import 'package:yum_quick/features/food/domain/entities/food_category.dart';
import 'package:yum_quick/features/food/domain/entities/food_item.dart';
import 'package:yum_quick/features/food/domain/entities/food_query.dart';
import 'package:yum_quick/features/food/domain/repository/food_repository.dart';

part 'food_list_event.dart';
part 'food_list_state.dart';

/// Drives the Home list: first page, infinite scroll, pull-to-refresh,
/// category, sort and debounced search.
class FoodListBloc extends Bloc<FoodListEvent, FoodListState> {
  FoodListBloc({required FoodRepository repository})
      : _repository = repository,
        super(const FoodListState()) {
    on<FoodListStarted>((event, emit) => _load(emit, state.query));
    on<FoodListRefreshed>(_onRefreshed);
    on<FoodListNextPageRequested>(_onNextPage, transformer: droppable());
    on<FoodListCategorySelected>(_onCategorySelected);
    on<FoodListSortChanged>(_onSortChanged);
    on<FoodListSearchChanged>(
      _onSearchChanged,
      transformer: debounceRestartable(const Duration(milliseconds: 400)),
    );
  }

  final FoodRepository _repository;

  /// Bumped on every new query. A response for an older query is dropped,
  /// so a slow request can never overwrite newer results.
  int _requestId = 0;

  Future<void> _onRefreshed(
    FoodListRefreshed event,
    Emitter<FoodListState> emit,
  ) async {
    await _load(emit, state.query, keepItems: true);
    event.completer.complete();
  }

  Future<void> _onCategorySelected(
    FoodListCategorySelected event,
    Emitter<FoodListState> emit,
  ) {
    final query = state.query;
    return _load(
      emit,
      FoodQuery(
        category: event.category,
        sort: query.sort,
        search: query.search,
      ),
    );
  }

  Future<void> _onSortChanged(
    FoodListSortChanged event,
    Emitter<FoodListState> emit,
  ) async {
    final query = state.query;
    if (event.sort == query.sort) {
      return;
    }
    await _load(
      emit,
      FoodQuery(
        category: query.category,
        sort: event.sort,
        search: query.search,
      ),
    );
  }

  Future<void> _onSearchChanged(
    FoodListSearchChanged event,
    Emitter<FoodListState> emit,
  ) async {
    final query = state.query;
    final search = event.text.trim();
    if (search == query.search) {
      return;
    }
    await _load(
      emit,
      FoodQuery(category: query.category, sort: query.sort, search: search),
    );
  }

  Future<void> _onNextPage(
    FoodListNextPageRequested event,
    Emitter<FoodListState> emit,
  ) async {
    if (!state.hasMore || state.status != FoodListStatus.success) {
      return;
    }
    final requestId = _requestId;
    emit(state.copyWith(isLoadingMore: true));

    final result = await _repository.getFoods(
      query: state.query,
      skip: state.items.length,
    );
    if (requestId != _requestId) {
      return;
    }

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            items: [...state.items, ...data.items],
            hasMore: data.hasMore,
            isLoadingMore: false,
          ),
        );
      case Err(:final failure):
        emit(state.copyWith(isLoadingMore: false, failure: failure));
    }
  }

  /// Loads the first page for [query]. With [keepItems] (pull-to-refresh)
  /// the current items stay on screen until the new ones arrive.
  Future<void> _load(
    Emitter<FoodListState> emit,
    FoodQuery query, {
    bool keepItems = false,
  }) async {
    final requestId = ++_requestId;
    final showItems = keepItems && state.items.isNotEmpty;
    emit(
      state.copyWith(
        query: query,
        status: showItems ? state.status : FoodListStatus.loading,
        items: showItems ? state.items : const [],
        isLoadingMore: false,
        // The banner belongs to the items on screen; a new query clears it.
        isOffline: showItems && state.isOffline,
      ),
    );

    final result = await _repository.getFoods(query: query, skip: 0);
    if (requestId != _requestId) {
      return;
    }

    switch (result) {
      case Success(:final data):
        emit(
          state.copyWith(
            status: FoodListStatus.success,
            items: data.items,
            hasMore: data.hasMore,
            isOffline: data.isFromCache,
          ),
        );
      case Err(failure: CancelledFailure()):
        return;
      case Err(:final failure):
        emit(
          state.copyWith(
            status: state.items.isEmpty
                ? FoodListStatus.failure
                : FoodListStatus.success,
            failure: failure,
          ),
        );
    }
  }
}
