import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';

class CalendarCell extends StatelessWidget {
  const CalendarCell({
    required this.dayOfWeek,
    required this.day,
    this.dayOfWeekColor,
    this.dayColor,
    this.bgColor,
    this.gradient,
    super.key,
  });

  final Color? dayOfWeekColor;
  final Color? dayColor;
  final Color? bgColor;
  final Gradient? gradient;
  final String dayOfWeek;
  final String day;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        gradient: gradient,
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SAText.weekCalendarCell(
            text: dayOfWeek,
            color: dayOfWeekColor ?? colorScheme.onPrimary.withOpacity(0.6429),
          ),
          SAText.weekCalendarCell(
            text: day,
            color: dayColor ?? colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}
