import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _followSystem = true;

  ThemeMode get themeMode => _themeMode;
  bool get followSystem => _followSystem;

  Future<void> toggleTheme(ThemeMode mode) async {
    _themeMode = mode;
    _followSystem = (mode == ThemeMode.system);
    await _savePreferences();
    notifyListeners();
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', _themeMode.index);
  }

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt('themeMode') ?? ThemeMode.system.index;
    _themeMode = ThemeMode.values[index];
    notifyListeners();
  }
}