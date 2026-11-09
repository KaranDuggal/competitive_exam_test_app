import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const MethodChannel _linuxThemeChannel = MethodChannel(
    'ksvh/theme',
  );

  final SharedPreferences prefs;

  ThemeProvider(this.prefs) {
    _loadTheme();
  }

  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void _loadTheme() {
    final isDark = prefs.getBool('isDark') ?? false;

    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    unawaited(_syncLinuxWindowTheme());
    notifyListeners();
  }

  Future<void> _saveTheme() async {
    await prefs.setBool('isDark', _themeMode == ThemeMode.dark);
  }

  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    _saveTheme();
    unawaited(_syncLinuxWindowTheme());

    notifyListeners();
  }

  Future<void> _syncLinuxWindowTheme() async {
    if (defaultTargetPlatform != TargetPlatform.linux) {
      return;
    }

    try {
      await _linuxThemeChannel.invokeMethod<void>(
        'setDarkMode',
        _themeMode == ThemeMode.dark,
      );
    } on MissingPluginException catch (error) {
      debugPrint('Linux window theme channel is unavailable: $error');
    } on PlatformException catch (error) {
      debugPrint(
        'Failed to update Linux window theme: ${error.code}: ${error.message}',
      );
    }
  }
}
