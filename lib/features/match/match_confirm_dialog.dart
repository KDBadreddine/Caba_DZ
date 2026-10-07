import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/caba_button.dart';

/// `traveler` or `sender`. Null if cancelled.
Future<String?> showMatchConfirmDialog(
  BuildContext context, {
  required String otherName,
  String? presetRole,
  bool otherAlreadyConfirmed = false,
}) {
  return showDialog<String>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _MatchConfirmSheet(
      otherName: otherName,
      presetRole: presetRole,
      otherAlreadyConfirmed: otherAlreadyConfirmed,
    ),
  );
}

class _MatchConfirmSheet extends StatefulWidget {
  final String otherName;
  final String? presetRole;
  final bool otherAlreadyConfirmed;

  const _MatchConfirmSheet({
    required this.otherName,
    this.presetRole,
    this.otherAlreadyConfirmed = false,
  });

  @override
  State<_MatchConfirmSheet> createState() => _MatchConfirmSheetState();
}

class _MatchConfirmSheetState extends State<_MatchConfirmSheet> {
  late String? _role = widget.presetRole;

  @override
  Widget build(BuildContext context) {
    final needPick = widget.presetRole == null;

    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.handshake_rounded,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.matchDialogTitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              widget.otherAlreadyConfirmed
                  ? AppStrings.theyConfirmedMatch
                  : AppStrings.matchDialogBody(widget.otherName),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium,
            ),
            if (needPick) ...[
              const SizedBox(height: 16),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Text(AppStrings.pickYourRole, style: AppTextStyles.titleMedium),
              ),
              const SizedBox(height: 8),
              _RoleTile(
                selected: _role == 'traveler',
                icon: Icons.flight_rounded,
                title: AppStrings.iAmTraveler,
                subtitle: AppStrings.iAmTravelerSub,
                onTap: () => setState(() => _role = 'traveler'),
              ),
              const SizedBox(height: 8),
              _RoleTile(
                selected: _role == 'sender',
                icon: Icons.inventory_2_rounded,
                title: AppStrings.iAmSender,
                subtitle: AppStrings.iAmSenderSub,
                onTap: () => setState(() => _role = 'sender'),
              ),
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: CabaButton(
                    label: AppStrings.cancel,
                    isOutlined: true,
                    onTap: () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CabaButton(
                    label: AppStrings.confirmMatch,
                    onTap: () {
                      if (_role == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(AppStrings.chooseRoleFirst)),
                        );
                        return;
                      }
                      Navigator.pop(context, _role);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleTile extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _RoleTile({
    required this.selected,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
            width: selected ? 1.6 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.titleMedium),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Icon(
              selected ? Icons.check_circle_rounded : Icons.circle_outlined,
              color: selected ? AppColors.primary : AppColors.textHint,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
