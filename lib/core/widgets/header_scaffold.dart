import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_dimens.dart';

/// The design's page layout: a Yellow Base header with a centred title,
/// and a light content sheet with rounded top corners below it.
class HeaderScaffold extends StatelessWidget {
  const HeaderScaffold({
    super.key,
    required this.title,
    required this.body,
    this.leading,
  });

  final String title;
  final Widget body;

  /// Optional widget on the left of the title, usually a back button.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final leading = this.leading;

    return Scaffold(
      backgroundColor: AppColors.yellowBase,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: 88,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Text(
                    title,
                    style: textTheme.headlineMedium?.copyWith(
                      color: AppColors.font2,
                    ),
                  ),
                  if (leading != null)
                    Positioned(
                      left: AppSpacing.screenHorizontal - 12,
                      child: leading,
                    ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: AppColors.font2,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadius.sheet),
                  ),
                ),
                child: body,
              ),
            ),
          ],
        ),
      ),
    );
  }
}