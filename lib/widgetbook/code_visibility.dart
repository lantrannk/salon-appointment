import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

class SourceCodeVisibility extends StatelessWidget {
  const SourceCodeVisibility({
    required this.sourceCode,
    super.key,
  });

  final String sourceCode;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Visibility(
      visible: context.knobs.boolean(
        label: 'Show source code',
      ),
      child: Container(
        color: colorScheme.onBackground,
        padding: const EdgeInsets.all(4),
        child: Text(
          sourceCode,
          style: TextStyle(
            wordSpacing: 3,
            color: colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
