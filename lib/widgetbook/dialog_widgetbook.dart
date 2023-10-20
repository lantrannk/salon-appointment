import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

import '../core/widgets/widgets.dart';
import 'code_visibility.dart';

final WidgetbookComponent dialogWidgetComponent = WidgetbookComponent(
  name: 'Dialog',
  useCases: [
    WidgetbookUseCase(
      name: 'Default',
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: AlertConfirmDialog(
              title: context.knobs.string(
                label: 'Title',
                initialValue: 'Title',
                maxLines: 1,
              ),
              content: context.knobs.string(
                label: 'Content',
                initialValue: 'Content',
                maxLines: 1,
              ),
              onPressedRight: () {},
              onPressedLeft: () {},
              textButtonRight: context.knobs.string(
                label: 'Right text button',
                initialValue: 'Yes',
                maxLines: 1,
              ),
              textButtonLeft: context.knobs.string(
                label: 'Left text button',
                initialValue: 'No',
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(height: 50),
          const SourceCodeVisibility(
            sourceCode: '''AlertConfirmDialog({
  required String title,
  required String content,
  required void Function() onPressedRight,
  required void Function() onPressedLeft,
  String? textButtonRight,
  String? textButtonLeft,
  Key? key,
})''',
          ),
        ],
      ),
    ),
  ],
);
