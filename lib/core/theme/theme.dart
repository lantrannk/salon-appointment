import 'package:flutter/material.dart';

import 'text_style.dart';

class AppColors {
  static const primary = Color(0xFF553BA3);
  static const onPrimary = Color(0xFFFFFFFF);
  static const secondary = Color(0xFF7D32BA);
  static const onSecondary = Color(0xFFF7F8FC);
  static const surface = Color(0xFFFFFFFF);
  static const onSurface = Color(0xFF0C122A);
  static const lightGrey = Color(0xFFD1D3DA);
  static const grey = Color(0xFFA4A8B2);
  static const tertiary = Color(0xFFFDA901);
  static const error = Color(0xFFCF2600);
  static const background = Color(0xFFF2F1F7);
  static const onBackground = Color(0xFFFFFFFF);
  static const darkPrimary = Color(0xFF4D329B);
  static const darkSecondary = Color(0xFF6816A5);
  static const darkSurface = Color(0xFF1A1D21);
  static const darkBackground = Color(0xFF252425);
  static const darkError = Color(0xFF871915);
}

class AppTheme {
  ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: _colorScheme,
      appBarTheme: _appBarTheme,
      textTheme: _textTheme,
      scaffoldBackgroundColor: _backgroundColor,
      primaryColor: _primaryColor,
      inputDecorationTheme: _inputDecorationTheme,
      iconTheme: _iconTheme,
      iconButtonTheme: _iconButtonTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: _colorScheme.onPrimary,
          backgroundColor: _colorScheme.primary,
          alignment: Alignment.center,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      timePickerTheme: _timePickerTheme,
      datePickerTheme: _datePickerTheme,
      bottomNavigationBarTheme: _bottomNavigationBarTheme,
      dialogTheme: _dialogTheme,
    );
  }

  TextTheme get _textTheme {
    return TextTheme(
      displayLarge: SATextStyle.displayLarge,
      displayMedium: SATextStyle.displayMedium,
      displaySmall: SATextStyle.displaySmall,
      titleLarge: SATextStyle.titleLarge,
      labelLarge: SATextStyle.labelLarge,
      labelMedium: SATextStyle.labelMedium,
      labelSmall: SATextStyle.labelSmall,
      bodyLarge: SATextStyle.bodyLarge,
      bodyMedium: SATextStyle.bodyMedium,
      bodySmall: SATextStyle.bodySmall,
    ).apply(
      displayColor: _colorScheme.onPrimary,
      bodyColor: _colorScheme.primaryContainer,
    );
  }

  Color get _primaryColor => AppColors.primary;

  Color get _backgroundColor => AppColors.background;

  ColorScheme get _colorScheme {
    return ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      error: AppColors.error,
      onError: AppColors.error,
      background: AppColors.background,
      onBackground: AppColors.onBackground,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      tertiary: AppColors.tertiary,
      primaryContainer: AppColors.grey,
      secondaryContainer: AppColors.lightGrey,
      shadow: AppColors.primary.withOpacity(shadowOpacity),
    );
  }

  double get shadowOpacity => 0.1601;

  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      color: _colorScheme.surface,
      elevation: 0,
      titleTextStyle: _textTheme.titleLarge!.copyWith(
        color: _colorScheme.onSurface,
      ),
      centerTitle: false,
    );
  }

  InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      hintStyle: _textTheme.labelSmall!.copyWith(
        color: _colorScheme.onPrimary,
      ),
      errorStyle: _textTheme.bodySmall?.copyWith(
        height: 0.7,
        color: _colorScheme.error,
      ),
      errorMaxLines: 1,
      contentPadding: const EdgeInsets.all(8),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: _focusedBorder,
      focusedErrorBorder: _focusedErrorBorder,
      filled: true,
      fillColor: _colorScheme.onPrimary.withOpacity(
        fillColorOpacity,
      ),
    );
  }

  double get fillColorOpacity => 0.235;

  InputBorder get _focusedBorder {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: _colorScheme.primary,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  OutlineInputBorder get _focusedErrorBorder {
    return OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: _colorScheme.error,
      ),
      borderRadius: BorderRadius.circular(8),
    );
  }

  IconThemeData get _iconTheme {
    return IconThemeData(
      color: _colorScheme.tertiary,
      size: 16,
    );
  }

  IconButtonThemeData get _iconButtonTheme {
    return IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStatePropertyAll<Color>(
          _colorScheme.onSurface,
        ),
        iconSize: const MaterialStatePropertyAll<double>(24),
      ),
    );
  }

  TimePickerThemeData get _timePickerTheme {
    return TimePickerThemeData(
      helpTextStyle: _textTheme.labelSmall!.copyWith(
        color: _colorScheme.primary,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: _colorScheme.surface,
    );
  }

  DatePickerThemeData get _datePickerTheme {
    return DatePickerThemeData(
      yearForegroundColor: MaterialStatePropertyAll<Color>(
        _colorScheme.primaryContainer,
      ),
    );
  }

  BottomNavigationBarThemeData get _bottomNavigationBarTheme {
    return BottomNavigationBarThemeData(
      backgroundColor: _colorScheme.surface,
    );
  }

  DialogTheme get _dialogTheme {
    return DialogTheme(
      backgroundColor: _colorScheme.surface,
      titleTextStyle: _textTheme.labelLarge!.copyWith(
        color: _colorScheme.onSurface,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: _textTheme.bodyLarge!.copyWith(
        color: _colorScheme.primaryContainer,
      ),
    );
  }
}

class AppDarkTheme extends AppTheme {
  final appTheme = AppTheme();

  @override
  ColorScheme get _colorScheme {
    return appTheme._colorScheme.copyWith(
      primary: AppColors.darkPrimary,
      onPrimary: AppColors.lightGrey,
      secondary: AppColors.darkSecondary,
      onSecondary: AppColors.grey,
      background: AppColors.darkBackground,
      onBackground: AppColors.lightGrey,
      surface: AppColors.darkSurface,
      onSurface: AppColors.lightGrey,
      error: AppColors.darkError,
    );
  }

  @override
  Color get _backgroundColor => AppColors.darkBackground;

  @override
  Color get _primaryColor => AppColors.darkPrimary;
}

extension ThemeDataHelper on ThemeData {
  double get calendarShadowOpacity => 0.3219;
  double get chevronTextOpacity => 0.3991;
  double get bgImageFilterOpacity => 0.5;
  double get calendarCellTextOpacity => 0.6429;
  double get todayBackgroundOpacity => 0.0798;
  double get fillColorOpacity => 0.2379;
  double get logoBackgroundOpacity => 0.1892;
  double get shadowOpacity => 0.1601;
  double get barrierColorOpacity => 0.05;
}
