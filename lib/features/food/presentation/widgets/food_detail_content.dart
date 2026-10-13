import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_dimens.dart';
import 'package:yum_quick/app/utils/price_format.dart';

import 'package:yum_quick/features/food/domain/entities/food_item.dart';
import 'package:yum_quick/features/food/presentation/widgets/food_card.dart';

/// Scrollable detail body: hero image, name and price, key facts,
/// ingredients and steps.
class FoodDetailContent extends StatelessWidget {
  const FoodDetailContent({super.key, required this.item});

  final FoodItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenHorizontal,
        24,
        AppSpacing.screenHorizontal,
        24,
      ),
      children: [
        Hero(
          tag: foodImageHeroTag(item.id),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(
              Radius.circular(AppRadius.card),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 11,
              child: CachedNetworkImage(
                imageUrl: item.imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const ColoredBox(color: AppColors.orange2),
                errorWidget: (context, url, error) => const ColoredBox(
                  color: AppColors.orange2,
                  child: Icon(
                    Icons.restaurant_rounded,
                    color: AppColors.orangeBase,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: Text(item.name, style: textTheme.titleLarge)),
            const SizedBox(width: 12),
            Text(
              formatPrice(item.price),
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.orangeBase,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _InfoChip(
              icon: Icons.star_rounded,
              label: '${item.rating.toStringAsFixed(1)} '
                  '(${item.reviewCount} reviews)',
            ),
            _InfoChip(
              icon: Icons.schedule_rounded,
              label: '${item.totalMinutes} min',
            ),
            _InfoChip(
              icon: Icons.local_fire_department_outlined,
              label: '${item.caloriesPerServing} kcal',
            ),
            _InfoChip(
              icon: Icons.signal_cellular_alt_rounded,
              label: item.difficulty,
            ),
          ],
        ),
        const Divider(height: 40, color: AppColors.orange2),
        Text('Ingredients', style: textTheme.titleMedium),
        const SizedBox(height: 12),
        for (final ingredient in item.ingredients)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 5, right: 10),
                  child: Icon(
                    Icons.circle,
                    size: 6,
                    color: AppColors.orangeBase,
                  ),
                ),
                Expanded(
                  child: Text(
                    ingredient,
                    style: textTheme.bodyMedium?.copyWith(height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        Text('Instructions', style: textTheme.titleMedium),
        const SizedBox(height: 12),
        for (final (index, step) in item.instructions.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundColor: AppColors.orange2,
                  child: Text(
                    '${index + 1}',
                    style: textTheme.labelMedium?.copyWith(
                      fontSize: 13,
                      color: AppColors.orangeBase,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    step,
                    style: textTheme.bodyMedium?.copyWith(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const ShapeDecoration(
        color: AppColors.yellow2,
        shape: StadiumBorder(),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppColors.orangeBase),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}