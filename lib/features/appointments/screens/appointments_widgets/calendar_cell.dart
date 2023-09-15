import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/theme.dart';
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
    final ThemeData themeData = Theme.of(context);

    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: themeData.colorScheme.primary,
        gradient: gradient,
        borderRadius: borderRadius(day),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SAText.weekCalendarCell(
            text: dayOfWeekFormat.format(day),
            color: dayOfWeekColor ??
                themeData.colorScheme.onPrimary.withOpacity(
                  themeData.calendarCellTextOpacity,
                ),
          ),
          SAText.weekCalendarCell(
            text: day.day.toString(),
            color: dayColor ?? themeData.colorScheme.onPrimary,
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
