import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../app/theme.dart';
import '../../core/api/api_functions.dart';
import '../../core/api/api_service.dart';
import '../../core/api/shared_data.dart';
import '../../core/utils/country_flag.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_avatar.dart';
import '../../core/widgets/caba_button.dart';
import '../../core/widgets/caba_country_dropdown.dart';
import '../../core/widgets/caba_dialogs.dart';
import '../../core/widgets/caba_text_field.dart';
import '../../models/country_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _firstCtrl;
  late final TextEditingController _lastCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _cityCtrl;
  List<CountryModel> _countries = [];
  CountryModel? _country;
  String _role = 'both';
  String? _avatarUrl;
  bool _loading = false;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    final user = currentUser;
    _firstCtrl = TextEditingController(text: user.firstName);
    _lastCtrl = TextEditingController(text: user.lastName);
    _emailCtrl = TextEditingController(text: user.email);
    _phoneCtrl = TextEditingController(text: user.phone);
    _cityCtrl = TextEditingController(text: user.city ?? '');
    _role = user.role;
    _avatarUrl = user.avatarUrl;
    getCountries().then((list) {
      if (!mounted) return;
      setState(() {
        _countries = list;
        _country = countryFromPlace(user.country) ??
            list.where((c) => c.nicename == user.country).firstOrNull;
      });
    });
  }

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 900,
      imageQuality: 82,
    );
    if (picked == null) return;
    setState(() => _uploading = true);
    try {
      final ext = picked.path.split('.').last.toLowerCase();
      final url = await uploadImg(File(picked.path), ext);
      if (!mounted) return;
      setState(() => _avatarUrl = url);
    } catch (_) {
      if (mounted) showCabaErrorSnack(context, AppStrings.profileFailed);
    } finally {
      if (mounted) setState(() => _uploading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final ok = await updateProfile(
      fullName: '${_firstCtrl.text.trim()} ${_lastCtrl.text.trim()}'.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      country: _country?.nicename ?? '',
      city: _cityCtrl.text.trim(),
      role: _role,
      avatarUrl: _avatarUrl,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      await showCabaSuccessDialog(
        context,
        title: AppStrings.profileUpdated,
        subtitle: AppStrings.profileUpdatedSub,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } else {
      showCabaErrorSnack(context, AppStrings.profileFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CabaAppBar(titleText: AppStrings.editProfile),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
          children: [
            Center(
              child: GestureDetector(
                onTap: _uploading ? null : _pickPhoto,
                child: Stack(
                  children: [
                    CabaAvatar(
                      imageUrl: _avatarUrl,
                      fallback: _firstCtrl.text,
                      radius: 48,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: _uploading
                            ? const Padding(
                                padding: EdgeInsets.all(7),
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppStrings.changePhoto,
              textAlign: TextAlign.center,
              style: AppTextStyles.labelLarge,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CabaTextField(
                    label: AppStrings.firstName,
                    controller: _firstCtrl,
                    validator: (v) =>
                        v == null || v.trim().isEmpty
                            ? AppStrings.requiredField
                            : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CabaTextField(
                    label: AppStrings.lastName,
                    controller: _lastCtrl,
                    validator: (v) =>
                        v == null || v.trim().isEmpty
                            ? AppStrings.requiredField
                            : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CabaTextField(
              label: AppStrings.email,
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? AppStrings.requiredField : null,
            ),
            const SizedBox(height: 16),
            CabaTextField(
              label: AppStrings.phone,
              controller: _phoneCtrl,
              keyboardType: TextInputType.phone,
              validator: (v) =>
                  v == null || v.trim().isEmpty ? AppStrings.requiredField : null,
            ),
            const SizedBox(height: 16),
            CabaCountryDropdown(
              label: AppStrings.country,
              countries: _countries,
              value: _country,
              hint: AppStrings.chooseCountry,
              onChanged: (c) => setState(() => _country = c),
            ),
            const SizedBox(height: 16),
            CabaTextField(
              label: AppStrings.city,
              controller: _cityCtrl,
            ),
            const SizedBox(height: 20),
            Text(AppStrings.role, style: AppTextStyles.titleMedium),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _RoleChip(
                  label: AppStrings.roleSender,
                  selected: _role == 'sender',
                  onTap: () => setState(() => _role = 'sender'),
                ),
                _RoleChip(
                  label: AppStrings.roleTraveler,
                  selected: _role == 'traveler',
                  onTap: () => setState(() => _role = 'traveler'),
                ),
                _RoleChip(
                  label: AppStrings.roleBoth,
                  selected: _role == 'both',
                  onTap: () => setState(() => _role = 'both'),
                ),
              ],
            ),
            const SizedBox(height: 32),
            CabaButton(
              label: AppStrings.saveChanges,
              onTap: _save,
              isLoading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: AppTextStyles.titleMedium.copyWith(
            color: selected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
