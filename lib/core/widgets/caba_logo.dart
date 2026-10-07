import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../constants/app_images.dart';
import '../constants/app_strings.dart';

/// Official CabaDZ mark: green C with flight path and pin.
class CabaLogo extends StatelessWidget {
  final double size;

  const CabaLogo({
    super.key,
    this.size = 72,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      AppImages.logo,
      width: size,
      height: size,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
    );
  }
}

/// Horizontal wordmark used on login and compact headers.
class CabaWordmark extends StatelessWidget {
  final double logoSize;
  final bool showSlogan;
  final Color color;

  const CabaWordmark({
    super.key,
    this.logoSize = 40,
    this.showSlogan = true,
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CabaLogo(size: logoSize),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.appName,
              style: AppTextStyles.headlineLarge.copyWith(
                color: color,
                fontSize: 22,
                height: 1.1,
              ),
            ),
            if (showSlogan)
              Text(
                AppStrings.sloganAr,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
