import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/api/api_functions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_button.dart';
import '../../core/widgets/caba_country_dropdown.dart';
import '../../core/widgets/caba_dialogs.dart';
import '../../core/widgets/caba_text_field.dart';
import '../../models/country_model.dart';
import '../../models/trip_model.dart';

class AddTripScreen extends StatefulWidget {
  final TripModel? trip;

  const AddTripScreen({super.key, this.trip});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();
  final _notesCtrl = TextEditingController();
  final _priceCtrl = TextEditingController(text: '10');
  List<CountryModel> _countries = [];
  CountryModel? _origin;
  CountryModel? _destination;
  DateTime? _date;
  double _weight = 20;
  String _currency = 'EUR';
  bool _loading = false;

  bool get _isEditing => widget.trip != null;

  @override
  void initState() {
    super.initState();
    final trip = widget.trip;
    if (trip != null) {
      _notesCtrl.text = trip.notes ?? '';
      _priceCtrl.text = '${trip.pricePerKg}';
      _weight = trip.availableKg.toDouble().clamp(1, 100);
      _currency = trip.currency.isEmpty ? 'EUR' : trip.currency;
      _date = trip.travelDate;
    }
    getCountries().then((list) {
      if (!mounted) return;
      setState(() {
        _countries = list;
        if (trip != null) {
          _origin =
              list.where((c) => c.id == trip.originCountryId).firstOrNull;
          _destination =
              list.where((c) => c.id == trip.destinationCountryId).firstOrNull;
        } else {
          _origin = list.where((c) => c.id == 3).firstOrNull ??
              (list.isEmpty ? null : list.first);
        }
      });
    });
    if (trip != null && trip.status != 'active') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showCabaErrorSnack(context, AppStrings.cannotEditMatched);
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    _notesCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final existing = _date;
    final first = (_isEditing &&
            existing != null &&
            existing.isBefore(today))
        ? existing
        : today;
    var last = now.add(const Duration(days: 365));
    final initial = existing ?? now.add(const Duration(days: 1));
    if (initial.isAfter(last)) last = initial;
    final d = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(first) ? first : initial,
      firstDate: first,
      lastDate: last,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(primary: AppColors.primary),
        ),
        child: child!,
      ),
    );
    if (d != null) setState(() => _date = d);
  }

  Future<void> _post() async {
    if (_origin == null || _destination == null || _date == null) {
      showCabaErrorSnack(context, AppStrings.tripIncomplete);
      return;
    }
    setState(() => _loading = true);
    final ok = _isEditing
        ? await updateTrip(
            id: widget.trip!.id,
            originCountryId: _origin!.id,
            destinationCountryId: _destination!.id,
            travelDate: _date!,
            availableKg: _weight.toInt(),
            pricePerKg: int.tryParse(_priceCtrl.text) ?? 1,
            currency: _currency,
            notes: _notesCtrl.text.trim(),
          )
        : await createTrip(
            originCountryId: _origin!.id,
            destinationCountryId: _destination!.id,
            travelDate: _date!,
            availableKg: _weight.toInt(),
            pricePerKg: int.tryParse(_priceCtrl.text) ?? 1,
            currency: _currency,
            notes: _notesCtrl.text.trim(),
          );
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      await showCabaSuccessDialog(
        context,
        title: _isEditing ? AppStrings.tripUpdated : AppStrings.tripPostedAr,
        subtitle:
            _isEditing ? AppStrings.tripUpdatedSub : AppStrings.tripPostedSubAr,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } else {
      showCabaErrorSnack(
        context,
        _isEditing ? AppStrings.cannotEditMatched : AppStrings.tripFailed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currencies = {'EUR', 'USD', 'DZD', _currency}.toList();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CabaAppBar(
        titleText: _isEditing ? AppStrings.editTrip : AppStrings.addTripTitleAr,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CabaCountryDropdown(
                label: AppStrings.originCountry,
                countries: _countries,
                value: _origin,
                hint: AppStrings.chooseCountry,
                onChanged: (c) => setState(() => _origin = c),
              ),
              const SizedBox(height: 16),
              CabaCountryDropdown(
                label: AppStrings.destCountry,
                countries: _countries,
                value: _destination,
                hint: AppStrings.chooseCountry,
                onChanged: (c) => setState(() => _destination = c),
              ),
              const SizedBox(height: 16),
              Text(AppStrings.travelDateAr, style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 52,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: AppColors.textSecondary, size: 18),
                      const SizedBox(width: 10),
                      Text(
                        _date == null ? AppStrings.chooseDate : formatDateAr(_date!),
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: _date == null
                              ? AppColors.textHint
                              : AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppStrings.availableWeightAr,
                      style: AppTextStyles.titleMedium),
                  Text(
                    '${_weight.toInt()} ${AppStrings.kgAr}',
                    style: AppTextStyles.titleMedium
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
              Slider(
                value: _weight,
                min: 1,
                max: 100,
                divisions: 99,
                onChanged: (v) => setState(() => _weight = v),
              ),
              const SizedBox(height: 8),
              CabaTextField(
                label: AppStrings.pricePerKg,
                controller: _priceCtrl,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Text(AppStrings.currency, style: AppTextStyles.titleMedium),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: currencies.contains(_currency) ? _currency : 'EUR',
                items: currencies
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _currency = v ?? 'EUR'),
              ),
              const SizedBox(height: 16),
              CabaTextField(
                label: AppStrings.notesAr,
                hint: 'مثال: يمكن حمل أمتعة يدوية فقط',
                controller: _notesCtrl,
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              CabaButton(
                label: _isEditing ? AppStrings.save : AppStrings.postTripAr,
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
