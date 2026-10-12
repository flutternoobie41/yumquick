import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_theme.dart';

/// Root widget of the app.
///
/// Routing and dependency injection are wired in here as the matching
/// phases land.
class YumQUickApp extends StatelessWidget {
  const YumQUickApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YumQuick',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const _LaunchPlaceholder(),
    );
  }
}

/// Temporary first screen in the style of the design's launch screen.
/// Replaced by the router and the login flow in Phase 2.
class _LaunchPlaceholder extends StatelessWidget {
  const _LaunchPlaceholder();

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
