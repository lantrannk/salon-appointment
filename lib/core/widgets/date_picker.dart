import 'package:flutter/material.dart';

import '../constants/assets.dart';
import '../constants/date_format.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    required this.dateTime,
    required this.onPressed,
    super.key,
  });

  final VoidCallback onPressed;
  final DateTime dateTime;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Assets.scheduleIcon,
            color: colorScheme.secondaryContainer,
          ),
          Text(
            dateFormat.format(dateTime),
            style: textTheme.labelLarge!.copyWith(
              color: colorScheme.secondaryContainer,
              fontWeight: FontWeight.w400,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(
                Assets.calendarIcon,
                color: colorScheme.secondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
