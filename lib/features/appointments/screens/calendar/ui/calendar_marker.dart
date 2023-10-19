import 'package:flutter/material.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/utils/common.dart';
import '../../../../../core/widgets/widgets.dart';
import '../../../model/appointment.dart';

class CalendarMarker extends StatelessWidget {
  const CalendarMarker({
    required this.events,
    required this.iconColor,
    required this.timeColor,
    super.key,
  });

  final List<Appointment> events;
  final Color iconColor;
  final Color timeColor;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(
        top: 7,
        left: 16,
        bottom: 4,
        right: 4,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: SAIcons(
              icon: Assets.differentIcon,
              color: iconColor,
              size: context.imageSize(12),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: (events.length <= ((context.getHeight(52) >= 44) ? 2 : 1))
                ? ListView.builder(
                    itemBuilder: (_, i) => Align(
                      alignment: Alignment.bottomRight,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SAText.timeCell(
                          text: timeFormat.format(events[i].startTime),
                          color: timeColor,
                        ),
                      ),
                    ),
                    itemCount: events.length,
                  )
                : Align(
                    alignment: Alignment.bottomRight,
                    child: Container(
                      padding: context.padding(horizontal: 4),
                      color: colorScheme.primaryContainer,
                      child: SAText.timeCell(
                        text: '${events.length}',
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
