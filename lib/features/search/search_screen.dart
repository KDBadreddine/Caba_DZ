import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/api/api_functions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/country_flag.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_bottom_nav.dart';
import '../../core/widgets/caba_button.dart';
import '../../core/widgets/caba_empty_state.dart';
import '../../core/widgets/caba_network_image.dart';
import '../../core/widgets/caba_country_dropdown.dart';
import '../../core/widgets/caba_country_label.dart';
import '../../core/widgets/shipment_card.dart';
import '../../core/widgets/trip_card.dart';
import '../../models/country_model.dart';
import '../../models/shipment_model.dart';
import '../../models/trip_model.dart';
import '../chat/chat_nav.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isTrips = true;
  List<CountryModel> _countries = [];
  CountryModel? _from;
  CountryModel? _to;
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  bool _searched = false;
  bool _loading = false;
  bool _loadingCountries = true;
  List<TripModel> _trips = [];
  List<ShipmentModel> _shipments = [];

  @override
  void initState() {
    super.initState();
    _loadCountries();
  }

  Future<void> _loadCountries() async {
    final list = await getCountries();
    if (!mounted) return;
    setState(() {
      _countries = list;
      _from =
          list.where((c) => c.iso.toUpperCase() == 'DZ').firstOrNull ??
          (list.isEmpty ? null : list.first);
      _to = list.where((c) => c.iso.toUpperCase() == 'FR').firstOrNull;
      _loadingCountries = false;
    });
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _runSearch() async {
    final from = _from;
    if (from == null) return;
    setState(() {
      _searched = true;
      _loading = true;
    });
    final destId = _to?.id;
    final originId = from.id;
    final day = DateTime(_date.year, _date.month, _date.day);

    if (_isTrips) {
      final all = await getTrips(
        status: 'active',
        destinationCountryId: destId,
      );
      _trips = all.where((t) {
        final originOk = t.originCountryId == originId;
        final destOk = destId == null || t.destinationCountryId == destId;
        final dateOk = !t.travelDate.isBefore(day);
        return originOk && destOk && dateOk;
      }).toList();
    } else {
      final all = await getRequests(status: 'open');
      _shipments = all.where((s) {
        final originOk =
            getCountryIso(s.fromCity) == from.iso.toUpperCase() ||
            s.fromCity.toLowerCase().contains(from.nicename.toLowerCase());
        final destOk =
            _to == null ||
            getCountryIso(s.toCity) == _to!.iso.toUpperCase() ||
            s.toCity.toLowerCase().contains(_to!.nicename.toLowerCase());
        return originOk && destOk;
      }).toList();
    }
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _afterAdd() async {
    if (_searched) await _runSearch();
  }

  Future<void> _pickCountry({required bool isFrom}) async {
    if (_countries.isEmpty) return;
    final selected = await showCabaCountryPicker(
      context,
      countries: _countries,
      selected: isFrom ? _from : _to,
    );
    if (selected == null) return;
    setState(() {
      if (isFrom) {
        _from = selected;
      } else {
        _to = selected;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CabaAppBar(
        titleText: AppStrings.searchAr,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded),
            onPressed: () =>
                Navigator.pushNamed(context, AppRoutes.notifications),
          ),
        ],
      ),
      body: _loadingCountries
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      _ToggleTab(
                        label: AppStrings.tripsTab,
                        isActive: _isTrips,
                        onTap: () {
                          setState(() => _isTrips = true);
                          if (_searched) _runSearch();
                        },
                      ),
                      _ToggleTab(
                        label: AppStrings.shipsTab,
                        isActive: !_isTrips,
                        onTap: () {
                          setState(() => _isTrips = false);
                          if (_searched) _runSearch();
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _FieldTile(
                  icon: Icons.flight_takeoff_rounded,
                  label: AppStrings.fromAr,
                  value: _from?.nicename ?? AppStrings.chooseCountry,
                  iso: _from?.iso,
                  countryId: _from?.id,
                  onTap: () => _pickCountry(isFrom: true),
                ),
                const SizedBox(height: 12),
                _FieldTile(
                  icon: Icons.flight_land_rounded,
                  label: AppStrings.toAr,
                  value: _to?.nicename ?? AppStrings.destCity,
                  iso: _to?.iso,
                  countryId: _to?.id,
                  onTap: () => _pickCountry(isFrom: false),
                ),
                const SizedBox(height: 12),
                _FieldTile(
                  icon: Icons.calendar_today_outlined,
                  label: AppStrings.dateAr,
                  value: formatDateAr(_date),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 20),
                CabaButton(
                  label: AppStrings.searchBtnAr,
                  onTap: _runSearch,
                  isLoading: _loading,
                ),
                const SizedBox(height: 28),
                if (_searched) _buildResults() else _buildPopular(),
              ],
            ),
      bottomNavigationBar: CabaBottomNav(
        currentIndex: 1,
        onTap: (i) {
          if (i == 1) return;
          navigateMainTab(context, i);
        },
        onAdd: () async {
          final added = await showCabaAddSheet(context);
          if (added && mounted) await _afterAdd();
        },
      ),
    );
  }

  Widget _buildPopular() {
    final popular = _countries
        .where((c) => c.iso.toUpperCase() != 'DZ')
        .take(3);
    final dests = popular.isNotEmpty
        ? popular
              .map(
                (c) => (
                  name: c.nicename,
                  iso: c.iso,
                  countryId: c.id,
                  imageUrl:
                      'https://flagcdn.com/w160/${c.iso.toLowerCase()}.png',
                ),
              )
              .toList()
        : [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(AppStrings.popularDests, style: AppTextStyles.headlineMedium),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: dests.map((d) {
            return GestureDetector(
              onTap: () {
                final country = _countries
                    .where((c) => c.id == d.countryId)
                    .firstOrNull;
                setState(() {
                  _isTrips = true;
                  _to = country;
                });
                _runSearch();
              },
              child: Column(
                children: [
                  CabaNetworkImage(
                    url:
                        d.imageUrl ??
                        'https://flagcdn.com/w160/${d.iso.toLowerCase()}.png',
                    width: 72,
                    height: 72,
                    borderRadius: BorderRadius.circular(36),
                  ),
                  const SizedBox(height: 8),
                  CabaCountryLabel(
                    name: d.name,
                    iso: d.iso,
                    countryId: d.countryId,
                    style: AppTextStyles.titleMedium,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildResults() {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 32),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_isTrips) {
      if (_trips.isEmpty) {
        return CabaEmptyState(
          icon: Icons.flight_takeoff_rounded,
          title: AppStrings.emptySearchAr,
          subtitle: AppStrings.emptySearchSubAr,
          actionLabel: AppStrings.addTripAr,
          onAction: () async {
            final added = await Navigator.pushNamed(context, AppRoutes.addTrip);
            if (added == true && mounted) await _afterAdd();
          },
        );
      }
      return Column(
        children: _trips
            .map(
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
            )
            .toList(),
      );
    }
    if (_shipments.isEmpty) {
      return CabaEmptyState(
        icon: Icons.inventory_2_outlined,
        title: AppStrings.emptySearchAr,
        subtitle: AppStrings.emptySearchSubAr,
        actionLabel: AppStrings.sendShipmentAr,
        onAction: () async {
          final added = await Navigator.pushNamed(
            context,
            AppRoutes.addShipment,
          );
          if (added == true && mounted) await _afterAdd();
        },
      );
    }
    return Column(
      children: _shipments
          .map(
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
          )
          .toList(),
    );
  }
}

class _ToggleTab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleTab({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.titleMedium.copyWith(
              color: isActive ? Colors.white : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _FieldTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? iso;
  final int? countryId;
  final VoidCallback onTap;

  const _FieldTile({
    required this.icon,
    required this.label,
    required this.value,
    this.iso,
    this.countryId,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textHint,
                    ),
                  ),
                  const SizedBox(height: 2),
                  CabaCountryLabel(
                    name: value,
                    iso: iso,
                    countryId: countryId,
                    style: AppTextStyles.bodyLarge,
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
