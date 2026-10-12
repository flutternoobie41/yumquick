import 'package:flutter/material.dart';
import 'package:food_delivery/app/theme/app_colors.dart';
import 'package:food_delivery/app/theme/app_dimens.dart';
import 'package:food_delivery/app/theme/app_text_styles.dart';

/// Material 3 theme built from the Figma tokens.
///
/// Only component themes with a stable `*ThemeData` type are set here.
/// Inputs and headers get their own widgets, which keeps the theme free
/// of APIs that changed shape across recent Flutter releases.
abstract final class AppTheme {
  static final ThemeData light = _buildLight();

  static ThemeData _buildLight() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.orangeBase,
      primary: AppColors.orangeBase,
      onPrimary: AppColors.font2,
      primaryContainer: AppColors.orange2,
      onPrimaryContainer: AppColors.orangeBase,
      secondary: AppColors.yellowBase,
      onSecondary: AppColors.font,
      secondaryContainer: AppColors.yellow2,
      onSecondaryContainer: AppColors.font,
      surface: AppColors.font2,
      onSurface: AppColors.font,
      error: AppColors.error,
    );

    // Material 3 is the default since Flutter 3.16.
    final base = ThemeData(
      colorScheme: colorScheme,
      fontFamily: AppTextStyles.fontFamily,
    );

    final textTheme = base.textTheme
        .merge(
          const TextTheme(
            headlineMedium: AppTextStyles.screenTitle,
            titleLarge: AppTextStyles.sectionTitle,
            titleMedium: AppTextStyles.subtitle,
            labelLarge: AppTextStyles.button,
            labelMedium: AppTextStyles.chip,
            bodyMedium: AppTextStyles.paragraph,
          ),
        )
        .apply(bodyColor: AppColors.font, displayColor: AppColors.font);

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.font2,
      textTheme: textTheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.orangeBase,
          foregroundColor: AppColors.font2,
          // The design's "Inactive" button: Orange 2 fill, orange label.
          disabledBackgroundColor: AppColors.orange2,
          disabledForegroundColor: AppColors.orangeBase,
          minimumSize: const Size(207, 45),
          shape: const StadiumBorder(),
          textStyle: AppTextStyles.button,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.orangeBase),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.orange2,
        selectedColor: AppColors.orangeBase,
        labelStyle: AppTextStyles.chip.copyWith(
          color: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.font2
                : AppColors.orangeBase,
          ),
        ),
        side: BorderSide.none,
        shape: const StadiumBorder(),
        showCheckmark: false,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.text2,
        contentTextStyle: AppTextStyles.paragraph.copyWith(
          color: AppColors.font2,
          fontWeight: FontWeight.w400,
        ),
        actionTextColor: AppColors.yellowBase,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.card)),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.orangeBase,
      ),
    );
  }
}
