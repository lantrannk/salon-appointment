import 'package:flutter/material.dart';

/// Screen height constant from Figma design
const int designScreenHeight = 812;

/// Screen width constant from Figma design
const int designScreenWidth = 375;

/// Responsive by device screen size
extension Responsive on BuildContext {
  double get screenHeight => MediaQuery.sizeOf(this).height;

  double get screenWidth => MediaQuery.sizeOf(this).width;

  double getHeight(double height) => height * screenHeight / designScreenHeight;

  double getWidth(double width) => width * screenWidth / designScreenWidth;

  SizedBox sizedBox({
    double height = 0.0,
    double width = 0.0,
  }) {
    return SizedBox(
      height: getHeight(height),
      width: getWidth(width),
    );
  }

  EdgeInsets padding({
    double top = 0.0,
    double bottom = 0.0,
    double left = 0.0,
    double right = 0.0,
    double vertical = 0.0,
    double horizontal = 0.0,
    double all = 0.0,
  }) {
    return all != 0.0
        ? EdgeInsets.all(_getSmallerSize(all))
        : vertical != 0.0 || horizontal != 0.0
            ? EdgeInsets.symmetric(
                vertical: getHeight(vertical),
                horizontal: getWidth(horizontal),
              )
            : EdgeInsets.only(
                top: getHeight(top),
                bottom: getHeight(bottom),
                left: getWidth(left),
                right: getWidth(right),
              );
  }

  EdgeInsets margin({
    double top = 0.0,
    double bottom = 0.0,
    double left = 0.0,
    double right = 0.0,
    double vertical = 0.0,
    double horizontal = 0.0,
    double all = 0.0,
  }) {
    return all != 0.0
        ? EdgeInsets.all(_getSmallerSize(all))
        : vertical != 0.0 || horizontal != 0.0
            ? EdgeInsets.symmetric(
                vertical: getHeight(vertical),
                horizontal: getWidth(horizontal),
              )
            : EdgeInsets.only(
                top: getHeight(top),
                bottom: getHeight(bottom),
                left: getWidth(left),
                right: getWidth(right),
              );
  }

  /// Scale image size by screen size
  double imageSize(double size) {
    return _getSmallerSize(size);
  }

  /// Get the smaller size
  double _getSmallerSize(double size) {
    return getHeight(size) >= getWidth(size) ? getWidth(size) : getHeight(size);
  }
}
