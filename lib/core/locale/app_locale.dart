import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kLocaleKey = 'caba_locale';

enum AppLang { ar, fr, en }

class AppLocale extends ChangeNotifier {
  AppLang _lang = AppLang.ar;

  AppLang get lang => _lang;

  Locale get locale {
    switch (_lang) {
      case AppLang.ar:
        return const Locale('ar', 'DZ');
      case AppLang.fr:
        return const Locale('fr', 'FR');
      case AppLang.en:
        return const Locale('en', 'US');
    }
  }

  TextDirection get textDirection =>
      _lang == AppLang.ar ? TextDirection.rtl : TextDirection.ltr;

  bool get isRtl => _lang == AppLang.ar;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _lang = AppLang.values.firstWhere(
      (e) => e.name == prefs.getString(kLocaleKey),
      orElse: () => AppLang.ar,
    );
    notifyListeners();
  }

  Future<void> setLang(AppLang lang) async {
    if (_lang == lang) return;
    _lang = lang;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kLocaleKey, lang.name);
  }
}

final appLocale = AppLocale();
