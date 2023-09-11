import 'package:flutter/material.dart';

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

class SATextTheme {
  static TextStyle _defaultTextStyle({
    required double fontSize,
    double? lineHeight,
  }) =>
      TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: fontSize,
        fontWeight: FontWeight.normal,
        height: (lineHeight ?? fontSize) / fontSize,
      );

  static final TextTheme textTheme = TextTheme(
    displayLarge: _defaultTextStyle(
      fontSize: 220,
    ),
    displayMedium: _defaultTextStyle(
      fontSize: 70,
    ),
    displaySmall: _defaultTextStyle(
      fontSize: 30,
    ),
    titleLarge: _defaultTextStyle(
      fontSize: 20,
      lineHeight: 30,
    ),
    labelLarge: _defaultTextStyle(
      fontSize: 17,
      lineHeight: 25.5,
    ),
    labelMedium: _defaultTextStyle(
      fontSize: 16,
      lineHeight: 20,
    ),
    labelSmall: _defaultTextStyle(
      fontSize: 15,
      lineHeight: 20,
    ),
    bodyLarge: _defaultTextStyle(
      fontSize: 14,
      lineHeight: 20,
    ),
    bodyMedium: _defaultTextStyle(
      fontSize: 13,
      lineHeight: 20,
    ),
    bodySmall: _defaultTextStyle(
      fontSize: 12,
      lineHeight: 16,
    ),
  );
}

class AppTheme {
  ThemeData get themeData {
    return ThemeData(
      brightness: Brightness.light,
      colorScheme: _colorScheme,
      appBarTheme: _appBarTheme,
      textTheme: SATextTheme.textTheme,
      scaffoldBackgroundColor: _backgroundColor,
      primaryColor: _primaryColor,
      inputDecorationTheme: _inputDecorationTheme,
      iconTheme: _iconTheme,
      iconButtonTheme: _iconButtonTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          // textStyle: SATextTheme.textTheme.labelMedium,
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
    );
  }

  Color get _primaryColor => AppColors.primary;

  Color get _backgroundColor => AppColors.background;

  ColorScheme get _colorScheme {
    return const ColorScheme(
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
    );
  }

  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      color: AppColors.surface,
      elevation: 0,
      titleTextStyle: SATextTheme.textTheme.titleLarge!.copyWith(
        color: AppColors.onSurface,
        fontWeight: FontWeight.w500,
      ),
      centerTitle: false,
    );
  }

  InputDecorationTheme get _inputDecorationTheme {
    return InputDecorationTheme(
      hintStyle: SATextTheme.textTheme.labelSmall!.copyWith(
        color: AppColors.onPrimary,
      ),
      contentPadding: const EdgeInsets.all(8),
      border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: _focusedBorder,
      focusedErrorBorder: _focusedErrorBorder,
      filled: true,
      fillColor: AppColors.onPrimary.withOpacity(0.235),
    );
  }

  IconThemeData get _iconTheme {
    return const IconThemeData(
      color: AppColors.tertiary,
      size: 16,
    );
  }

  IconButtonThemeData get _iconButtonTheme {
    return const IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStatePropertyAll<Color>(
          AppColors.onSurface,
        ),
        iconSize: MaterialStatePropertyAll<double>(24),
      ),
    );
  }

  TimePickerThemeData get _timePickerTheme {
    return TimePickerThemeData(
      helpTextStyle: SATextTheme.textTheme.labelSmall!.copyWith(
        color: AppColors.primary,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: AppColors.surface,
    );
  }

  DatePickerThemeData get _datePickerTheme {
    return const DatePickerThemeData(
      yearForegroundColor: MaterialStatePropertyAll<Color>(
        AppColors.grey,
      ),
    );
  }

  BottomNavigationBarThemeData get _bottomNavigationBarTheme {
    return const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
    );
  }
}

InputBorder get _focusedBorder {
  return OutlineInputBorder(
    borderSide: const BorderSide(
      width: 2,
      color: AppColors.primary,
    ),
    borderRadius: BorderRadius.circular(8),
  );
}

OutlineInputBorder get _focusedErrorBorder {
  return OutlineInputBorder(
    borderSide: const BorderSide(
      width: 2,
      color: AppColors.error,
    ),
    borderRadius: BorderRadius.circular(8),
  );
}

class AppDarkTheme extends AppTheme {
  final appTheme = AppTheme();

  @override
  ColorScheme get _colorScheme {
    return appTheme._colorScheme.copyWith(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      background: AppColors.darkBackground,
      onBackground: AppColors.lightGrey,
      surface: AppColors.darkSurface,
      onSurface: AppColors.lightGrey,
      error: AppColors.darkError,
      primaryContainer: AppColors.grey,
    );
  }

  @override
  Color get _backgroundColor => AppColors.darkBackground;

  @override
  Color get _primaryColor => AppColors.darkPrimary;

  @override
  AppBarTheme get _appBarTheme {
    return AppBarTheme(
      color: AppColors.darkSurface,
      elevation: 0,
      titleTextStyle: SATextTheme.textTheme.titleLarge?.copyWith(
        color: AppColors.onPrimary,
        fontWeight: FontWeight.w500,
      ),
      centerTitle: false,
    );
  }

  @override
  IconThemeData get _iconTheme {
    return const IconThemeData(
      color: AppColors.grey,
      size: 16,
    );
  }

  @override
  IconButtonThemeData get _iconButtonTheme {
    return const IconButtonThemeData(
      style: ButtonStyle(
        iconColor: MaterialStatePropertyAll<Color>(
          AppColors.grey,
        ),
        iconSize: MaterialStatePropertyAll<double>(24),
      ),
    );
  }

  @override
  TimePickerThemeData get _timePickerTheme {
    return TimePickerThemeData(
      helpTextStyle: SATextTheme.textTheme.labelSmall!.copyWith(
        color: AppColors.grey,
        fontWeight: FontWeight.w500,
      ),
      backgroundColor: AppColors.darkSurface,
    );
  }

  @override
  DatePickerThemeData get _datePickerTheme {
    return DatePickerThemeData(
      headerHelpStyle: SATextTheme.textTheme.labelSmall?.copyWith(
        color: AppColors.grey,
        fontWeight: FontWeight.w500,
      ),
      yearForegroundColor: const MaterialStatePropertyAll<Color>(
        AppColors.grey,
      ),
      backgroundColor: AppColors.darkSurface,
    );
  }

  @override
  BottomNavigationBarThemeData get _bottomNavigationBarTheme {
    return const BottomNavigationBarThemeData(
      backgroundColor: AppColors.darkSurface,
    );
  }
}
