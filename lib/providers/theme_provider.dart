import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';

  final SharedPreferences _prefs;

  ThemeMode _themeMode = ThemeMode.light;

  ThemeProvider(this._prefs) {
    _loadTheme();
  }

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  void _loadTheme() {
    final String? theme = _prefs.getString(_themeKey);

    if (theme != null) {
      _themeMode =
          theme == 'dark'
              ? ThemeMode.dark
              : ThemeMode.light;

      notifyListeners();
    }
  }

  Future<void> toggleTheme() async {
    _themeMode =
        isDarkMode
            ? ThemeMode.light
            : ThemeMode.dark;

    await _prefs.setString(
      _themeKey,
      isDarkMode ? 'dark' : 'light',
    );

    notifyListeners();
  }
}