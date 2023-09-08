import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme() {
    if (themeMode == ThemeMode.dark) {
      themeMode = ThemeMode.light;
      return notifyListeners();
    }

    if (themeMode == ThemeMode.light) {
      themeMode = ThemeMode.dark;
      return notifyListeners();
    }
  }
}
