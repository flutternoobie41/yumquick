import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_icons.dart';
import 'package:yum_quick/core/widgets/app_svg_icon.dart';
import 'package:yum_quick/features/food/domain/entities/food_category.dart';

/// The design's row of category icons. Tapping the selected category
/// again clears the filter.
class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final FoodCategory? selected;
  final ValueChanged<FoodCategory?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (final category in FoodCategory.values)
          _CategoryButton(
            category: category,
            isSelected: category == selected,
            onTap: () => onChanged(category == selected ? null : category),
          ),
      ],
    );
  }
}

class _CategoryButton extends StatelessWidget {
  const _CategoryButton({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  final FoodCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Semantics(
      button: true,
      selected: isSelected,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 50,
              height: 62,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.orangeBase : AppColors.yellow2,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
              ),
              alignment: Alignment.center,
              child: AppSvgIcon(
                _iconFor(category),
                size: 34,
                color: isSelected ? AppColors.font2 : AppColors.orangeBase,
              ),
            ),
            const SizedBox(height: 6),
            Text(category.label, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

 static String _iconFor(FoodCategory category) {
    return switch (category) {
      FoodCategory.snacks => AppIcons.snacks,
      FoodCategory.meal => AppIcons.meal,
      FoodCategory.vegan => AppIcons.vegan,
      FoodCategory.dessert => AppIcons.dessert,
      FoodCategory.drinks => AppIcons.drinks,
    };
  }
}