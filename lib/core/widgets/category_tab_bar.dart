import 'package:flutter/material.dart';
import '../../app/theme.dart';
import 'caba_country_label.dart';

class CategoryTabBar extends StatelessWidget {
  final List<String> tabs;
  final List<String?>? countryIsos;
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const CategoryTabBar({
    super.key,
    required this.tabs,
    this.countryIsos,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isSelected = i == selectedIndex;
          final iso = (countryIsos != null && i < countryIsos!.length)
              ? countryIsos![i]
              : null;
          final style = AppTextStyles.bodyMedium.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          );
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: GestureDetector(
              onTap: () => onTabChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: iso == null || iso.isEmpty
                    ? Text(tabs[i], style: style)
                    : CabaCountryLabel(
                        name: tabs[i],
                        iso: iso,
                        style: style,
                        flagWidth: 18,
                        flagHeight: 13,
                      ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
