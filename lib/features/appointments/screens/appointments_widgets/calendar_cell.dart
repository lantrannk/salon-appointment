import 'package:flutter/material.dart';

import '../../../../core/constants/date_format.dart';
import '../../../../core/utils/common.dart';
import '../../../../core/widgets/widgets.dart';

class CalendarCell extends StatelessWidget {
  const CalendarCell({
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
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colorScheme.primary,
        gradient: gradient,
        borderRadius: borderRadius(day),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SAText.weekCalendarCell(
            text: dayOfWeekFormat.format(day),
            color: dayOfWeekColor ?? colorScheme.onPrimary.withOpacity(0.6429),
          ),
          SAText.weekCalendarCell(
            text: day.day.toString(),
            color: dayColor ?? colorScheme.onPrimary,
          ),
        ],
      ),
    );
  }
}

BorderRadiusGeometry? borderRadius(DateTime dateTime) {
  if (dateTime == rangeStartDay(dateTime)) {
    return const BorderRadius.only(
      topLeft: Radius.circular(8),
      bottomLeft: Radius.circular(8),
    );
  }

  if (dateTime == rangeEndDay(dateTime)) {
    return const BorderRadius.only(
      topRight: Radius.circular(8),
      bottomRight: Radius.circular(8),
    );
  }

  return null;
}
