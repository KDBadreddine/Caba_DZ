import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/constants/app_strings.dart';
import 'caba_app_bar.dart';

class CabaBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final VoidCallback? onAdd;

  const CabaBottomNav({
    super.key,
    required this.currentIndex,
    this.onTap,
    this.onAdd,
  });

  void _handleTap(BuildContext context, int index) {
    if (index == 2) {
      if (onAdd != null) {
        onAdd!();
      } else {
        showCabaAddSheet(context);
      }
      return;
    }
    if (onTap != null) {
      onTap!(index);
      return;
    }
    navigateMainTab(context, index);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBg,
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 16,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home_rounded,
                label: AppStrings.navHome,
                isActive: currentIndex == 0,
                onTap: () => _handleTap(context, 0),
              ),
              _NavItem(
                icon: Icons.search,
                activeIcon: Icons.search,
                label: AppStrings.navSearch,
                isActive: currentIndex == 1,
                onTap: () => _handleTap(context, 1),
              ),
              _AddButton(onTap: () => _handleTap(context, 2)),
              _NavItem(
                icon: Icons.chat_bubble_outline_rounded,
                activeIcon: Icons.chat_bubble_rounded,
                label: AppStrings.navMessages,
                isActive: currentIndex == 3,
                onTap: () => _handleTap(context, 3),
              ),
              _NavItem(
                icon: Icons.person_outline_rounded,
                activeIcon: Icons.person_rounded,
                label: AppStrings.navAccount,
                isActive: currentIndex == 4,
                onTap: () => _handleTap(context, 4),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void navigateMainTab(BuildContext context, int index) {
  switch (index) {
    case 0:
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (r) => false);
      break;
    case 1:
      Navigator.pushNamed(context, AppRoutes.search);
      break;
    case 3:
      Navigator.pushNamed(context, AppRoutes.messages);
      break;
    case 4:
      Navigator.pushNamed(context, AppRoutes.account);
      break;
  }
}

Future<bool> showCabaAddSheet(BuildContext context) async {
  final choice = await showModalBottomSheet<String>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (sheetContext) => Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          _SheetOption(
            icon: Icons.flight_takeoff_rounded,
            label: AppStrings.addTrip,
            subtitle: AppStrings.addTripSub,
            onTap: () => Navigator.pop(sheetContext, 'trip'),
          ),
          const SizedBox(height: 8),
          _SheetOption(
            icon: Icons.inventory_2_outlined,
            label: AppStrings.addShipTitle,
            subtitle: AppStrings.sendShipSub,
            onTap: () => Navigator.pop(sheetContext, 'shipment'),
          ),
        ],
      ),
    ),
  );
  if (!context.mounted || choice == null) return false;
  final route = choice == 'trip' ? AppRoutes.addTrip : AppRoutes.addShipment;
  final result = await Navigator.pushNamed(context, route);
  return result == true;
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.textHint,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isActive ? AppColors.primary : AppColors.textHint,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddButton extends StatelessWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 28),
          ),
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  const _SheetOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: AppColors.primaryLight,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: AppColors.primary),
      ),
      title: Text(label, style: AppTextStyles.titleMedium),
      subtitle: Text(subtitle, style: AppTextStyles.bodySmall),
      trailing: Icon(
        cabaBackIcon(context),
        color: AppColors.textHint,
        size: 16,
      ),
      contentPadding: EdgeInsets.zero,
    );
  }
}
