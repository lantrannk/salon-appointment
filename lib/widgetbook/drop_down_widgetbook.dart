import 'package:flutter/material.dart';
import 'package:salon_appointment/core/widgets/widgets.dart';
import 'package:salon_appointment/widgetbook/code_visibility.dart';
import 'package:widgetbook/widgetbook.dart';

import '../core/constants/constants.dart';

final WidgetbookComponent dropDownWidgetComponent = WidgetbookComponent(
  name: 'Drop down',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Dropdown(
              items: allServices,
              selectedValue: null,
              hint: context.knobs.string(
                label: 'Hint text',
                initialValue: 'Select Services',
              ),
              style: Theme.of(context).textTheme.bodySmall,
              onChanged: (value) {},
              height: (context.knobs.doubleOrNull.input(
                        label: 'Drop down height',
                        initialValue: 44,
                      ) ??
                      44)
                  .toDouble(),
              width: (context.knobs.doubleOrNull.input(
                        label: 'Drop down height',
                        initialValue: 311,
                      ) ??
                      311)
                  .toDouble(),
            ),
          ),
          const SizedBox(height: 50),
          const SourceCodeVisibility(
            sourceCode: '''Dropdown({
  required List<String> items,
  required String? selectedValue,
  required dynamic Function(String?)? onChanged,
  required String hint,
  TextStyle? style,
  double? height = 44,
  double? width = double.infinity,
  Key? key,
})''',
          ),
        ],
      ),
    ),
  ],
);
