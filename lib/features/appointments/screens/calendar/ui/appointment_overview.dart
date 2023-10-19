import 'package:flutter/material.dart';
import 'package:salon_appointment/core/utils/common.dart';

class AppointmentOverview extends StatelessWidget {
  const AppointmentOverview({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Flexible(
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        alignment: Alignment.topLeft,
        width: double.infinity,
        height: context.getHeight(228),
        constraints: const BoxConstraints(
          maxHeight: 228,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              colorScheme.primary,
              colorScheme.secondary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: child,
      ),
    );
  }
}
