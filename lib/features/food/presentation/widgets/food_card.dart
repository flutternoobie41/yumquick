import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_dimens.dart';
import 'package:yum_quick/app/utils/price_format.dart';
import 'package:yum_quick/features/food/domain/entities/food_item.dart';

/// Shared Hero tag, so the image can fly into the detail screen.
String foodImageHeroTag(int id) => 'food-image-$id';

/// Grid card in the style of the design's "Recommend" items: rounded
/// photo with rating and price badges, then name and cook time.
class FoodCard extends StatelessWidget {
  const FoodCard({super.key, required this.item, this.onTap});

  final FoodItem item;
  final VoidCallback? onTap;

  static const double imageHeight = 130;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: onTap,
      borderRadius: const BorderRadius.all(Radius.circular(AppRadius.card)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: imageHeight,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Hero(
                  tag: foodImageHeroTag(item.id),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(AppRadius.card),
                    ),
                    child: Skeleton.replace(
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
                Positioned(
                  left: 8,
                  top: 8,
                  child: _Badge(
                    color: AppColors.white,
                    foreground: AppColors.font,
                    icon: Icons.star_rounded,
                    label: item.rating.toStringAsFixed(1),
                  ),
                ),
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: _Badge(
                    color: AppColors.orangeBase,
                    foreground: AppColors.font2,
                    label: formatPrice(item.price),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(fontSize: 16, height: 1.2),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                size: 14,
                color: AppColors.orangeBase,
              ),
              const SizedBox(width: 4),
              Text('${item.totalMinutes} min', style: textTheme.bodyMedium),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.color,
    required this.foreground,
    required this.label,
    this.icon,
  });

  final Color color;
  final Color foreground;
  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final icon = this.icon;

    return DecoratedBox(
      decoration: ShapeDecoration(color: color, shape: const StadiumBorder()),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: AppColors.yellowBase),
              const SizedBox(width: 2),
            ],
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontSize: 13,
                    color: foreground,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}