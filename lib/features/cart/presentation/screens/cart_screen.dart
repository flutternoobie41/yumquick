import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:yum_quick/app/router.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_dimens.dart';
import 'package:yum_quick/core/widgets/app_back_button.dart';
import 'package:yum_quick/core/widgets/empty_view.dart';
import 'package:yum_quick/core/widgets/header_scaffold.dart';
import 'package:yum_quick/features/cart/domain/entities/cart.dart';
import 'package:yum_quick/features/cart/domain/entities/cart_items.dart';
import 'package:yum_quick/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:yum_quick/features/cart/presentation/widgets/cart_item_tile.dart';
import 'package:yum_quick/features/cart/presentation/widgets/price_summary.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return HeaderScaffold(
      title: 'Cart',
      leading: const AppBackButton(),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          final cart = state.cart;

          if (cart.isEmpty) {
            return EmptyView(
              icon: Icons.shopping_bag_outlined,
              title: 'Your cart is empty',
              message: 'Add something tasty from the menu.',
              action: FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: const Text('Browse menu'),
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenHorizontal,
                    24,
                    AppSpacing.screenHorizontal,
                    24,
                  ),
                  itemCount: cart.items.length,
                  separatorBuilder: (context, index) =>
                      const Divider(height: 24, color: AppColors.orange2),
                  itemBuilder: (context, index) =>
                      _DismissibleLine(item: cart.items[index]),
                ),
              ),
              _CheckoutPanel(cart: cart),
            ],
          );
        },
      ),
    );
  }
}

/// Swipe left to remove, with an Undo snackbar.
class _DismissibleLine extends StatelessWidget {
  const _DismissibleLine({required this.item});

  final CartItem item;

  void _remove(BuildContext context) {
    final cubit = context.read<CartCubit>()..remove(item.foodId);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${item.name} removed'),
          action: SnackBarAction(label: 'Undo', onPressed: cubit.undoRemove),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.foodId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => _remove(context),
      background: const DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.orangeBase,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete_outline_rounded, color: AppColors.font2),
          ),
        ),
      ),
      child: CartItemTile(
        item: item,
        onQuantityChanged: (quantity) =>
            context.read<CartCubit>().setQuantity(item.foodId, quantity),
      ),
    );
  }
}

class _CheckoutPanel extends StatelessWidget {
  const _CheckoutPanel({required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.sheet),
        ),
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
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenHorizontal,
            20,
            AppSpacing.screenHorizontal,
            16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PriceSummary(cart: cart),
              const SizedBox(height: 16),
              FilledButton(
                key: const Key('checkout'),
                // The design's Checkout button: yellow pill, orange label.
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.yellowBase,
                  foregroundColor: AppColors.orangeBase,
                ),
                onPressed: () => context.push(AppRoutes.confirmOrder),
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}