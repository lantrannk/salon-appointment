import 'package:flutter/material.dart';
import 'package:salon_appointment/core/widgets/widgets.dart';
import 'package:salon_appointment/widgetbook/code_visibility.dart';
import 'package:widgetbook/widgetbook.dart';

import '../core/constants/constants.dart';

final WidgetbookComponent buttonsWidgetComponent = WidgetbookComponent(
  name: 'Buttons',
  useCases: [
    WidgetbookUseCase(
      name: 'Elevated Button',
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SAButton.elevated(
              height: context.knobs.double
                  .input(
                    label: 'Button height',
                    initialValue: 44,
                  )
                  .toDouble(),
              width: context.knobs.double
                  .input(
                    label: 'Button width',
                    initialValue: 311,
                  )
                  .toDouble(),
              onPressed: () {},
              child: Text(
                context.knobs.string(
                  label: 'Text on button',
                  initialValue: 'Elevated Button',
                  maxLines: 1,
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          const SourceCodeVisibility(
            sourceCode: 'SAButton.elevated({'
                '\n\t\t\trequired Widget child,'
                '\n\t\t\tVoidCallback? onPressed,'
                '\n\t\t\tdouble? height,'
                '\n\t\t\tdouble? width,'
                '\n\t\t\tColor? bgColor,'
                '\n})',
          ),
        ],
      ),
    ),
    WidgetbookUseCase(
      name: 'Outlined Button',
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SAButton.outlined(
              height: context.knobs.double
                  .input(
                    label: 'Button height',
                    initialValue: 44,
                  )
                  .toDouble(),
              width: context.knobs.double
                  .input(
                    label: 'Button width',
                    initialValue: 311,
                  )
                  .toDouble(),
              onPressed: () {},
              child: Text(
                context.knobs.string(
                  label: 'Text on button',
                  initialValue: 'Outlined Button',
                  maxLines: 1,
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          const SourceCodeVisibility(
            sourceCode: 'SAButton.outlined({'
                '\n\t\t\trequired Widget child,'
                '\n\t\t\tVoidCallback? onPressed,'
                '\n\t\t\tdouble height,'
                '\n\t\t\tdouble width,'
                '\n\t\t\tColor? outlinedColor,'
                '\n})',
          ),
        ],
      ),
    ),
    WidgetbookUseCase(
      name: 'Text Button',
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SAButton.text(
              onPressed: () {},
              child: Text(
                context.knobs.string(
                  label: 'Text on button',
                  initialValue: 'Text Button',
                  maxLines: 1,
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 50),
          const SourceCodeVisibility(
            sourceCode: 'SAButton.text({'
                '\n\t\t\trequired Widget child,'
                '\n\t\t\tVoidCallback? onPressed,'
                '\n})',
          ),
        ],
      ),
    ),
    WidgetbookUseCase(
      name: 'Icon Button',
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SAButton.icon(
              onPressed: () {},
              child: Icon(
                context.knobs.list<IconData>(
                  label: 'IconData',
                  options: [
                    Assets.checkIcon,
                    Assets.closeIcon,
                    Assets.darkIcon,
                    Assets.editIcon,
                    Assets.lightIcon,
                    Assets.logoutIcon,
                    Assets.notificationsIcon,
                    Assets.personIcon,
                    Assets.removeIcon,
                    Assets.scheduleIcon,
                  ],
                ),
                size: 24,
              ),
            ),
          ),
          const SizedBox(height: 50),
          const SourceCodeVisibility(
            sourceCode: 'SAButton.icon({'
                '\n\t\t\trequired Widget child,'
                '\n\t\t\tVoidCallback? onPressed,'
                '\n})',
          ),
        ],
      ),
    ),
    WidgetbookUseCase(
      name: 'Floating Action Button',
      builder: (context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SAButton.floating(
              height: context.knobs.double
                  .input(
                    label: 'Button height',
                    initialValue: 56,
                  )
                  .toDouble(),
              width: context.knobs.double
                  .input(
                    label: 'Button width',
                    initialValue: 56,
                  )
                  .toDouble(),
              onPressed: () {},
              child: const Icon(Assets.addIcon),
            ),
          ),
          const SizedBox(height: 50),
          const SourceCodeVisibility(
            sourceCode: 'SAButton.floating({'
                '\n\t\t\trequired Widget child,'
                '\n\t\t\tVoidCallback? onPressed,'
                '\n\t\t\tdouble height,'
                '\n\t\t\tdouble width,'
                '\n\t\t\tColor bgColor,'
                '\n\t\t\tdouble elevation,'
                '\n})',
          ),
        ],
      ),
    ),
  ],
);
