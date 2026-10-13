import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_dimens.dart';

/// The design's page layout: a Yellow Base header and a light content
/// sheet with rounded top corners below it.
///
/// Pass [title] for the standard centred title, or [header] for a custom
/// header such as Home's search bar and greeting.
class HeaderScaffold extends StatelessWidget {
  const HeaderScaffold({
    super.key,
    required this.body,
    this.title,
    this.header,
    this.leading,
  }) : assert(title != null || header != null, 'Pass a title or a header');

  final Widget body;
  final String? title;
  final Widget? header;

  /// Optional widget on the left of the title, usually a back button.
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final header = this.header;

    return Scaffold(
      backgroundColor: AppColors.yellowBase,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            header ?? _TitleBar(title: title ?? '', leading: leading),
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

class _TitleBar extends StatelessWidget {
  const _TitleBar({required this.title, this.leading});

  final String title;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final leading = this.leading;

    return SizedBox(
      height: 88,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            title,
            style: textTheme.headlineMedium?.copyWith(color: AppColors.font2),
          ),
          if (leading != null)
            Positioned(
              left: AppSpacing.screenHorizontal - 12,
              child: leading,
            ),
        ],
      ),
    );
  }
}