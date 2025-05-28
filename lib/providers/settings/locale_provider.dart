import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await _savePreferences();
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', _locale.languageCode);
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString('languageCode') ?? 'en';
    _locale = Locale(code);
    notifyListeners();
  }
}