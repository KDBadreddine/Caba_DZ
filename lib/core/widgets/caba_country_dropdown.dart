import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/constants/app_strings.dart';
import '../../models/country_model.dart';
import 'caba_country_label.dart';

Future<CountryModel?> showCabaCountryPicker(
  BuildContext context, {
  required List<CountryModel> countries,
  CountryModel? selected,
}) {
  return showModalBottomSheet<CountryModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) => _CountryPickerSheet(
      countries: countries,
      selected: selected,
    ),
  );
}

class _CountryPickerSheet extends StatefulWidget {
  final List<CountryModel> countries;
  final CountryModel? selected;

  const _CountryPickerSheet({
    required this.countries,
    this.selected,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _filterCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _filterCtrl.dispose();
    super.dispose();
  }

  List<CountryModel> get _filtered {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) return widget.countries;
    return widget.countries.where((c) {
      return c.nicename.toLowerCase().contains(q) ||
          c.name.toLowerCase().contains(q) ||
          c.iso.toLowerCase().contains(q) ||
          (c.iso3 ?? '').toLowerCase().contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final items = _filtered;
    final height = MediaQuery.of(context).size.height * 0.75;
    return SizedBox(
      height: height,
      child: Column(
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _filterCtrl,
              style: AppTextStyles.bodyLarge,
              decoration: InputDecoration(
                hintText: AppStrings.search,
                prefixIcon: const Icon(Icons.search_rounded),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Text(
                      AppStrings.emptySearch,
                      style: AppTextStyles.bodyMedium,
                    ),
                  )
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final c = items[i];
                      final isSelected = widget.selected?.id == c.id;
                      return ListTile(
                        selected: isSelected,
                        title: CabaCountryLabel(
                          name: c.nicename,
                          iso: c.iso,
                          countryId: c.id,
                          style: AppTextStyles.bodyLarge,
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_rounded,
                                color: AppColors.primary)
                            : null,
                        onTap: () => Navigator.pop(context, c),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class CabaCountryDropdown extends StatelessWidget {
  final String label;
  final List<CountryModel> countries;
  final CountryModel? value;
  final ValueChanged<CountryModel?> onChanged;
  final String? hint;
  final String? Function(CountryModel?)? validator;

  const CabaCountryDropdown({
    super.key,
    required this.label,
    required this.countries,
    required this.value,
    required this.onChanged,
    this.hint,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.titleMedium),
        const SizedBox(height: 8),
        DropdownButtonFormField<CountryModel>(
          key: ValueKey(value?.id),
          initialValue: value,
          isExpanded: true,
          hint: hint != null ? Text(hint!) : null,
          validator: validator,
          items: countries
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: CabaCountryLabel(
                    name: c.nicename,
                    iso: c.iso,
                    countryId: c.id,
                    expanded: true,
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
