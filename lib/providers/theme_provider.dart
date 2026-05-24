import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  final SharedPreferences prefs;

  ThemeProvider(this.prefs) {
    _loadTheme();
  }

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void _loadTheme() {
    final isDark = prefs.getBool('isDark') ?? false;

    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  Future<void> _saveTheme() async {
    await prefs.setBool('isDark', _themeMode == ThemeMode.dark);
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    _saveTheme();

    notifyListeners();
  }
}
