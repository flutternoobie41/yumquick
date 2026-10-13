import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yum_quick/app/router.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_text_styles.dart';
import 'package:yum_quick/app/utils/price_format.dart';
import 'package:yum_quick/core/widgets/app_back_button.dart';
import 'package:yum_quick/core/widgets/error_view.dart';
import 'package:yum_quick/core/widgets/header_scaffold.dart';
import 'package:yum_quick/core/widgets/quantity_selector.dart';
import 'package:yum_quick/features/cart/domain/entities/cart_items.dart';
import 'package:yum_quick/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:yum_quick/features/food/domain/entities/food_item.dart';
import 'package:yum_quick/features/food/presentation/cubit/food_detail_cubit.dart';
import 'package:yum_quick/features/food/presentation/widgets/food_detail_content.dart';


/// Food detail, designed in the kit's style since the design has none.
class FoodDetailScreen extends StatelessWidget {
  const FoodDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderScaffold(
      title: 'Details',
      leading: const AppBackButton(),
      body: BlocBuilder<FoodDetailCubit, FoodDetailState>(
        builder: (context, state) {
          final item = state.item;
          final failure = state.failure;

          if (item != null) {
            return Column(
              children: [
                Expanded(child: FoodDetailContent(item: item)),
                _AddToCartBar(
                  item: item,
                  quantity: state.quantity,
                  total: state.total,
                ),
              ],
            );
          }
          if (failure != null) {
            return ErrorView(
              failure: failure,
              onRetry: context.read<FoodDetailCubit>().load,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _AddToCartBar extends StatelessWidget {
  const _AddToCartBar({
    required this.item,
    required this.quantity,
    required this.total,
  });

  final FoodItem item;
  final int quantity;
  final double total;

  void _addToCart(BuildContext context) {
    context.read<CartCubit>().add(
          CartItem(
            foodId: item.id,
            name: item.name,
            imageUrl: item.imageUrl,
            unitPrice: item.price,
            quantity: quantity,
          ),
        );
    final router = GoRouter.of(context);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('Added $quantity × ${item.name}'),
          action: SnackBarAction(
            label: 'View cart',
            onPressed: () => router.push(AppRoutes.cart),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<FoodDetailCubit>();

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
          child: Row(
            children: [
              QuantitySelector(
                quantity: quantity,
                onDecrement: quantity > 1 ? cubit.decrement : null,
                onIncrement: quantity < FoodDetailCubit.maxQuantity
                    ? cubit.increment
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: FilledButton(
                  key: const Key('add_to_cart'),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    textStyle: AppTextStyles.button.copyWith(fontSize: 18),
                  ),
                  onPressed: () => _addToCart(context),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Add to Cart · ${formatPrice(total)}',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
