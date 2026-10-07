import 'package:flutter/material.dart';
import '../../app/theme.dart';
import '../../core/constants/app_strings.dart';
import '../../core/locale/app_locale.dart';
import '../../core/widgets/caba_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: appLocale,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: CabaAppBar(titleText: AppStrings.settings),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            children: [
              Text(AppStrings.language, style: AppTextStyles.headlineMedium),
              const SizedBox(height: 12),
              _LangTile(lang: AppLang.ar, title: AppStrings.langArabic),
              _LangTile(lang: AppLang.fr, title: AppStrings.langFrench),
              _LangTile(lang: AppLang.en, title: AppStrings.langEnglish),
            ],
          ),
        );
      },
    );
  }
}

class _LangTile extends StatelessWidget {
  final AppLang lang;
  final String title;

  const _LangTile({
    required this.lang,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final selected = appLocale.lang == lang;
    return InkWell(
      onTap: () => appLocale.setLang(lang),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.primary : AppColors.textHint,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: AppTextStyles.titleMedium),
            ),
          ],
        ),
      ),
    );
  }
}
