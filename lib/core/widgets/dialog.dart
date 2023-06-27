import 'package:flutter/material.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
import 'package:salon_appointment/core/widgets/widgets.dart';

class AlertConfirmDialog extends StatelessWidget {
  const AlertConfirmDialog({
    required this.title,
    required this.message,
    required this.onPressedRight,
    required this.onPressedLeft,
    this.textButtonRight,
    this.textButtonLeft,
    super.key,
  });

  final String title;
  final String message;
  final String? textButtonRight;
  final String? textButtonLeft;
  final VoidCallback onPressedRight;
  final VoidCallback onPressedLeft;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final l10n = S.of(context);

    return AlertDialog(
      actionsAlignment: MainAxisAlignment.end,
      title: Center(
        child: Text(
          title,
          style: textTheme.labelMedium!.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      content: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Text(
          message,
          style: textTheme.labelMedium!.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.w100,
          ),
        ),
      ),
      actions: [
        SAButton.text(
          onPressed: onPressedLeft,
          child: Text(
            textButtonLeft ?? l10n.noConfirm,
            style: textTheme.labelMedium!.copyWith(
              color: colorScheme.onTertiary,
            ),
          ),
        ),
        SAButton.text(
          onPressed: onPressedRight,
          child: Text(
            textButtonRight ?? l10n.yesConfirm,
            style: textTheme.labelMedium!.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  // Show the AlertWidget as a dialog box and have two options yes, no
  static void show({
    required BuildContext context,
    required String title,
    required String message,
    required VoidCallback onPressedLeft,
    required VoidCallback onPressedRight,
    String? textButtonRight,
    String? textButtonLeft,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertConfirmDialog(
        title: title,
        message: message,
        textButtonLeft: textButtonLeft ?? S.of(context).noConfirm,
        textButtonRight: textButtonRight ?? S.of(context).yesConfirm,
        onPressedLeft: onPressedLeft,
        onPressedRight: onPressedRight,
      ),
    );
  }
}
