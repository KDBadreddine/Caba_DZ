import 'package:caba_dz/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../models/shipment_model.dart';
import 'caba_avatar.dart';
import 'caba_country_label.dart';

class ShipmentCard extends StatelessWidget {
  final ShipmentModel shipment;
  final VoidCallback? onTap;
  final bool showFav;

  const ShipmentCard({
    super.key,
    required this.shipment,
    this.onTap,
    this.showFav = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CabaAvatar(
              imageUrl: shipment.sender.avatarUrl,
              fallback: shipment.sender.firstName,
              radius: 26,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          shipment.sender.fullName,
                          style: AppTextStyles.titleMedium,
                        ),
                      ),
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.starYellow,
                        size: 14,
                      ),
                      const SizedBox(width: 2),
                      Text(
                        shipment.sender.rating.toStringAsFixed(1),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.inventory_2_outlined,
                      color: AppColors.textSecondary,
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  CabaRouteLabel(
                    from: shipment.fromCity,
                    to: shipment.toCity,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    shipment.itemDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${AppStrings.weight}: ${shipment.weight} ${AppStrings.kg}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(shipment.packageType, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            if (showFav)
              const Icon(
                Icons.favorite_border_rounded,
                color: AppColors.textHint,
                size: 18,
              ),
          ],
        ),
      ),
    );
  }
}
