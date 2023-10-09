import 'package:flutter/material.dart';

import '../../../../../core/constants/constants.dart';
import '../../../../../core/theme/theme.dart';

class CalendarChevronText extends StatelessWidget {
  const CalendarChevronText({
    required this.focusedDay,
    required this.textAlign,
    super.key,
  });

  final DateTime focusedDay;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: screenWidth / 3,
      child: Text(
        calendarTitleFormat.format(focusedDay),
        textAlign: textAlign,
        style: themeData.textTheme.bodyMedium!.copyWith(
          color: themeData.colorScheme.onPrimary.withOpacity(
            themeData.chevronTextOpacity,
          ),
        ),
      ),
    );
  }
}
