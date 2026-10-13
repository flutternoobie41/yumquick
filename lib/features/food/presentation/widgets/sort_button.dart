import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/features/food/domain/entities/food_query.dart';

/// "Sort By" menu from the design.
class SortButton extends StatelessWidget {
  const SortButton({super.key, required this.sort, required this.onChanged});

  final FoodSort sort;
  final ValueChanged<FoodSort> onChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PopupMenuButton<FoodSort>(
      initialValue: sort,
      onSelected: onChanged,
      tooltip: 'Sort by',
      itemBuilder: (context) => [
        for (final option in FoodSort.values)
          PopupMenuItem(value: option, child: Text(option.label)),
      ],
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Sort by ', style: textTheme.bodyMedium),
          Text(
            sort.label,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.orangeBase,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(Icons.arrow_drop_down_rounded, color: AppColors.orangeBase),
        ],
      ),
    );
  }
}