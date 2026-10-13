import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yum_quick/app/router.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_dimens.dart';
import 'package:yum_quick/app/utils/price_format.dart';
import 'package:yum_quick/core/widgets/app_back_button.dart';
import 'package:yum_quick/core/widgets/empty_view.dart';
import 'package:yum_quick/core/widgets/header_scaffold.dart';
import 'package:yum_quick/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:yum_quick/features/cart/presentation/widgets/price_summary.dart';

/// Order summary and Place Order. Placing an order is local only: it
/// confirms, empties the cart and returns to Home.
class ConfirmOrderScreen extends StatelessWidget {
  const ConfirmOrderScreen({super.key});

  Future<void> _placeOrder(BuildContext context) async {
    final cartCubit = context.read<CartCubit>();
    final router = GoRouter.of(context);

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        icon: const Icon(
          Icons.check_circle_rounded,
          color: AppColors.orangeBase,
          size: 56,
        ),
        title: const Text('Order placed!'),
        content: const Text(
          'Your food is being prepared and will be with you soon.',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Back to menu'),
          ),
        ],
      ),
    );

    router.go(AppRoutes.home);
    await cartCubit.clear();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return HeaderScaffold(
      title: 'Confirm Order',
      leading: const AppBackButton(),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cart = state.cart;

          if (cart.isEmpty) {
            return EmptyView(
              icon: Icons.shopping_bag_outlined,
              title: 'Nothing to order',
              message: 'Your cart is empty.',
              action: FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Browse menu'),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenHorizontal,
              24,
              AppSpacing.screenHorizontal,
              32,
            ),
            children: [
              Text('Order summary', style: textTheme.titleLarge),
              const SizedBox(height: 16),
              for (final item in cart.items)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${item.quantity} ×',
                        style: textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          color: AppColors.orangeBase,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          item.name,
                          style: textTheme.bodyMedium?.copyWith(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        formatPrice(item.lineTotal),
                        style: textTheme.bodyMedium?.copyWith(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              const Divider(height: 32, color: AppColors.orange2),
              PriceSummary(cart: cart),
              const SizedBox(height: 32),
              Center(
                child: FilledButton(
                  key: const Key('place_order'),
                  onPressed: () => _placeOrder(context),
                  child: const Text('Place Order'),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}