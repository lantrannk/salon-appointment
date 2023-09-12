import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/features/appointments/screens/appointments_widgets/appointments_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget calendarCellWidget;

  late Finder dayOfWeekFinder;
  late Finder dayFinder;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    dayOfWeekFinder = find.text(
      'Fri',
    );

    dayFinder = find.text(
      '11',
    );

    calendarCellWidget = Scaffold(
      body: CalendarCell(
        day: DateTime(2023, 08, 11),
      ),
    );
  });

  group('test calendar cell has', () {
    testWidgets('a day of week text', (tester) async {
      await tester.pumpApp(calendarCellWidget);
      await tester.pump();

      expect(dayOfWeekFinder, findsOneWidget);
    });

    testWidgets('a day text', (tester) async {
      await tester.pumpApp(calendarCellWidget);
      await tester.pump();

      expect(dayFinder, findsOneWidget);
    });
  });
}
