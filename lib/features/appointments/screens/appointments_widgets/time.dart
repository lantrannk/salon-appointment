import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/utils/common.dart';
import '../../../../core/widgets/widgets.dart';

class Time extends StatelessWidget {
  const Time({
    required this.startTime,
    required this.endTime,
    required this.text,
    super.key,
  });

  final DateTime startTime;
  final DateTime endTime;
  final String text;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SAIcons(
              icon: Assets.scheduleIcon,
              size: 16,
              color: colorScheme.tertiary,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              '${formatTime(startTime)} - ${formatTime(endTime)}',
              style: textTheme.bodyLarge!.copyWith(
                height: 24 / 14,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        Row(
          children: [
            const SizedBox(
              width: 32,
            ),
            Text(
              text,
              style: textTheme.bodySmall!.copyWith(
                color: colorScheme.primaryContainer,
              ),
            ),
          ],
        )
      ],
    );
  }
}
