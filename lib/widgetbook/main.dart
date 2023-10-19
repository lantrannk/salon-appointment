import 'package:flutter/material.dart';
import 'package:salon_appointment/core/theme/theme.dart';
import 'package:salon_appointment/widgetbook/buttons_widgetbook.dart';
import 'package:salon_appointment/widgetbook/input_widgetbook.dart';
import 'package:widgetbook/widgetbook.dart';

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
              name: 'Light',
              data: AppTheme().themeData,
            ),
            WidgetbookTheme(
              name: 'Dark',
              data: AppDarkTheme().themeData,
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
          builder: (context, child) => Scaffold(
            body: child,
          ),
        ),
      ],
      directories: [
        buttonsWidgetComponent,
        inputWidgetComponent,
      ],
    );
  }
}
