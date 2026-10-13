import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';

/// Shown while the saved session is being restored.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.orangeBase,
      body: Center(
        child: Text(
          'YUMQUICK',
          style: textTheme.headlineMedium?.copyWith(
            color: AppColors.yellowBase,
            fontSize: 40,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }
}