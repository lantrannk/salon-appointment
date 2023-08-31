import 'package:flutter/material.dart';

import '../../../../core/constants/assets.dart';
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
    final ThemeData themeData = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SAIcons(
              icon: Assets.scheduleIcon,
              size: 20,
              color: themeData.colorScheme.tertiary,
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              '${formatTime(startTime)} - ${formatTime(endTime)}',
              style: themeData.textTheme.bodyLarge!.copyWith(
                height: 24 / 14,
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
              style: themeData.textTheme.bodySmall!.copyWith(
                color: themeData.colorScheme.onSecondary,
              ),
            ),
          ],
        )
      ],
    );
  }
}
