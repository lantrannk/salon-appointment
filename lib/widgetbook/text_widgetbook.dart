import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';

final WidgetbookComponent textWidgetComponent = WidgetbookComponent(
  name: 'Text',
  useCases: [
    WidgetbookUseCase(
      name: 'Body Small',
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: textSourceCode(
              context,
              context.knobs.list(
                label: 'Text Style',
                options: [
                  'Display Large',
                  'Display Medium',
                  'Display Small',
                  'Title Large',
                  'Label Large',
                  'Label Medium',
                  'Label Small',
                  'Body Large',
                  'Body Medium',
                  'Body Small',
                ],
                initialOption: 'Body Small',
              ),
            ),
          ),
        ],
      ),
    ),
  ],
);

Widget textSourceCode(BuildContext context, String textStyle) {
  final TextTheme textTheme = Theme.of(context).textTheme;

  switch (textStyle.toLowerCase()) {
    case 'display large':
      return Text(
        '''Display Large
TextStyle(
  fontSize: 220,
  fontWeight: FontWeight.w500,
)''',
        style: textTheme.displayLarge,
      );
    case 'display medium':
      return Text(
        '''Display Medium
TextStyle(
  fontSize: 70,
  fontWeight: FontWeight.w500,
)''',
        style: textTheme.displayMedium,
      );
    case 'display small':
      return Text(
        '''Display Small
TextStyle(
  fontSize: 30,
  fontWeight: FontWeight.w500,
)''',
        style: textTheme.displaySmall,
      );
    case 'title large':
      return Text(
        '''Title Large
TextStyle(
  fontSize: 20,
  lineHeight: 30,
  fontWeight: FontWeight.w500,
)''',
        style: textTheme.titleLarge,
      );
    case 'label large':
      return Text(
        '''Label Large
TextStyle(
  fontSize: 17,
  lineHeight: 25.5,
  fontWeight: FontWeight.w500,
)''',
        style: textTheme.labelLarge,
      );
    case 'label medium':
      return Text(
        '''Label Medium
TextStyle(
  fontSize: 16,
  lineHeight: 20,
  fontWeight: FontWeight.w500,
)''',
        style: textTheme.labelMedium,
      );
    case 'label small':
      return Text(
        '''Label Small
TextStyle(
  fontSize: 15,
  lineHeight: 20,
  fontWeight: FontWeight.w400,
)''',
        style: textTheme.labelSmall,
      );
    case 'body large':
      return Text(
        '''Body Large
TextStyle(
  fontSize: 14,
  lineHeight: 20,
  fontWeight: FontWeight.w400,
)''',
        style: textTheme.bodyLarge,
      );
    case 'body medium':
      return Text(
        '''Body Medium
TextStyle(
  fontSize: 13,
  lineHeight: 20,
  fontWeight: FontWeight.w500,
)''',
        style: textTheme.bodyMedium,
      );
    case 'body small':
      return Text(
        '''Body Small
TextStyle(
  fontSize: 12,
  lineHeight: 16,
  fontWeight: FontWeight.w400,
)''',
        style: textTheme.bodySmall,
      );
    default:
      return Text(
        '''Body Small
TextStyle(
  fontSize: 12,
  lineHeight: 16,
  fontWeight: FontWeight.w400,
)''',
        style: textTheme.bodySmall,
      );
  }
}
