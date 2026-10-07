import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/api/api_functions.dart';
import '../../core/api/shared_data.dart';
import '../../core/constants/app_images.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_avatar.dart';
import '../../core/widgets/caba_button.dart';
import '../../core/widgets/caba_country_label.dart';
import '../../core/widgets/caba_network_image.dart';
import '../../models/match_model.dart';
import '../../models/shipment_model.dart';
import '../chat/chat_nav.dart';

class ShipmentDetailScreen extends StatefulWidget {
  final ShipmentModel? shipment;

  const ShipmentDetailScreen({super.key, this.shipment});

  @override
  State<ShipmentDetailScreen> createState() => _ShipmentDetailScreenState();
}

class _ShipmentDetailScreenState extends State<ShipmentDetailScreen> {
  MatchModel? _match;
  bool _loadingMatch = true;
  ShipmentModel? _shipment;

  @override
  void initState() {
    super.initState();
    _shipment = widget.shipment;
    _loadMatch();
  }

  bool get _canEdit {
    final s = _shipment;
    return s != null && s.senderId == currentUser.id && s.status == 'open';
  }

  Future<void> _edit() async {
    final s = _shipment;
    if (s == null) return;
    final updated = await Navigator.pushNamed(
      context,
      AppRoutes.addShipment,
      arguments: s,
    );
    if (updated == true && mounted) {
      final fresh = await getRequestById(s.id);
      if (!mounted) return;
      if (fresh != null) setState(() => _shipment = fresh);
    }
  }

  Future<void> _loadMatch() async {
    final id = widget.shipment?.id;
    if (id == null || id.isEmpty) {
      setState(() => _loadingMatch = false);
      return;
    }
    final match = await getMatchByRequestId(id);
    if (!mounted) return;
    setState(() {
      _match = match;
      _loadingMatch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final s = _shipment;
    if (s == null) {
      return const Scaffold(body: Center(child: Text('الشحنة غير متوفرة')));
    }
    final mine = s.senderId == currentUser.id;
    final match = _match;
    final otherId = match == null
        ? ''
        : match.iAmSender(currentUser.id)
            ? match.travelerId
            : match.senderId;

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
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
            ],
            title: Text(AppStrings.shipDetails, style: AppTextStyles.headlineMedium),
            flexibleSpace: FlexibleSpaceBar(
              background: CabaNetworkImage(
                url: s.photoUrl ?? AppImages.packageBox,
              ),
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
                        imageUrl: s.sender.avatarUrl,
                        fallback: s.sender.firstName,
                        radius: 28,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.sender.fullName, style: AppTextStyles.titleLarge),
                            const SizedBox(height: 4),
                            Text(
                              s.status,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 22),
                  _InfoRow(
                    icon: Icons.inventory_2_outlined,
                    value: s.itemDescription,
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.local_offer_outlined,
                    value: s.itemCategory,
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.flight_takeoff_rounded,
                    child: CabaRouteLabel(
                      from: s.fromCity,
                      to: s.toCity,
                      style: AppTextStyles.bodyLarge,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _InfoRow(
                    icon: Icons.scale_outlined,
                    value: '${s.weight} ${AppStrings.kgAr}',
                  ),
                  if (s.maxBudget != null) ...[
                    const SizedBox(height: 14),
                    _InfoRow(
                      icon: Icons.payments_outlined,
                      value: '${s.maxBudget}',
                    ),
                  ],
                  if (_canEdit) ...[
                    const SizedBox(height: 28),
                    CabaButton(
                      label: AppStrings.editShip,
                      onTap: _edit,
                    ),
                  ] else if (!_loadingMatch && otherId.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    CabaButton(
                      label: mine
                          ? AppStrings.openOrderChat
                          : AppStrings.contactSender,
                      onTap: () => openChat(context, otherUserId: otherId),
                    ),
                  ] else if (!mine) ...[
                    const SizedBox(height: 28),
                    CabaButton(
                      label: AppStrings.contactSender,
                      onTap: () => openChat(
                        context,
                        otherUserId: s.senderId,
                        userName: s.sender.fullName,
                        userAvatar: s.sender.avatarUrl,
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
