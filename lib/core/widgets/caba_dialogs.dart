import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../constants/app_strings.dart';
import 'caba_button.dart';

Future<void> showCabaSuccessDialog(
  BuildContext context, {
  required String title,
  String? subtitle,
  String? confirmLabel,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 84,
              height: 84,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 46,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineMedium,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
            ],
            const SizedBox(height: 24),
            CabaButton(
              label: confirmLabel ?? AppStrings.okAr,
              onTap: () => Navigator.pop(ctx),
            ),
          ],
        ),
      ),
    ),
  );
}

void showCabaErrorSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        message,
        style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
      ),
      backgroundColor: AppColors.error,
    ),
  );
}

Future<bool> showCabaConfirmDialog(
  BuildContext context, {
  required String title,
  String? subtitle,
  String? confirmLabel,
  String? cancelLabel,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineMedium,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium,
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CabaButton(
                    label: cancelLabel ?? AppStrings.cancel,
                    isOutlined: true,
                    onTap: () => Navigator.pop(ctx, false),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CabaButton(
                    label: confirmLabel ?? AppStrings.confirm,
                    onTap: () => Navigator.pop(ctx, true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
  return result == true;
}
