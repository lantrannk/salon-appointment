import 'package:flutter/material.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../model/appointment.dart';

class MonthCalendarCell extends StatelessWidget {
  const MonthCalendarCell({
    required this.day,
    required this.events,
    this.dayColor,
    this.timeColor,
    this.bgColor,
    this.iconColor,
    this.gradient,
    super.key,
  });

  final DateTime day;
  final List<Appointment> events;
  final Color? dayColor;
  final Color? timeColor;
  final Color? bgColor;
  final Color? iconColor;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        color: bgColor ?? colorScheme.surface,
        gradient: gradient,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              events.isNotEmpty
                  ? SAIcons(
                      icon: Assets.differentIcon,
                      color: iconColor ?? colorScheme.primary,
                      size: 12,
                    )
                  : const SizedBox(),
              const SizedBox(width: 5),
              Flexible(
                child: SizedBox(
                  width: 15,
                  child: Text(
                    day.day.toString(),
                    style: textTheme.bodySmall!.copyWith(
                      height: 18 / 12,
                      fontWeight: FontWeight.w500,
                      color: dayColor ?? colorScheme.onSurface,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 2,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (int i = 0; i < events.length && i < 2; i++)
                  Expanded(
                    child: SAText.timeCell(
                      text: timeFormat.format(events[i].startTime),
                      color: timeColor ?? colorScheme.primaryContainer,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
