import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists and broadcasts the app UI [Locale] (welcome + settings language picker).
class LocaleController extends ChangeNotifier {
  LocaleController(this._locale);

  Locale _locale;

  Locale get locale => _locale;

  static const String _prefKey = 'app_locale_code';

  String get currentCode => codeFromLocale(_locale);

  static Future<Locale> loadSavedLocale() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? code = prefs.getString(_prefKey);
    if (code == null || code.isEmpty) {
      return const Locale('en');
    }
    return localeFromCode(code);
  }

  static Locale localeFromCode(String code) {
    switch (code) {
      case 'zh_HK':
        return const Locale('zh', 'HK');
      case 'en':
      default:
        return const Locale('en');
    }
  }

  static String codeFromLocale(Locale locale) {
    if (locale.languageCode == 'zh') {
      if (locale.countryCode == 'HK') {
        return 'zh_HK';
      }
      return 'zh_HK';
    }
    return locale.languageCode;
  }

  Future<void> setLocaleFromCode(String code) async {
    final Locale next = localeFromCode(code);
    if (_locale == next) {
      return;
    }
    _locale = next;
    notifyListeners();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefKey, code);
  }
}
