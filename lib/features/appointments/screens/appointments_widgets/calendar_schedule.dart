import 'package:flutter/material.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/date_format.dart';
import '../../../../core/utils.dart';
import '../../../../core/widgets/widgets.dart';
import '../../model/appointment.dart';

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
          padding: const EdgeInsets.only(
            top: 26,
            left: 27,
          ),
          child: SAIcons(
            icon: Assets.scheduleIcon,
            size: 20,
            color: colorScheme.onPrimary,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 8,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 22),
                SAText.calendarSchedule(
                  text: monthCharFormat.format(appointment.date),
                  style: textTheme.labelLarge!,
                ),
                const SizedBox(height: 7),
                SAText.calendarSchedule(
                  text:
                      '${formatTime(appointment.startTime)} - ${formatTime(appointment.endTime)}',
                  style: textTheme.bodyLarge!.copyWith(
                    height: 24 / 14,
                  ),
                ),
                const SizedBox(height: 12),
                SAText.calendarSchedule(
                  text: appointment.description,
                  style: textTheme.bodySmall!,
                  maxLines: 5,
                ),
                const Spacer(),
                SAButton.text(
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
              ],
            ),
          ),
        ),
      ],
    );
  }
}
