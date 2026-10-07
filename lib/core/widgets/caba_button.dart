import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// Primary full-width CabaDZ button — dark green, 16px radius.
class CabaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final Color? color;
  final double? width;

  const CabaButton({
    super.key,
    required this.label,
    this.onTap,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? AppColors.primary;
    final child = isLoading
        ? const SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20, color: isOutlined ? bg : Colors.white),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: AppTextStyles.buttonText.copyWith(
                  color: isOutlined ? bg : Colors.white,
                ),
              ),
            ],
          );

    return SizedBox(
      width: width ?? double.infinity,
      height: 54,
      child: isOutlined
          ? OutlinedButton(
              onPressed: isLoading ? null : onTap,
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: bg, width: 1.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: child,
            )
          : ElevatedButton(
              onPressed: isLoading ? null : onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: bg,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: child,
            ),
    );
  }
}
