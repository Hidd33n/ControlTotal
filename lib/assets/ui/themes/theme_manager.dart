import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'light_theme.dart' as light;
import 'dark_theme.dart' as dark;

class ThemeManager {
  static final String _themePreferenceKey = 'theme_preference';
  static ThemeMode _currentTheme = ThemeMode.light;
  static final StreamController<ThemeMode> _themeController =
      StreamController<ThemeMode>.broadcast();

  static ThemeMode get currentThemeMode => _currentTheme;

  static Stream<ThemeMode> get themeChanges => _themeController.stream;

  static Future<void> setTheme(ThemeMode themeMode) async {
    _currentTheme = themeMode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_themePreferenceKey, themeMode.toString());
    print('Theme set to: $themeMode');
    _themeController.add(themeMode); // Notificar cambios a los listeners
  }

  static ThemeData getThemeData(ThemeMode themeMode) {
    print('Getting theme data for mode: $themeMode');
    return themeMode == ThemeMode.light ? light.lightTheme : dark.darkTheme;
  }

  static Future<ThemeMode> getTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String themeString = prefs.getString(_themePreferenceKey) ?? 'light';
    final ThemeMode selectedTheme = themeString == 'dark'
        ? ThemeMode.dark
        : themeString == 'light'
            ? ThemeMode.light
            : ThemeMode.system;
    print('Current theme: $selectedTheme');
    return selectedTheme;
  }
}
