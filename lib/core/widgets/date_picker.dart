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
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(
            Assets.scheduleIcon,
            size: 24,
            color: Theme.of(context).colorScheme.secondaryContainer,
          ),
          Text(
            dateFormat.format(dateTime),
            style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  fontWeight: FontWeight.w400,
                ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: onPressed,
              icon: Icon(
                Assets.calendarIcon,
                size: 24,
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
