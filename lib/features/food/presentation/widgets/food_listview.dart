import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_dimens.dart';
import 'package:yum_quick/core/widgets/empty_view.dart';
import 'package:yum_quick/core/widgets/error_view.dart';
import 'package:yum_quick/features/food/domain/entities/food_item.dart';
import 'package:yum_quick/features/food/presentation/bloc/food_list_bloc.dart';
import 'package:yum_quick/features/food/presentation/widgets/category_selector.dart';
import 'package:yum_quick/features/food/presentation/widgets/food_card.dart';
import 'package:yum_quick/features/food/presentation/widgets/sort_button.dart';

/// Home's scrollable content: categories, sort, and the food grid with
/// skeleton loading, pull-to-refresh, infinite scroll, and empty and
/// error states.
class FoodListView extends StatefulWidget {
  const FoodListView({super.key});

  @override
  State<FoodListView> createState() => _FoodListViewState();
}

class _FoodListViewState extends State<FoodListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 400) {
      context.read<FoodListBloc>().add(const FoodListNextPageRequested());
    }
  }

  Future<void> _refresh() {
    final completer = Completer<void>();
    context.read<FoodListBloc>().add(FoodListRefreshed(completer));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<FoodListBloc>();

    return BlocConsumer<FoodListBloc, FoodListState>(
      listenWhen: (previous, current) =>
          current.failure != null &&
          current.failure != previous.failure &&
          current.items.isNotEmpty,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.failure!.message)));
      },
      builder: (context, state) {
        return RefreshIndicator(
          color: AppColors.orangeBase,
          onRefresh: _refresh,
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  24,
                  AppSpacing.screenHorizontal,
                  8,
                ),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    children: [
                      CategorySelector(
                        selected: state.query.category,
                        onChanged: (category) =>
                            bloc.add(FoodListCategorySelected(category)),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SortButton(
                          sort: state.query.sort,
                          onChanged: (sort) =>
                              bloc.add(FoodListSortChanged(sort)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ..._content(state, bloc),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _content(FoodListState state, FoodListBloc bloc) {
    if (state.status == FoodListStatus.loading) {
      return const [_SkeletonGrid()];
    }

    final failure = state.failure;
    if (state.status == FoodListStatus.failure && failure != null) {
      return [
        SliverFillRemaining(
          hasScrollBody: false,
          child: ErrorView(
            failure: failure,
            onRetry: () => bloc.add(const FoodListStarted()),
          ),
        ),
      ];
    }

    if (state.items.isEmpty) {
      return const [
        SliverFillRemaining(
          hasScrollBody: false,
          child: EmptyView(
            title: 'No dishes found',
            message: 'Try another category or a different search.',
          ),
        ),
      ];
    }

    return [
      _FoodGrid(items: state.items),
      if (state.isLoadingMore)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      const SliverToBoxAdapter(child: SizedBox(height: 24)),
    ];
  }
}

/// Fake items shown under the skeleton while the first page loads.
final List<FoodItem> _placeholders = List.generate(
  6,
  (index) => FoodItem(
    id: -index,
    name: 'Loading dish name',
    imageUrl: '',
    price: 9.99,
    rating: 4.5,
    reviewCount: 0,
    prepMinutes: 10,
    cookMinutes: 20,
    servings: 2,
    difficulty: '',
    cuisine: '',
    caloriesPerServing: 0,
    ingredients: const [],
    instructions: const [],
    tags: const [],
    mealTypes: const [],
  ),
);

const _gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  mainAxisSpacing: 16,
  crossAxisSpacing: 16,
  mainAxisExtent: FoodCard.imageHeight + 88,
);

const _gridPadding = EdgeInsets.symmetric(
  horizontal: AppSpacing.screenHorizontal,
);

class _FoodGrid extends StatelessWidget {
  const _FoodGrid({required this.items});

  final List<FoodItem> items;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: _gridPadding,
      sliver: SliverGrid(
        gridDelegate: _gridDelegate,
        delegate: SliverChildBuilderDelegate(
          (context, index) => FoodCard(item: items[index]),
          childCount: items.length,
        ),
      ),
    );
  }
}

/// Placeholder cards rendered as skeleton bones while the first page loads.
class _SkeletonGrid extends StatelessWidget {
  const _SkeletonGrid();

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Skeletonizer(
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: _gridPadding,
          gridDelegate: _gridDelegate,
          itemCount: _placeholders.length,
          itemBuilder: (context, index) => FoodCard(item: _placeholders[index]),
        ),
      ),
    );
  }
}