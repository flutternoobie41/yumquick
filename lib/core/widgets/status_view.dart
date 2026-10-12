import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_dimens.dart';


/// Centered icon, title, message and optional action, in the YumQuick
/// style. Base for the empty and error screens, which the design leaves
/// to us.
class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.action,
  });

  final IconData icon;
  final String title;
  final String? message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final message = this.message;
    final action = this.action;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenHorizontal,
          vertical: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: const BoxDecoration(
                color: AppColors.orange2,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppColors.orangeBase),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (message != null) ...[
              const SizedBox(height: 12),
              Text(
                message,
                style: textTheme.bodyMedium?.copyWith(height: 1.4),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              const SizedBox(height: 24),
              action,
            ],
          ],
        ),
      ),
    );
  }
}