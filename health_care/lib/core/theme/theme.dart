import 'package:flutter/material.dart';

ThemeData theme = ThemeData(
  colorScheme: _colorScheme,
  textTheme: _textTheme,
);

TextStyle defaultTextStyle({
  required double fontSize,
  required FontWeight fontWeight,
  Color? color,
}) =>
    TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: 1.3,
      letterSpacing: 0.03,
    );

ColorScheme _colorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff8E56C5),
  onPrimary: Color(0xff7949AB),
  primaryContainer: Color(0xffCCB3E6),
  secondary: Color(0xff045C67),
  onSecondary: Color(0xffCCB3E6),
  error: Color(0xffEB4D53),
  onError: Color(0xffFFFFFF),
  background: Color(0xffFFFFFF),
  onBackground: Color(0xff000000),
  surface: Color(0xffAF1E9C),
  onSurface: Color(0xffFFFFFF),
  tertiary: Color(0xffC4C8C9),
);

TextTheme _textTheme = TextTheme(
  titleLarge: defaultTextStyle(
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: _colorScheme.secondary,
  ),
  titleMedium: defaultTextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  ),
  titleSmall: defaultTextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
  ),
  bodyLarge: defaultTextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: _colorScheme.onSurface,
  ),
  bodyMedium: defaultTextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: _colorScheme.tertiary,
  ),
  bodySmall: defaultTextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: _colorScheme.onSurface,
  ),
);
