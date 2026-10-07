import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/locale/app_locale.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_avatar.dart';
import '../../core/widgets/caba_bottom_nav.dart';
import '../../core/api/session.dart';
import '../../core/api/shared_data.dart';
import '../../core/widgets/caba_country_label.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appLocale,
      builder: (context, _) {
        final user = currentUser;
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CabaAppBar(titleText: AppStrings.account),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Center(
                child: CabaAvatar(
                  imageUrl: user.avatarUrl,
                  fallback: user.firstName,
                  radius: 44,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                user.fullName,
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineMedium,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.starYellow,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${user.rating} (${user.reviewCount})',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _InfoLine(icon: Icons.phone_outlined, text: user.phone),
              const SizedBox(height: 8),
              _InfoLine(icon: Icons.email_outlined, text: user.email),
              if (user.country != null && user.country!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Center(
                  child: CabaCountryLabel(
                    name: user.country!,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              _MenuItem(
                icon: Icons.person_outline_rounded,
                label: AppStrings.personalInfo,
                onTap: () async {
                  final updated = await Navigator.pushNamed(
                    context,
                    AppRoutes.editProfile,
                  );
                  if (updated == true && mounted) setState(() {});
                },
              ),
              _MenuItem(
                icon: Icons.list_alt_rounded,
                label: AppStrings.myOrders,
                onTap: () => Navigator.pushNamed(context, AppRoutes.orders),
              ),
              _MenuItem(
                icon: Icons.settings_outlined,
                label: AppStrings.settings,
                onTap: () => Navigator.pushNamed(context, AppRoutes.settings),
              ),
              _MenuItem(
                icon: Icons.help_outline_rounded,
                label: AppStrings.help,
                onTap: () => showDialog<void>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(AppStrings.help),
                    content: Text(AppStrings.helpBody),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(AppStrings.ok),
                      ),
                    ],
                  ),
                ),
              ),
              _MenuItem(
                icon: Icons.logout_rounded,
                label: AppStrings.logout,
                labelColor: AppColors.primary,
                iconColor: AppColors.primary,
                showArrow: false,
                onTap: () async {
                  await clearSession();
                  if (!context.mounted) return;
                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                },
              ),
            ],
          ),
          bottomNavigationBar: CabaBottomNav(
            currentIndex: 4,
            onTap: (i) {
              if (i == 4) return;
              navigateMainTab(context, i);
            },
          ),
        );
      },
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(text, style: AppTextStyles.bodyMedium),
      ],
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? labelColor;
  final Color? iconColor;
  final bool showArrow;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.iconColor,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor ?? AppColors.textPrimary, size: 22),
      title: Text(
        label,
        style: AppTextStyles.titleMedium.copyWith(
          color: labelColor ?? AppColors.textPrimary,
        ),
      ),
      trailing: showArrow
          ? Icon(
              false
                  ? Icons.arrow_back_ios_rounded
                  : Icons.arrow_forward_ios_rounded,
              color: AppColors.textHint,
              size: 14,
            )
          : null,
    );
  }
}
