import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  Brightness brightness = PlatformDispatcher.instance.platformBrightness;

  void toggleTheme() {
    final isDarkMode = brightness == Brightness.dark;
    themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    brightness = isDarkMode ? Brightness.light : Brightness.dark;

    return notifyListeners();
  }
}
