import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/api/api_functions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_bottom_nav.dart';
import '../../core/widgets/caba_empty_state.dart';
import '../../core/widgets/trip_card.dart';
import '../../core/widgets/category_tab_bar.dart';
import '../../models/trip_model.dart';

class AvailableTripsScreen extends StatefulWidget {
  const AvailableTripsScreen({super.key});

  @override
  State<AvailableTripsScreen> createState() => _AvailableTripsScreenState();
}

class _AvailableTripsScreenState extends State<AvailableTripsScreen> {
  int _tabIndex = 0;
  bool _loading = true;
  List<TripModel> _trips = [];

  List<String> get _tabs => [AppStrings.allAr];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool showSpinner = true}) async {
    if (showSpinner && mounted && !_loading) {
      setState(() => _loading = true);
    }
    int? destId;
    if (_tabIndex > 0) {
      destId = null;
    }
    final list = await getTrips(status: 'active', destinationCountryId: destId);
    if (!mounted) return;
    setState(() {
      _trips = list;
      _loading = false;
    });
  }

  Future<void> _openAddTrip() async {
    final added = await Navigator.pushNamed(context, AppRoutes.addTrip);
    if (added == true && mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CabaAppBar(titleText: AppStrings.availableTripsAr),
      body: Column(
        children: [
          const SizedBox(height: 8),
          CategoryTabBar(
            tabs: _tabs,
            countryIsos: [null],
            selectedIndex: _tabIndex,
            onTabChanged: (i) {
              setState(() => _tabIndex = i);
              _load();
            },
          ),
          const SizedBox(height: 16),
          Expanded(child: _buildBody()),
        ],
      ),
      bottomNavigationBar: CabaBottomNav(
        currentIndex: 1,
        onAdd: () async {
          final added = await showCabaAddSheet(context);
          if (added && mounted) _load();
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      color: AppColors.primary,
      onRefresh: () => _load(showSpinner: false),
      child: _trips.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.45,
                  child: CabaEmptyState(
                    icon: Icons.flight_takeoff_rounded,
                    title: AppStrings.emptyTripsAr,
                    subtitle: AppStrings.emptyTripsSubAr,
                    actionLabel: AppStrings.addTripAr,
                    onAction: _openAddTrip,
                  ),
                ),
              ],
            )
          : ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _trips.length,
              separatorBuilder: (_, _) => const SizedBox(height: 10),
              itemBuilder: (_, i) => TripCard(
                trip: _trips[i],
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRoutes.tripDetail,
                  arguments: _trips[i],
                ),
              ),
            ),
    );
  }
}
