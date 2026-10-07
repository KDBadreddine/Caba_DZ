import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/api/api_functions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_empty_state.dart';
import '../../core/widgets/category_tab_bar.dart';
import '../../core/widgets/caba_country_label.dart';
import '../../models/shipment_model.dart';
import '../../models/trip_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _tabIndex = 0;
  List<String> get _tabs =>
      [AppStrings.all, AppStrings.trips, AppStrings.shipments];
  List<TripModel> _trips = [];
  List<ShipmentModel> _requests = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final trips = await getMyTrips();
    final requests = await getMyRequests();
    if (!mounted) return;
    setState(() {
      _trips = trips;
      _requests = requests;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CabaAppBar(titleText: AppStrings.ordersAr),
      body: Column(
        children: [
          const SizedBox(height: 8),
          CategoryTabBar(
            tabs: _tabs,
            selectedIndex: _tabIndex,
            onTabChanged: (i) => setState(() => _tabIndex = i),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _buildList(),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    final tripTiles = _trips.map((t) => _OrderTile(
          icon: Icons.flight_rounded,
          destination: t.toCity.isEmpty ? t.fromCity : t.toCity,
          countryId: t.toCity.isEmpty ? t.originCountryId : t.destinationCountryId,
          iso: t.toCity.isEmpty ? t.originIso : t.destinationIso,
          date: formatDateAr(t.travelDate),
          status: t.status,
          onEdit: t.status == 'active'
              ? () async {
                  final updated = await Navigator.pushNamed(
                    context,
                    AppRoutes.addTrip,
                    arguments: t,
                  );
                  if (updated == true && mounted) _load();
                }
              : null,
          onTap: () async {
            await Navigator.pushNamed(
              context,
              AppRoutes.tripDetail,
              arguments: t,
            );
            if (mounted) _load();
          },
        ));
    final shipTiles = _requests.map((s) => _OrderTile(
          icon: Icons.inventory_2_outlined,
          destination: s.toCity,
          date: s.itemDescription,
          status: s.status,
          onEdit: s.status == 'open'
              ? () async {
                  final updated = await Navigator.pushNamed(
                    context,
                    AppRoutes.addShipment,
                    arguments: s,
                  );
                  if (updated == true && mounted) _load();
                }
              : null,
          onTap: () async {
            await Navigator.pushNamed(
              context,
              AppRoutes.shipmentDetail,
              arguments: s,
            );
            if (mounted) _load();
          },
        ));

    final children = _tabIndex == 1
        ? tripTiles.toList()
        : _tabIndex == 2
            ? shipTiles.toList()
            : [...tripTiles, ...shipTiles];

    if (children.isEmpty) {
      return Center(
        child: CabaEmptyState(
          icon: Icons.list_alt_rounded,
          title: AppStrings.emptyOrdersAr,
          subtitle: AppStrings.emptyOrdersSubAr,
          actionLabel: AppStrings.addTripAr,
          onAction: () async {
            final added = await Navigator.pushNamed(context, AppRoutes.addTrip);
            if (added == true && mounted) _load();
          },
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: children,
    );
  }
}

class _OrderTile extends StatelessWidget {
  final IconData icon;
  final String destination;
  final String date;
  final String status;
  final String? iso;
  final int? countryId;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;

  const _OrderTile({
    required this.icon,
    required this.destination,
    required this.date,
    required this.status,
    this.iso,
    this.countryId,
    this.onTap,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final (label, color) = _statusInfo(status);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CabaCountryLabel(
                    name: destination,
                    iso: iso,
                    countryId: countryId,
                    style: AppTextStyles.titleMedium,
                    expanded: true,
                  ),
                  const SizedBox(height: 4),
                  Text(date, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                label,
                style: AppTextStyles.bodySmall
                    .copyWith(color: color, fontWeight: FontWeight.w600),
              ),
            ),
            if (onEdit != null)
              IconButton(
                tooltip: AppStrings.edit,
                visualDensity: VisualDensity.compact,
                icon: const Icon(Icons.edit_outlined,
                    size: 20, color: AppColors.primary),
                onPressed: onEdit,
              ),
          ],
        ),
      ),
    );
  }

  (String, Color) _statusInfo(String status) {
    switch (status) {
      case 'pending':
      case 'open':
      case 'active':
        return (AppStrings.pendingAr, AppColors.warning);
      case 'matched':
      case 'confirmed':
        return (AppStrings.agreedAr, AppColors.info);
      case 'completed':
      case 'delivered':
        return (AppStrings.completedAr, AppColors.success);
      case 'cancelled':
        return (AppStrings.cancelledAr, AppColors.error);
      default:
        return (status, AppColors.warning);
    }
  }
}
