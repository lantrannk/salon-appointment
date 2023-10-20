import 'package:flutter/material.dart';

import '../generated/l10n.dart';
import '../utils/common.dart';
import '../widgets/widgets.dart';

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
    final l10n = S.of(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SAText.timePicker(
          text: l10n.fromText,
        ),
        SAButton.outlined(
          onPressed: onStartTimePressed,
          height: context.getHeight(32),
          width: context.getWidth(90),
          outlinedColor: colorScheme.primaryContainer,
          child: SAText.timePicker(
            text: formatTime(startTime),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: SAText.timePicker(
            text: l10n.toText,
          ),
        ),
        SAButton.outlined(
          onPressed: onEndTimePressed,
          height: context.getHeight(32),
          width: context.getWidth(90),
          outlinedColor: colorScheme.primaryContainer,
          child: SAText.timePicker(
            text: formatTime(endTime),
          ),
        ),
      ],
    );
  }
}
