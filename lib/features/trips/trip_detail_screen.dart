import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_avatar.dart';
import '../../core/api/api_functions.dart';
import '../../core/api/shared_data.dart';
import '../../core/widgets/caba_button.dart';
import '../../core/widgets/caba_network_image.dart';
import '../../core/widgets/caba_country_label.dart';
import '../../models/trip_model.dart';
import '../chat/chat_nav.dart';

class TripDetailScreen extends StatefulWidget {
  final TripModel? trip;

  const TripDetailScreen({super.key, this.trip});

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  TripModel? _trip;

  @override
  void initState() {
    super.initState();
    _trip = widget.trip;
  }

  bool get _canEdit {
    final t = _trip;
    return t != null && t.travelerId == currentUser.id && t.status == 'active';
  }

  Future<void> _edit() async {
    final t = _trip;
    if (t == null) return;
    final updated = await Navigator.pushNamed(
      context,
      AppRoutes.addTrip,
      arguments: t,
    );
    if (updated == true && mounted) {
      final fresh = await getTripById(t.id);
      if (!mounted) return;
      if (fresh != null) setState(() => _trip = fresh);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = _trip;
    if (t == null) {
      return const Scaffold(body: Center(child: Text('الرحلة غير متوفرة')));
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: Colors.white,
            leading: const CabaBackButton(),
            actions: [
              if (_canEdit)
                IconButton(
                  tooltip: AppStrings.edit,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: _edit,
                ),
              IconButton(
                icon: const Icon(Icons.notifications_none_rounded),
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.notifications),
              ),
            ],
            title: Text(
              AppStrings.tripDetailsAr,
              style: AppTextStyles.headlineMedium,
            ),
            flexibleSpace: const FlexibleSpaceBar(
              background: CabaNetworkImage(url: AppImages.airplaneHero),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CabaAvatar(
                        imageUrl: t.traveler.avatarUrl,
                        fallback: t.traveler.firstName,
                        radius: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              t.traveler.fullName,
                              style: AppTextStyles.titleLarge,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star_rounded,
                                  color: AppColors.starYellow,
                                  size: 16,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  '${t.traveler.rating} (${t.traveler.reviewCount})',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (t.traveler.isVerified) ...[
                    const SizedBox(height: 8),
                    Text(
                      AppStrings.verifiedUserAr,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  _InfoRow(
                    icon: Icons.flight_takeoff_rounded,
                    child: CabaRouteLabel(
                      from: t.fromCity,
                      to: t.toCity,
                      fromIso: t.originIso,
                      toIso: t.destinationIso,
                      fromCountryId: t.originCountryId,
                      toCountryId: t.destinationCountryId,
                      style: AppTextStyles.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.calendar_today_outlined,
                    value: formatDateAr(t.travelDate),
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.inventory_2_outlined,
                    value: '${t.availableKg} ${AppStrings.kgAr}',
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.payments_outlined,
                    value: '${t.pricePerKg} ${t.currency} / ${AppStrings.kg}',
                  ),
                  if (t.notes != null && t.notes!.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(t.notes!, style: AppTextStyles.bodyMedium),
                  ],
                  if (_canEdit) ...[
                    const SizedBox(height: 28),
                    CabaButton(label: AppStrings.editTrip, onTap: _edit),
                  ] else if (t.travelerId != currentUser.id) ...[
                    const SizedBox(height: 28),
                    CabaButton(
                      label: AppStrings.contactTravelerAr,
                      onTap: () => openChat(
                        context,
                        otherUserId: t.travelerId,
                        userName: t.traveler.fullName,
                        userAvatar: t.traveler.avatarUrl,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String? value;
  final Widget? child;

  const _InfoRow({required this.icon, this.value, this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: child ?? Text(value ?? '', style: AppTextStyles.bodyLarge),
        ),
      ],
    );
  }
}
