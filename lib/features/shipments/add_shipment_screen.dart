import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/api/api_functions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_button.dart';
import '../../core/widgets/caba_country_dropdown.dart';
import '../../core/widgets/caba_dialogs.dart';
import '../../core/widgets/caba_text_field.dart';
import '../../models/country_model.dart';
import '../../models/shipment_model.dart';

class AddShipmentScreen extends StatefulWidget {
  final ShipmentModel? shipment;

  const AddShipmentScreen({super.key, this.shipment});

  @override
  State<AddShipmentScreen> createState() => _AddShipmentScreenState();
}

class _AddShipmentScreenState extends State<AddShipmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  List<CountryModel> _countries = [];
  CountryModel? _from;
  CountryModel? _to;
  String? _packageType = AppStrings.catElectronicsAr;
  bool _loading = false;
  late final List<String> _types;

  bool get _isEditing => widget.shipment != null;

  @override
  void initState() {
    super.initState();
    _types = [
      AppStrings.catElectronicsAr,
      AppStrings.catClothingAr,
      AppStrings.catFoodAr,
      AppStrings.catDocumentsAr,
      AppStrings.catOtherAr,
    ];
    final shipment = widget.shipment;
    if (shipment != null) {
      _descCtrl.text = shipment.itemDescription;
      _weightCtrl.text = shipment.weight == shipment.weight.roundToDouble()
          ? '${shipment.weight.toInt()}'
          : '${shipment.weight}';
      if (shipment.maxBudget != null) {
        _budgetCtrl.text = shipment.maxBudget == shipment.maxBudget!.roundToDouble()
            ? '${shipment.maxBudget!.toInt()}'
            : '${shipment.maxBudget}';
      }
      _packageType = shipment.itemCategory.isEmpty
          ? AppStrings.catOtherAr
          : shipment.itemCategory;
      if (_packageType != null && !_types.contains(_packageType)) {
        _types.insert(0, _packageType!);
      }
    }
    getCountries().then((list) {
      if (!mounted) return;
      setState(() {
        _countries = list;
        if (shipment != null) {
          _from = _matchCountry(list, shipment.originCountry);
          _to = _matchCountry(list, shipment.destinationCountry);
        } else {
          _from = list.where((c) => c.id == 3).firstOrNull ??
              (list.isEmpty ? null : list.first);
        }
      });
    });
    if (shipment != null && shipment.status != 'open') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showCabaErrorSnack(context, AppStrings.cannotEditMatched);
        Navigator.pop(context);
      });
    }
  }

  CountryModel? _matchCountry(List<CountryModel> list, String name) {
    final n = name.trim().toLowerCase();
    if (n.isEmpty) return null;
    return list
            .where((c) =>
                c.nicename.toLowerCase() == n || c.name.toLowerCase() == n)
            .firstOrNull ??
        list
            .where((c) =>
                c.nicename.toLowerCase().contains(n) ||
                n.contains(c.nicename.toLowerCase()))
            .firstOrNull;
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _weightCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  Future<void> _post() async {
    if (!_formKey.currentState!.validate()) return;
    if (_from == null || _to == null) {
      showCabaErrorSnack(context, AppStrings.requiredField);
      return;
    }
    setState(() => _loading = true);
    final ok = _isEditing
        ? await updateRequest(
            id: widget.shipment!.id,
            itemDescription: _descCtrl.text.trim(),
            itemCategory: _packageType ?? AppStrings.catOtherAr,
            weightKg: double.tryParse(_weightCtrl.text) ?? 1,
            originCountry: _from!.displayName,
            destinationCountry: _to!.displayName,
            maxBudget: double.tryParse(_budgetCtrl.text),
            photoUrl: widget.shipment!.photoUrl,
          )
        : await createRequest(
            itemDescription: _descCtrl.text.trim(),
            itemCategory: _packageType ?? AppStrings.catOtherAr,
            weightKg: double.tryParse(_weightCtrl.text) ?? 1,
            originCountry: _from!.displayName,
            destinationCountry: _to!.displayName,
            maxBudget: double.tryParse(_budgetCtrl.text),
          );
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      await showCabaSuccessDialog(
        context,
        title: _isEditing ? AppStrings.shipUpdated : AppStrings.shipPostedAr,
        subtitle:
            _isEditing ? AppStrings.shipUpdatedSub : AppStrings.shipPostedSubAr,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } else {
      showCabaErrorSnack(
        context,
        _isEditing ? AppStrings.cannotEditMatched : AppStrings.shipFailed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CabaAppBar(
        titleText: _isEditing ? AppStrings.editShip : AppStrings.addShipTitleAr,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CabaCountryDropdown(
                label: AppStrings.fromAr,
                countries: _countries,
                value: _from,
                hint: AppStrings.chooseCountry,
                onChanged: (c) => setState(() => _from = c),
                validator: (v) => v == null ? AppStrings.requiredField : null,
              ),
              const SizedBox(height: 16),
              CabaCountryDropdown(
                label: AppStrings.toAr,
                countries: _countries,
                value: _to,
                hint: AppStrings.chooseCountry,
                onChanged: (c) => setState(() => _to = c),
                validator: (v) => v == null ? AppStrings.requiredField : null,
              ),
              const SizedBox(height: 16),
              CabaTextField(
                label: AppStrings.itemDesc,
                hint: 'مثال: هاتف في علبته',
                controller: _descCtrl,
                maxLines: 2,
                validator: (v) =>
                    v == null || v.isEmpty ? AppStrings.requiredField : null,
              ),
              const SizedBox(height: 16),
              CabaTextField(
                label: AppStrings.weightAr,
                hint: '5',
                controller: _weightCtrl,
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? AppStrings.requiredField : null,
              ),
              const SizedBox(height: 16),
              Text(AppStrings.packageTypeAr, style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _types.contains(_packageType)
                    ? _packageType
                    : _types.first,
                items: _types
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) => setState(() => _packageType = v),
              ),
              const SizedBox(height: 16),
              CabaTextField(
                label: AppStrings.maxBudget,
                hint: '50',
                controller: _budgetCtrl,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              CabaButton(
                label: _isEditing ? AppStrings.save : AppStrings.postShipAr,
                onTap: _post,
                isLoading: _loading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
