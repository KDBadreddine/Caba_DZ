import 'package:flutter/material.dart';
import '../../app/routes.dart';
import '../../app/theme.dart';
import '../../core/api/api_functions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_bottom_nav.dart';
import '../../core/widgets/caba_empty_state.dart';
import '../../core/widgets/shipment_card.dart';
import '../../core/widgets/category_tab_bar.dart';
import '../../models/shipment_model.dart';
import '../chat/chat_nav.dart';

class AvailableShipmentsScreen extends StatefulWidget {
  const AvailableShipmentsScreen({super.key});

  @override
  State<AvailableShipmentsScreen> createState() =>
      _AvailableShipmentsScreenState();
}

class _AvailableShipmentsScreenState extends State<AvailableShipmentsScreen> {
  int _tabIndex = 0;
  bool _loading = true;
  List<ShipmentModel> _items = [];
  List<String> get _tabs => [AppStrings.all];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load({bool showSpinner = true}) async {
    if (showSpinner && mounted && !_loading) {
      setState(() => _loading = true);
    }
    final all = await getRequests(status: 'open');
    if (!mounted) return;
    setState(() {
      _items = all;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CabaAppBar(titleText: AppStrings.availableShipAr),
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
                : _items.isEmpty
                ? Center(
                    child: CabaEmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: AppStrings.emptyShipsAr,
                      subtitle: AppStrings.emptyShipsSubAr,
                      actionLabel: AppStrings.sendShipmentAr,
                      onAction: () async {
                        final added = await Navigator.pushNamed(
                          context,
                          AppRoutes.addShipment,
                        );
                        if (added == true && mounted) _load();
                      },
                    ),
                  )
                : RefreshIndicator(
                    color: AppColors.primary,
                    onRefresh: () => _load(showSpinner: false),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: _items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => ShipmentCard(
                        shipment: _items[i],
                        onTap: () => openChat(
                          context,
                          otherUserId: _items[i].senderId,
                          userName: _items[i].sender.fullName,
                          userAvatar: _items[i].sender.avatarUrl,
                        ),
                      ),
                    ),
                  ),
          ),
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
}
