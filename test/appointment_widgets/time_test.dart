import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/constants/assets.dart';
import 'package:salon_appointment/features/appointments/screens/appointment/ui/appointment_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget timeWidget;

  late Finder timeTextFinder;
  late Finder scheduleIconFinder;
  late Finder labelTextFinder;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    timeTextFinder = find.text(
      '10:00 - 10:30',
    );

    scheduleIconFinder = find.byIcon(
      Assets.scheduleIcon,
    );

    labelTextFinder = find.text(
      'Beauty Salon',
    );

    timeWidget = Scaffold(
      body: Time(
        startTime: DateTime(2023, 08, 15, 10, 0),
        endTime: DateTime(2023, 08, 15, 10, 30),
        text: 'Beauty Salon',
      ),
    );
  });

  group('test time widget has', () {
    testWidgets('a time text', (tester) async {
      await tester.pumpApp(timeWidget);
      await tester.pump();

      expect(timeTextFinder, findsOneWidget);
    });

    testWidgets('a schedule icon', (tester) async {
      await tester.pumpApp(timeWidget);
      await tester.pump();

      expect(scheduleIconFinder, findsOneWidget);
    });

    testWidgets('a beauty salon text', (tester) async {
      await tester.pumpApp(timeWidget);
      await tester.pump();

      expect(labelTextFinder, findsOneWidget);
    });
  });
}
