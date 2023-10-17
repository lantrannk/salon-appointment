import 'package:flutter/material.dart';

class MonthCalendarCell extends StatelessWidget {
  const MonthCalendarCell({
    required this.day,
    this.dayColor,
    this.bgColor,
    this.iconColor,
    this.gradient,
    super.key,
  });

  final DateTime day;
  final Color? dayColor;
  final Color? bgColor;
  final Color? iconColor;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: bgColor ?? colorScheme.surface,
        gradient: gradient,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: Text(
          day.day.toString(),
          style: textTheme.bodySmall!.copyWith(
            height: 1.5,
            fontWeight: FontWeight.w500,
            color: dayColor ?? colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
