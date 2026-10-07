import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/api/api_functions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_empty_state.dart';
import '../../core/widgets/category_tab_bar.dart';
import '../../models/notification_model.dart';
import 'notification_nav.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  int _tabIndex = 0;
  bool _loading = true;
  List<AppNotification> _items = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final list = await getNotifications();
    if (!mounted) return;
    setState(() {
      _items = list;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = _tabIndex == 0
        ? _items
        : _items.where((n) => !n.isRead).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CabaAppBar(titleText: AppStrings.notifTitleAr),
      body: Column(
        children: [
          const SizedBox(height: 8),
          CategoryTabBar(
            tabs: [AppStrings.all, AppStrings.unread],
            selectedIndex: _tabIndex,
            onTabChanged: (i) => setState(() => _tabIndex = i),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                    ? Center(
                        child: CabaEmptyState(
                          icon: Icons.notifications_none_rounded,
                          title: AppStrings.emptyNotifs,
                          subtitle: AppStrings.emptyNotifsSub,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 8),
                        itemBuilder: (_, i) {
                          final n = items[i];
                          return InkWell(
                            onTap: () async {
                              await openNotificationTarget(context, n);
                              if (mounted) _load();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: n.isRead
                                    ? Colors.white
                                    : AppColors.primaryLight,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: const BoxDecoration(
                                      color: AppColors.surfaceVariant,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.notifications_none_rounded,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(n.title,
                                            style: AppTextStyles.titleMedium),
                                        const SizedBox(height: 3),
                                        Text(n.body,
                                            style: AppTextStyles.bodySmall),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
