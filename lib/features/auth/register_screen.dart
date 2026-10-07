import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/api/api_functions.dart';
import '../../core/api/api_service.dart';
import '../../core/constants/app_strings.dart';
import '../../core/locale/app_locale.dart';
import '../../core/widgets/caba_app_bar.dart';
import '../../core/widgets/caba_avatar.dart';
import '../../core/widgets/caba_button.dart';
import '../../core/widgets/caba_dialogs.dart';
import '../../core/widgets/caba_text_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();
  bool _agreedToTerms = true;
  bool _loading = false;
  bool _uploading = false;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _firstNameCtrl.addListener(_onFirstNameChanged);
  }

  void _onFirstNameChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _firstNameCtrl.removeListener(_onFirstNameChanged);
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
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

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      showCabaErrorSnack(context, AppStrings.acceptTerms);
      return;
    }
    if (_uploading) return;
    setState(() => _loading = true);
    final phone = _phoneCtrl.text.trim().startsWith('+')
        ? _phoneCtrl.text.trim()
        : '+213${_phoneCtrl.text.trim()}';
    final ok = await registerUser(
      fullName: '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}',
      email: _emailCtrl.text.trim(),
      phone: phone,
      password: _passCtrl.text,
      avatarUrl: _avatarUrl,
    );
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      await showCabaSuccessDialog(
        context,
        title: AppStrings.accountCreatedAr,
        subtitle: AppStrings.accountCreatedSubAr,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      showCabaErrorSnack(context, AppStrings.registerFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appLocale,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CabaAppBar(titleText: AppStrings.register),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: _uploading ? null : _pickPhoto,
                      child: Stack(
                        children: [
                          CabaAvatar(
                            imageUrl: _avatarUrl,
                            fallback: _firstNameCtrl.text,
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
                    const SizedBox(height: 6),
                    Text(
                      _avatarUrl == null
                          ? AppStrings.addPhoto
                          : AppStrings.changePhoto,
                      style: AppTextStyles.labelLarge,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: CabaTextField(
                            label: AppStrings.firstName,
                            hint: AppStrings.firstNameHint,
                            controller: _firstNameCtrl,
                            validator: (v) => v == null || v.trim().isEmpty
                                ? AppStrings.requiredField
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: CabaTextField(
                            label: AppStrings.lastName,
                            hint: AppStrings.lastNameHint,
                            controller: _lastNameCtrl,
                            validator: (v) => v == null || v.trim().isEmpty
                                ? AppStrings.requiredField
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CabaTextField(
                      label: AppStrings.email,
                      hint: 'example@mail.com',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? AppStrings.enterEmail
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppStrings.phone, style: AppTextStyles.titleMedium),
                        const SizedBox(height: 8),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: TextFormField(
                            controller: _phoneCtrl,
                            keyboardType: TextInputType.phone,
                            style: AppTextStyles.bodyLarge,
                            decoration: const InputDecoration(
                              hintText: '6 12 34 56 78',
                              prefixIcon: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('🇩🇿', style: TextStyle(fontSize: 18)),
                                    SizedBox(width: 6),
                                    Text(
                                      '+213',
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              prefixIconConstraints: BoxConstraints(minWidth: 0),
                            ),
                            validator: (v) => v == null || v.trim().isEmpty
                                ? AppStrings.enterPhone
                                : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CabaTextField(
                      label: AppStrings.password,
                      controller: _passCtrl,
                      isPassword: true,
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      validator: (v) => v == null || v.length < 6
                          ? AppStrings.passwordTooShort
                          : null,
                    ),
                    const SizedBox(height: 16),
                    CabaTextField(
                      label: AppStrings.confirmPwd,
                      controller: _confirmPassCtrl,
                      isPassword: true,
                      prefixIcon: const Icon(
                        Icons.lock_outline_rounded,
                        color: AppColors.textSecondary,
                        size: 20,
                      ),
                      validator: (v) => v != _passCtrl.text
                          ? AppStrings.passwordMismatch
                          : null,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        SizedBox(
                          width: 22,
                          height: 22,
                          child: Checkbox(
                            value: _agreedToTerms,
                            onChanged: (v) =>
                                setState(() => _agreedToTerms = v!),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppStrings.agreeTerms,
                            style: AppTextStyles.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CabaButton(
                      label: AppStrings.createAcc,
                      onTap: _register,
                      isLoading: _loading || _uploading,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.hasAccount,
                          style: AppTextStyles.bodyMedium,
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            AppStrings.loginBtn,
                            style: AppTextStyles.labelLarge,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
