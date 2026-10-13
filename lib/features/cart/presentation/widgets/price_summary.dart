import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/utils/price_format.dart';
import 'package:yum_quick/features/cart/domain/entities/cart.dart';

/// Subtotal, tax and fees, delivery and total, as in the design's cart.
class PriceSummary extends StatelessWidget {
  const PriceSummary({super.key, required this.cart});

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PriceRow(label: 'Subtotal', amount: cart.subtotal),
        _PriceRow(label: 'Tax and fees', amount: cart.taxAndFees),
        _PriceRow(label: 'Delivery', amount: cart.delivery),
        const Divider(height: 24, color: AppColors.orange2),
        _PriceRow(label: 'Total', amount: cart.total, isTotal: true),
      ],
    );
  }
}

class _PriceRow extends StatelessWidget {
  const _PriceRow({
    required this.label,
    required this.amount,
    this.isTotal = false,
  });

  final String label;
  final double amount;
  final bool isTotal;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final style = isTotal
        ? textTheme.titleMedium
        : textTheme.bodyMedium?.copyWith(fontSize: 16);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(formatPrice(amount), style: style),
        ],
      ),
    );
  }
}