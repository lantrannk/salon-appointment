import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/features/appointments/screens/calendar/ui/calendar_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget calendarChevronTextWidget;

  late Finder focusedDay;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    focusedDay = find.text(
      'August 2023',
    );

    calendarChevronTextWidget = Scaffold(
      body: CalendarChevronText(
        focusedDay: DateTime(2023, 08, 11),
        textAlign: TextAlign.start,
      ),
    );
  });

  testWidgets(
    'test calendar chevron text widget show date formatted MMMM yyyy',
    (tester) async {
      /// Render widget with input [focusedDay] (11/08/2023)
      await tester.pumpApp(calendarChevronTextWidget);
      await tester.pump();

      /// expect show text 'August 2023'
      expect(focusedDay, findsOneWidget);
    },
  );
}
