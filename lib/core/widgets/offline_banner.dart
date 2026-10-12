import 'package:flutter/material.dart';
import 'package:yum_quick/app/theme/app_colors.dart';
import 'package:yum_quick/app/theme/app_text_styles.dart';


/// Strip shown above a list when it is showing cached data.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({
    super.key,
    this.message = "You're offline. Showing saved items.",
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      child: ColoredBox(
        color: AppColors.text2,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                size: 18,
                color: AppColors.yellowBase,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.paragraph.copyWith(
                    color: AppColors.font2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}