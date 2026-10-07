import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'caba_button.dart';

class CabaEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final bool compact;

  const CabaEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = compact ? 56.0 : 80.0;
    final iconSize = compact ? 28.0 : 38.0;
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: compact ? 12 : 32,
        horizontal: 16,
      ),
      child: Column(
        mainAxisAlignment:
            compact ? MainAxisAlignment.start : MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: iconSize, color: AppColors.primary),
          ),
          SizedBox(height: compact ? 12 : 18),
          Text(
            title,
            textAlign: TextAlign.center,
            style: compact
                ? AppTextStyles.titleMedium
                : AppTextStyles.headlineMedium,
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 6),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
          ],
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: compact ? 14 : 20),
            CabaButton(
              label: actionLabel!,
              onTap: onAction,
              isOutlined: compact,
              width: compact ? 160 : null,
            ),
          ],
        ],
      ),
    );
  }
}
