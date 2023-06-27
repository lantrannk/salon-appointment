import 'package:flutter/material.dart';

class ColorName {
  static const primaryColor = Color(0xFF553BA3);
  static const onSurfaceColor = Color(0xFF7D32BA);
  static const textColor = Color(0xFFFFFFFF);
  static const servicesColor = Color(0xFF0C122A);
  static const descriptionColor = Color(0xFFA4A8B2);
  static const breakTimeColor = Color(0xFF474F63);
  static const timeIconColor = Color(0xFFFDA901);
  static const iconButtonColor = Color(0xFFBFC8DC);
  static const errorColor = Color(0xFFCF2600);
  static const borderColor = Color(0xFFF7F8FC);
  static const backgroundColor = Color(0xFFFFFFFF);
  static const onBackgroundColor = Color(0x1F000000);
}

const ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: ColorName.primaryColor,
  onPrimary: ColorName.textColor,
  secondary: ColorName.servicesColor,
  onSecondary: ColorName.descriptionColor,
  secondaryContainer: ColorName.breakTimeColor,
  tertiary: ColorName.timeIconColor,
  onTertiary: ColorName.iconButtonColor,
  error: ColorName.errorColor,
  onError: ColorName.errorColor,
  background: ColorName.backgroundColor,
  onBackground: ColorName.onBackgroundColor,
  surface: ColorName.borderColor,
  onSurface: ColorName.onSurfaceColor,
);

class SATextTheme {
  static TextStyle _defaultTextStyle({
    required double fontSize,
    required FontWeight? fontWeight,
    double? lineHeight,
  }) =>
      TextStyle(
        fontStyle: FontStyle.normal,
        fontSize: fontSize,
        fontWeight: fontWeight,
        height: (lineHeight ?? fontSize) / fontSize,
        color: colorScheme.secondary,
      );

  static final TextTheme textTheme = TextTheme(
    displaySmall: _defaultTextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold,
    ),
    titleLarge: _defaultTextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      lineHeight: 30,
    ),
    labelLarge: _defaultTextStyle(
      fontSize: 17,
      fontWeight: FontWeight.w500,
      lineHeight: 25.5,
    ),
    labelMedium: _defaultTextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      lineHeight: 20,
    ),
    labelSmall: _defaultTextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w400,
      lineHeight: 20,
    ),
    bodyLarge: _defaultTextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: _defaultTextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      lineHeight: 20,
    ),
    bodySmall: _defaultTextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      lineHeight: 16,
    ),
  );
}

ThemeData themeData = ThemeData(
  brightness: Brightness.light,
  colorScheme: colorScheme,
  fontFamily: 'Poppins',
  appBarTheme: AppBarTheme(
    color: colorScheme.background,
    elevation: 0,
    centerTitle: false,
  ),
  scaffoldBackgroundColor: colorScheme.background,
  primaryColor: colorScheme.primary,
  iconTheme: IconThemeData(
    color: colorScheme.onSecondary,
    size: 24,
  ),
  inputDecorationTheme: InputDecorationTheme(
    hintStyle: SATextTheme.textTheme.labelSmall!.copyWith(
      color: colorScheme.onPrimary,
    ),
    contentPadding: const EdgeInsets.all(8),
    border: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: colorScheme.primary,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: colorScheme.error,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    filled: true,
    fillColor: colorScheme.onPrimary.withOpacity(0.235),
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: MaterialStatePropertyAll<Color>(colorScheme.onTertiary),
      iconSize: const MaterialStatePropertyAll<double>(24),
    ),
  ),
  textTheme: SATextTheme.textTheme,
  timePickerTheme: TimePickerThemeData(
    backgroundColor: colorScheme.background,
  ),
);
