import 'package:flutter/material.dart';
import 'package:salon_appointment/screens/splash_screen.dart';
import 'theme/theme.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(
    // DevicePreview(
    //   enabled: true,
    //   builder: (context) => const MyApp(),
    // ),
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: SATheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
