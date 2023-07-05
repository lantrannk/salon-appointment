import 'package:flutter/material.dart';

import '../../../../core/constants/date_format.dart';
import '../../../../core/widgets/widgets.dart';
import '../../model/appointment.dart';

class MonthCalendarCell extends StatelessWidget {
  const MonthCalendarCell({
    required this.text,
    required this.events,
    this.dayColor,
    this.timeColor,
    this.bgColor,
    this.iconColor,
    this.gradient,
    super.key,
  });

  final String text;
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
        horizontal: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        gradient: gradient,
        shape: BoxShape.rectangle,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // SAIcons(
              //   icon: Assets.differentIcon,
              //   color: iconColor ?? colorScheme.primary,
              //   size: 12,
              // ),
              // const SizedBox(width: 5),
              // SAIcons(
              //   icon: Assets.breakIcon,
              //   color: iconColor ?? colorScheme.primary,
              //   size: 12,
              // ),
              const SizedBox(width: 8),
              Flexible(
                child: SizedBox(
                  width: 15,
                  child: Text(
                    text,
                    style: textTheme.bodySmall!.copyWith(
                      height: 18 / 12,
                      color: dayColor ?? colorScheme.secondary,
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 0; i < events.length && i < 2; i++)
                SAText.timeCell(
                  text: timeFormat.format(events[i].startTime),
                  color: timeColor ?? colorScheme.onSecondary,
                ),
            ],
          )
        ],
      ),
    );
  }
}
