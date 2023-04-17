import 'package:flutter/material.dart';
import 'package:salon_appointment/core/utils.dart';
import 'package:salon_appointment/core/widgets/text.dart';

import '../generated/l10n.dart';

class TimePicker extends StatelessWidget {
  const TimePicker({
    required this.startTime,
    required this.endTime,
    required this.onStartTimePressed,
    required this.onEndTimePressed,
    super.key,
  });

  final DateTime startTime;
  final DateTime endTime;
  final VoidCallback onStartTimePressed;
  final VoidCallback onEndTimePressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SAText.timePicker(text: S.of(context).fromText),
        OutlinedButton(
          onPressed: onStartTimePressed,
          child: SAText.timePicker(
            text: formatTime(startTime),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SAText.timePicker(text: S.of(context).toText),
        ),
        OutlinedButton(
          onPressed: onEndTimePressed,
          child: SAText.timePicker(
            text: formatTime(endTime),
          ),
        ),
      ],
    );
  }
}
