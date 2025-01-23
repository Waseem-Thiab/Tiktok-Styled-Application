import 'package:flutter/material.dart';
import 'package:tiktok_styled_app/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData;
  bool _isDarkMode;

  ThemeProvider()
      : _themeData = lightTheme,
        _isDarkMode = false;

  ThemeData get themeData => _themeData;
  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _themeData = _isDarkMode ? darkTheme : lightTheme;
    notifyListeners();
  }
}
