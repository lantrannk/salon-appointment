import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/features/appointments/screens/calendar/ui/calendar_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget monthCalendarCellWidget;
  late Finder dayTextFinder;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    dayTextFinder = find.text(
      '15',
    );

    monthCalendarCellWidget = Scaffold(
      body: MonthCalendarCell(
        day: DateTime(2023, 08, 15),
      ),
    );
  });

  testWidgets('test month calendar cell has a day text', (tester) async {
    await tester.pumpApp(monthCalendarCellWidget);
    await tester.pump();

    expect(dayTextFinder, findsOneWidget);
  });
}
