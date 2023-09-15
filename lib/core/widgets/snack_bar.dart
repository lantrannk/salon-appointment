import 'package:flutter/material.dart';

class SASnackBar {
  static void show({
    required BuildContext context,
    required String message,
    required bool isSuccess,
    Duration? duration,
  }) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final snackBar = SnackBar(
      elevation: 5,
      behavior: SnackBarBehavior.floating,
      duration: duration ?? const Duration(seconds: 3),
      backgroundColor: isSuccess ? colorScheme.primary : colorScheme.error,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Text(message),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
