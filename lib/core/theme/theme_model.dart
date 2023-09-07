import 'package:flutter/material.dart';

class ThemeModel extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.dark;

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
