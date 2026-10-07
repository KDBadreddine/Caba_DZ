import 'package:caba_dz/core/constants/app_strings.dart';
import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../models/trip_model.dart';
import '../utils/date_format.dart';
import 'caba_avatar.dart';
import 'caba_country_label.dart';

class TripCard extends StatelessWidget {
  final TripModel trip;
  final VoidCallback? onTap;
  final bool showFav;

  const TripCard({
    super.key,
    required this.trip,
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
              imageUrl: trip.traveler.avatarUrl,
              fallback: trip.traveler.firstName,
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
                          trip.traveler.fullName,
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
                        trip.traveler.rating.toStringAsFixed(1),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  CabaRouteLabel(
                    from: trip.fromCity,
                    to: trip.toCity,
                    fromIso: trip.originIso,
                    toIso: trip.destinationIso,
                    fromCountryId: trip.originCountryId,
                    toCountryId: trip.destinationCountryId,
                    style: AppTextStyles.bodySmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatDateAr(trip.travelDate),
                    style: AppTextStyles.bodySmall,
                  ),
                  if (trip.departureTime.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(trip.departureTime, style: AppTextStyles.bodySmall),
                  ],
                  const SizedBox(height: 2),
                  Text(
                    '${trip.availableKg} ${AppStrings.kg}  •  ${trip.pricePerKg} ${trip.currency}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            if (showFav)
              const Padding(
                padding: EdgeInsets.only(right: 2),
                child: Icon(
                  Icons.favorite_border_rounded,
                  color: AppColors.textHint,
                  size: 18,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
