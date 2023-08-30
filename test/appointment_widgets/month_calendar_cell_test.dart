import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/constants/assets.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/screens/appointments_widgets/appointments_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/mock_data/mock_data.dart';
import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget noAppointmentsCellWidget;
  late Widget haveAppointmentsCellWidget;

  late Finder differentIconFinder;
  late Finder dayTextFinder;
  late Finder firstTimeTextFinder;
  late Finder secondTimeTextFinder;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    differentIconFinder = find.byIcon(
      Assets.differentIcon,
    );

    dayTextFinder = find.text(
      '15',
    );

    firstTimeTextFinder = find.text(
      '18:00',
    );

    secondTimeTextFinder = find.text(
      '19:00',
    );

    noAppointmentsCellWidget = Scaffold(
      body: Scaffold(
        body: MonthCalendarCell(
          day: DateTime(2023, 08, 15),
          events: const <Appointment>[],
        ),
      ),
    );

    haveAppointmentsCellWidget = Scaffold(
      body: Scaffold(
        body: MonthCalendarCell(
          day: DateTime(2023, 08, 15),
          events: MockDataAppointment.sortedAppointmentsOfDay,
        ),
      ),
    );
  });

  testWidgets('test month calendar cell has a day text', (tester) async {
    await tester.pumpApp(noAppointmentsCellWidget);
    await tester.pump();

    expect(dayTextFinder, findsOneWidget);
  });

  group('test month calendar cell when no appointments has', () {
    testWidgets('no different icon', (tester) async {
      await tester.pumpApp(noAppointmentsCellWidget);
      await tester.pump();

      expect(differentIconFinder, findsNothing);
    });

    testWidgets('no time text', (tester) async {
      await tester.pumpApp(noAppointmentsCellWidget);
      await tester.pump();

      expect(firstTimeTextFinder, findsNothing);
      expect(secondTimeTextFinder, findsNothing);
    });
  });

  group('test month calendar cell when having appointments has', () {
    testWidgets('a different icon', (tester) async {
      await tester.pumpApp(haveAppointmentsCellWidget);
      await tester.pump();

      expect(differentIconFinder, findsOneWidget);
    });

    testWidgets('2 time text', (tester) async {
      await tester.pumpApp(haveAppointmentsCellWidget);
      await tester.pump();

      expect(firstTimeTextFinder, findsOneWidget);
      expect(secondTimeTextFinder, findsOneWidget);
    });
  });
}
