import 'package:flutter/material.dart';

class ColorName {
  static const primaryColor = Color(0xFF553BA3);
  static const onPrimaryColor = Color(0xFFFFFFFF);
  static const secondaryColor = Color(0xFF7D32BA);
  static const onSecondaryColor = Color(0xFFF7F8FC);
  static const surfaceColor = Color(0xFFFFFFFF);
  static const onSurfaceColor = Color(0xFF0C122A);
  static const lightGreyColor = Color(0xFFD1D3DA);
  static const greyColor = Color(0xFFA4A8B2);
  static const darkGreyColor = Color(0xFF474F63);
  static const tertiaryColor = Color(0xFFFDA901);
  static const errorColor = Color(0xFFCF2600);
  static const backgroundColor = Color(0xFFF2F1F7);
  static const onBackgroundColor = Color(0xFFFFFFFF);
}

const ColorScheme colorScheme = ColorScheme(
  brightness: Brightness.light,
  primary: ColorName.primaryColor,
  onPrimary: ColorName.onPrimaryColor,
  secondary: ColorName.secondaryColor,
  onSecondary: ColorName.onSecondaryColor,
  error: ColorName.errorColor,
  onError: ColorName.errorColor,
  background: ColorName.backgroundColor,
  onBackground: ColorName.onBackgroundColor,
  surface: ColorName.surfaceColor,
  onSurface: ColorName.onSurfaceColor,
  tertiary: ColorName.tertiaryColor,
  primaryContainer: ColorName.greyColor,
  secondaryContainer: ColorName.lightGreyColor,
  tertiaryContainer: ColorName.darkGreyColor,
);

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
        color: colorScheme.onPrimary,
      );

  static final TextTheme textTheme = TextTheme(
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

ThemeData themeData = ThemeData(
  brightness: Brightness.light,
  colorScheme: colorScheme,
  fontFamily: 'Poppins',
  appBarTheme: AppBarTheme(
    color: colorScheme.surface,
    elevation: 0,
    titleTextStyle: SATextTheme.textTheme.titleLarge!.copyWith(
      color: colorScheme.onSurface,
      fontWeight: FontWeight.w500,
    ),
    centerTitle: false,
  ),
  textTheme: SATextTheme.textTheme,
  scaffoldBackgroundColor: colorScheme.background,
  primaryColor: colorScheme.primary,
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
  iconTheme: IconThemeData(
    color: colorScheme.tertiary,
    size: 16,
  ),
  iconButtonTheme: IconButtonThemeData(
    style: ButtonStyle(
      iconColor: MaterialStatePropertyAll<Color>(
        colorScheme.tertiaryContainer,
      ),
      iconSize: const MaterialStatePropertyAll<double>(24),
    ),
  ),
  timePickerTheme: TimePickerThemeData(
    helpTextStyle: SATextTheme.textTheme.labelSmall!.copyWith(
      color: colorScheme.primary,
      fontWeight: FontWeight.w500,
    ),
    backgroundColor: colorScheme.surface,
  ),
  datePickerTheme: DatePickerThemeData(
    yearForegroundColor: MaterialStatePropertyAll<Color>(
      colorScheme.primaryContainer,
    ),
  ),
);
