import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';

/// − quantity + control. Pass `null` for a callback to disable that button.
class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _RoundButton(
          icon: Icons.remove_rounded,
          tooltip: 'Decrease quantity',
          onPressed: onDecrement,
        ),
        SizedBox(
          width: 36,
          child: Text(
            '$quantity',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        _RoundButton(
          icon: Icons.add_rounded,
          tooltip: 'Increase quantity',
          onPressed: onIncrement,
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon, size: 20),
      style: IconButton.styleFrom(
        backgroundColor: AppColors.orangeBase,
        foregroundColor: AppColors.font2,
        disabledBackgroundColor: AppColors.orange2,
        disabledForegroundColor: AppColors.orangeBase,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}