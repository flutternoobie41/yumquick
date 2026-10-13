import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/utils/price_format.dart';
import 'package:yum_quick/core/widgets/quantity_selector.dart';
import 'package:yum_quick/features/cart/domain/entities/cart_items.dart';
import 'package:yum_quick/features/cart/presentation/cubit/cart_cubit.dart';

/// One cart line: photo, name, line total and a quantity selector.
class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.item,
    required this.onQuantityChanged,
  });

  final CartItem item;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final quantity = item.quantity;

    return Row(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          child: CachedNetworkImage(
            imageUrl: item.imageUrl,
            width: 72,
            height: 72,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                const ColoredBox(color: AppColors.orange2),
            errorWidget: (context, url, error) =>
                const ColoredBox(color: AppColors.orange2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                formatPrice(item.lineTotal),
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.orangeBase,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        QuantitySelector(
          quantity: quantity,
          onDecrement:
              quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
          onIncrement: quantity < CartCubit.maxQuantity
              ? () => onQuantityChanged(quantity + 1)
              : null,
        ),
      ],
    );
  }
}