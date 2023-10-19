import 'package:flutter/material.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/utils/common.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../model/appointment.dart';

class CalendarSchedule extends StatelessWidget {
  const CalendarSchedule({
    required this.appointment,
    required this.countOfAppointments,
    this.onPressed,
    super.key,
  });

  final Appointment appointment;
  final int countOfAppointments;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: context.padding(
            top: 26,
            left: 27,
            right: 4,
          ),
          child: SAIcons(
            icon: Assets.scheduleIcon,
            size: 20,
            color: colorScheme.onPrimary,
          ),
        ),
        Expanded(
          child: Padding(
            padding: context.padding(
              vertical: 22,
              horizontal: 8,
            ),
            child: ListView(
              children: [
                SAText.calendarSchedule(
                  text: monthCharFormat.format(appointment.date),
                  style: textTheme.labelLarge!,
                ),
                context.sizedBox(height: 7),
                SAText.calendarSchedule(
                  text:
                      '${formatTime(appointment.startTime)} - ${formatTime(appointment.endTime)}',
                  style: textTheme.bodyLarge!.copyWith(
                    height: 1.7,
                  ),
                ),
                context.sizedBox(height: 12),
                SingleChildScrollView(
                  child: SAText.calendarSchedule(
                    text: appointment.description,
                    style: textTheme.bodySmall!,
                    maxLines: 5,
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SAButton.text(
                    onPressed: onPressed,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    child: Padding(
                      padding: EdgeInsets.zero,
                      child: SAText.calendarSchedule(
                        text: 'Show appointments ($countOfAppointments)',
                        style: textTheme.bodySmall!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
