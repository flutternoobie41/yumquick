import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:yum_quick/app/theme/app_colors.dart';

/// Back arrow for [HeaderScaffold] pages. When there is nothing to pop
/// (the page was opened directly by URL), it goes to Home instead.
class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/');
        }
      },
      icon: const Icon(
        Icons.arrow_back_ios_new_rounded,
        color: AppColors.orangeBase,
      ),
    );
  }
}