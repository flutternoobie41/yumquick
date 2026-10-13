import 'package:flutter/material.dart';
import 'package:yum_quick/core/widgets/header_scaffold.dart';
import 'package:yum_quick/features/food/presentation/widgets/food_listview.dart';
import 'package:yum_quick/features/food/presentation/widgets/home_header.dart';

/// Home: search and greeting in the yellow header, categories, sort and
/// the food grid in the sheet. FoodListBloc is provided by the router.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const HeaderScaffold(
      header: HomeHeader(),
      body: FoodListView(),
    );
  }
}