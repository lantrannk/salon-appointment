import 'package:flutter/material.dart';

class SAIndicator extends StatelessWidget {
  const SAIndicator({
    this.height,
    this.color,
    super.key,
  });

  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: height,
      child: Center(
        child: CircularProgressIndicator(
          color: color ?? colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class LoadingIndicator {
  bool isLoading = false;
  void show({
    required BuildContext context,
    double? height,
  }) {
    if (isLoading) {
      return;
    }
    isLoading = true;
    showDialog(
      context: context,
      builder: (context) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.05),
              Theme.of(context).colorScheme.secondary.withOpacity(0.05),
            ],
          ),
        ),
        child: SAIndicator(
          height: height,
        ),
      ),
    );
  }

  void hide(BuildContext context) {
    if (!isLoading) {
      return;
    }
    isLoading = false;
    Navigator.of(context).pop();
  }
}

LoadingIndicator loadingIndicator = LoadingIndicator();
