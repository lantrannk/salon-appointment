import 'package:flutter/material.dart';
import 'package:salon_appointment/core/widgets/widgets.dart';
import 'package:salon_appointment/widgetbook/code_visibility.dart';
import 'package:widgetbook/widgetbook.dart';

final TextEditingController controller = TextEditingController();
final FocusNode focusNode = FocusNode();

final WidgetbookComponent inputWidgetComponent = WidgetbookComponent(
  name: 'Input',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Input(
            text: context.knobs.string(
              label: 'Hint text',
              initialValue: 'Input',
            ),
            controller: controller,
            focusNode: focusNode,
            maxLines: context.knobs.double
                .slider(
                  label: 'Max lines',
                  initialValue: 1,
                  divisions: 4,
                  max: 5,
                  min: 1,
                )
                .toInt(),
            onEditCompleted: () {},
          ),
          const SizedBox(height: 50),
          const SourceCodeVisibility(
            sourceCode: '''Input({
  required String text,
  required TextEditingController controller,
  required FocusNode focusNode,
  required VoidCallback onEditCompleted,
  Color? color,
  double? height,
  int? maxLines,
  OutlineInputBorder? border,
  TextInputAction? textInputAction,
  double? letterSpacing = -0.24,
  super.key,
});''',
          ),
        ],
      ),
    ),
  ],
);
