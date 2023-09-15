import 'package:flutter/material.dart';

class SATextStyle {
  static TextStyle _defaultTextStyle({
    required double fontSize,
    double? lineHeight,
    FontWeight? fontWeight,
  }) {
    return TextStyle(
      fontStyle: FontStyle.normal,
      fontSize: fontSize,
      fontWeight: fontWeight ?? _regular,
      height: (lineHeight ?? fontSize) / fontSize,
    );
  }

  static const FontWeight _regular = FontWeight.w400;
  static const FontWeight _medium = FontWeight.w500;

  static final TextStyle displayLarge = _defaultTextStyle(
    fontSize: 220,
    fontWeight: _medium,
  );

  static final TextStyle displayMedium = _defaultTextStyle(
    fontSize: 70,
    fontWeight: _medium,
  );

  static final TextStyle displaySmall = _defaultTextStyle(
    fontSize: 30,
    fontWeight: _medium,
  );

  static final TextStyle titleLarge = _defaultTextStyle(
    fontSize: 20,
    lineHeight: 30,
    fontWeight: _medium,
  );

  static final TextStyle labelLarge = _defaultTextStyle(
    fontSize: 17,
    lineHeight: 25.5,
    fontWeight: _medium,
  );

  static final TextStyle labelMedium = _defaultTextStyle(
    fontSize: 16,
    lineHeight: 20,
    fontWeight: _medium,
  );

  static final TextStyle labelSmall = _defaultTextStyle(
    fontSize: 15,
    lineHeight: 20,
  );

  static final TextStyle bodyLarge = _defaultTextStyle(
    fontSize: 14,
    lineHeight: 20,
  );

  static final TextStyle bodyMedium = _defaultTextStyle(
    fontSize: 13,
    lineHeight: 20,
    fontWeight: _medium,
  );

  static final TextStyle bodySmall = _defaultTextStyle(
    fontSize: 12,
    lineHeight: 16,
  );
}
