import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:widgetbook/widgetbook.dart';

import '../core/generated/l10n.dart';
import '../core/theme/theme.dart';
import 'buttons_widgetbook.dart';
import 'dialog_widgetbook.dart';
import 'drop_down_widgetbook.dart';
import 'input_widgetbook.dart';
import 'text_widgetbook.dart';

void main() {
  runApp(const WidgetbookApp());
}

class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        DeviceFrameAddon(
          initialDevice: Devices.ios.iPhone13Mini,
          devices: Devices.all,
        ),
        ThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Dark',
              data: AppDarkTheme().themeData,
            ),
            WidgetbookTheme(
              name: 'Light',
              data: AppTheme().themeData,
            ),
          ],
          themeBuilder: (context, theme, child) {
            return MaterialApp(
              theme: theme,
              debugShowCheckedModeBanner: false,
              home: child,
            );
          },
        ),
        BuilderAddon(
          name: 'Scaffold',
          builder: (context, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
            home: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              body: child,
            ),
          ),
        ),
      ],
      directories: [
        WidgetbookFolder(name: 'Common widgets', children: [
          buttonsWidgetComponent,
          inputWidgetComponent,
          dropDownWidgetComponent,
          dialogWidgetComponent,
          textWidgetComponent,
        ]),
      ],
    );
  }
}
