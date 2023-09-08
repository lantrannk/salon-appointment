import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;
  Brightness brightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness;

  void toggleTheme() {
    if (brightness == Brightness.dark) {
      themeMode = ThemeMode.light;
      brightness = Brightness.light;
      return notifyListeners();
    } else {
      themeMode = ThemeMode.dark;
      brightness = Brightness.dark;
      return notifyListeners();
    }
  }
}
