import 'package:flutter/material.dart';

class AppointmentOverview extends StatelessWidget {
  const AppointmentOverview({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Expanded(
      child: ListView(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            alignment: Alignment.topLeft,
            width: double.infinity,
            height: 228,
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
        ],
      ),
    );
  }
}
