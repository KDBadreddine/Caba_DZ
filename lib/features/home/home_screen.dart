import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/caba_avatar.dart';
import '../../core/widgets/caba_bottom_nav.dart';
import '../../core/widgets/caba_empty_state.dart';
import '../../core/widgets/caba_slider_swiper.dart';
import '../../core/widgets/shipment_card.dart';
import '../../core/widgets/trip_card.dart';
import '../../core/api/api_functions.dart';
import '../../core/api/shared_data.dart';
import '../../models/shipment_model.dart';
import '../../models/slider_model.dart';
import '../../models/trip_model.dart';
import '../chat/chat_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with RouteAware {
  List<TripModel> _trips = [];
  List<ShipmentModel> _shipments = [];
  List<SliderModel> _sliders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route != null) appRouteObserver.subscribe(this, route);
  }

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _load(silent: true);
  }

  Future<void> _load({bool silent = false}) async {
    if (!silent && mounted && !_loading) {
      setState(() => _loading = true);
    }
    final results = await Future.wait([
      getTrips(status: 'active', limit: 3),
      getRequests(status: 'open', limit: 3),
      getSliders(),
    ]);
    if (!mounted) return;
    setState(() {
      _trips = results[0] as List<TripModel>;
      _shipments = results[1] as List<ShipmentModel>;
      _sliders = results[2] as List<SliderModel>;
      _loading = false;
    });
  }

  Future<void> _openAdd(String route) async {
    final added = await Navigator.pushNamed(context, route);
    if (added == true && mounted) await _load(silent: true);
  }

  Future<void> _openAddSheet() async {
    final added = await showCabaAddSheet(context);
    if (added && mounted) await _load(silent: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => _load(silent: true),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              _buildHeader(),
              const SizedBox(height: 28),
              _buildQuickActions(),
              if (_sliders.isNotEmpty) ...[
                const SizedBox(height: 20),
                CabaSliderSwiper(
                  items: _sliders,
                  onTap: _openSlider,
                ),
              ],
              const SizedBox(height: 24),
              _buildSectionHeader(
                AppStrings.availableTripsAr,
                () => Navigator.pushNamed(context, AppRoutes.availableTrips),
              ),
              const SizedBox(height: 12),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_trips.isEmpty)
                CabaEmptyState(
                  icon: Icons.flight_takeoff_rounded,
                  title: AppStrings.emptyTripsAr,
                  subtitle: AppStrings.emptyTripsSubAr,
                  actionLabel: AppStrings.addTripAr,
                  onAction: () => _openAdd(AppRoutes.addTrip),
                  compact: true,
                )
              else
                ..._trips.map(
                  (trip) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: TripCard(
                      trip: trip,
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.tripDetail,
                        arguments: trip,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              _buildSectionHeader(
                AppStrings.availableShipAr,
                () =>
                    Navigator.pushNamed(context, AppRoutes.availableShipments),
              ),
              const SizedBox(height: 12),
              if (_loading)
                const SizedBox.shrink()
              else if (_shipments.isEmpty)
                CabaEmptyState(
                  icon: Icons.inventory_2_outlined,
                  title: AppStrings.emptyShipsAr,
                  subtitle: AppStrings.emptyShipsSubAr,
                  actionLabel: AppStrings.sendShipmentAr,
                  onAction: () => _openAdd(AppRoutes.addShipment),
                  compact: true,
                )
              else
                ..._shipments.map(
                  (shipment) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: ShipmentCard(
                      shipment: shipment,
                      onTap: () => openChat(
                        context,
                        otherUserId: shipment.senderId,
                        userName: shipment.sender.fullName,
                        userAvatar: shipment.sender.avatarUrl,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CabaBottomNav(
        currentIndex: 0,
        onTap: (i) {
          if (i == 0) return;
          navigateMainTab(context, i);
        },
        onAdd: _openAddSheet,
      ),
    );
  }

  Widget _buildHeader() {
    final user = currentUser;
    return Row(
      children: [
        CabaAvatar(
          imageUrl: user.avatarUrl,
          fallback: user.firstName,
          radius: 26,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppStrings.greetingAr} ${user.firstName}',
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 2),
              Text(AppStrings.whatTodayAr, style: AppTextStyles.bodyMedium),
            ],
          ),
        ),
        GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textPrimary,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _ActionCard(
            icon: Icons.inventory_2_outlined,
            color: Colors.blue.shade50,
            textColor: AppColors.primary,
            title: AppStrings.sendShipmentAr,
            subtitle: AppStrings.sendShipSubAr,
            onTap: () => _openAdd(AppRoutes.addShipment),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionCard(
            icon: Icons.flight_takeoff_rounded,
            textColor: Colors.white,
            color: AppColors.primary,
            title: AppStrings.addTripAr,
            subtitle: AppStrings.addTripSubAr,
            onTap: () => _openAdd(AppRoutes.addTrip),
          ),
        ),
      ],
    );
  }

  Future<void> _openSlider(SliderModel slide) async {
    final link = slide.link?.trim() ?? '';
    if (link.isEmpty) return;
    if (link.startsWith('/')) {
      final added = await Navigator.pushNamed(context, link);
      if (added == true && mounted) await _load(silent: true);
    }
  }

  Widget _buildSectionHeader(String title, VoidCallback onShowAll) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.headlineMedium),
        GestureDetector(
          onTap: onShowAll,
          child: Text(AppStrings.showAllAr, style: AppTextStyles.labelLarge),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Color textColor;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.color,
    required this.textColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 18, 14, 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: const [
            BoxShadow(
              color: Color(0x08000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: textColor, size: 28),
            const SizedBox(height: 14),
            Text(
              title,
              style: AppTextStyles.titleLarge.copyWith(color: textColor),
            ),
            /*  const SizedBox(height: 6),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(height: 1.4),
              maxLines: 3,
            ),*/
          ],
        ),
      ),
    );
  }
}
