import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/constants/assets.dart';
import 'package:salon_appointment/features/appointments/screens/appointments_widgets/appointments_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';
import '../mock_data/mock_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget calendarScheduleWidget;

  late Finder scheduleIconFinder;
  late Finder dateTextFinder;
  late Finder timeTextFinder;
  late Finder descriptionTextFinder;
  late Finder textButtonFinder;

  late List<int> log;
  late VoidCallback onPressed;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    log = [];
    onPressed = () => log.add(0);

    scheduleIconFinder = find.byIcon(
      Assets.scheduleIcon,
    );

    dateTextFinder = find.text(
      '15 August, Tuesday',
    );

    timeTextFinder = find.text(
      '10:00 - 10:30',
    );

    descriptionTextFinder = find.text(
      'Nothing to write.',
    );

    textButtonFinder = find.widgetWithText(
      TextButton,
      'Show appointments (4)',
    );

    calendarScheduleWidget = Scaffold(
      body: Scaffold(
        body: CalendarSchedule(
          appointment: MockDataAppointment.appointment,
          countOfAppointments: 4,
          onPressed: onPressed,
        ),
      ),
    );
  });

  group('test calendar cell has', () {
    testWidgets('a schedule icon', (tester) async {
      await tester.pumpApp(calendarScheduleWidget);
      await tester.pump();

      expect(scheduleIconFinder, findsOneWidget);
    });

    testWidgets('a day text', (tester) async {
      await tester.pumpApp(calendarScheduleWidget);
      await tester.pump();

      expect(dateTextFinder, findsOneWidget);
    });

    testWidgets('a time text', (tester) async {
      await tester.pumpApp(calendarScheduleWidget);
      await tester.pump();

      expect(timeTextFinder, findsOneWidget);
    });

    testWidgets('a description text', (tester) async {
      await tester.pumpApp(calendarScheduleWidget);
      await tester.pump();

      expect(descriptionTextFinder, findsOneWidget);
    });
  });

  testWidgets('a text button', (tester) async {
    await tester.pumpApp(calendarScheduleWidget);
    await tester.pump();

    expect(textButtonFinder, findsOneWidget);
  });

  group('test text button pressed', () {
    testWidgets('then call onPressed function 1 time', (tester) async {
      await tester.pumpApp(calendarScheduleWidget);
      await tester.pump();

      await tester.tap(textButtonFinder);
      await tester.pumpAndSettle();

      expect(log.length, 1);
    });
  });
}
