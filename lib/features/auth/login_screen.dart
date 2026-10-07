import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../app/routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/caba_button.dart';
import '../../core/widgets/caba_logo.dart';
import '../../core/widgets/caba_text_field.dart';
import '../../core/api/api_functions.dart';
import '../../core/widgets/caba_dialogs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _rememberMe = true;
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    final ok = await login(_emailCtrl.text, _passCtrl.text);
    if (!mounted) return;
    setState(() => _loading = false);
    if (ok) {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      showCabaErrorSnack(context, AppStrings.loginFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                const Center(child: CabaWordmark(logoSize: 42)),
                const SizedBox(height: 36),
                Text(AppStrings.welcomeAr, style: AppTextStyles.displayMedium),
                const SizedBox(height: 6),
                Text(AppStrings.loginSubAr, style: AppTextStyles.bodyMedium),
                const SizedBox(height: 28),
                CabaTextField(
                  label: AppStrings.emailAr,
                  hint: 'example@mail.com',
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'أدخل البريد الإلكتروني' : null,
                ),
                const SizedBox(height: 16),
                CabaTextField(
                  label: AppStrings.passwordAr,
                  controller: _passCtrl,
                  isPassword: true,
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                  validator: (v) => v == null || v.length < 6
                      ? 'كلمة المرور قصيرة جداً'
                      : null,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    SizedBox(
                      width: 22,
                      height: 22,
                      child: Checkbox(
                        value: _rememberMe,
                        onChanged: (v) => setState(() => _rememberMe = v!),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppStrings.rememberAr,
                      style: AppTextStyles.bodyMedium,
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        AppStrings.forgotAr,
                        style: AppTextStyles.labelLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CabaButton(
                  label: AppStrings.loginBtnAr,
                  onTap: _login,
                  isLoading: _loading,
                ),
                const SizedBox(height: 24),
                if (false)
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          AppStrings.orViaAr,
                          style: AppTextStyles.bodySmall,
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                const SizedBox(height: 16),
                if (false)
                  Row(
                    children: [
                      Expanded(
                        child: _SocialButton(
                          label: 'Google',
                          icon: const Text(
                            'G',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEA4335),
                            ),
                          ),
                          onTap: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SocialButton(
                          label: 'Apple',
                          icon: const Icon(
                            Icons.apple,
                            size: 22,
                            color: Colors.black,
                          ),
                          onTap: () {},
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStrings.noAccountAr,
                      style: AppTextStyles.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.register),
                      child: Text(
                        AppStrings.registerAr,
                        style: AppTextStyles.labelLarge,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
