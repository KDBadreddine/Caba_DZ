import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../app/theme.dart';

class CabaAvatar extends StatelessWidget {
  final String? imageUrl;
  final String fallback;
  final double radius;

  const CabaAvatar({
    super.key,
    this.imageUrl,
    required this.fallback,
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    final letter = fallback.isNotEmpty ? fallback[0] : '?';
    final placeholder = CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryLight,
      child: Text(
        letter,
        style: AppTextStyles.titleMedium.copyWith(
          color: AppColors.primary,
          fontSize: radius * 0.72,
        ),
      ),
    );

    if (imageUrl == null || imageUrl!.isEmpty) return placeholder;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryLight,
      child: ClipOval(
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          placeholder: (_, _) => placeholder,
          errorWidget: (_, _, _) => placeholder,
        ),
      ),
    );
  }
}
