import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/constants/assets.dart';
import 'package:salon_appointment/features/appointments/screens/calendar/ui/calendar_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget lessThan3AppointmentsCellWidget;
  late Widget moreThan3AppointmentsCellWidget;

  late Finder differentIconFinder;
  late Finder firstTimeTextFinder;
  late Finder countOfAppointmentsTextFinder;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    differentIconFinder = find.byIcon(
      Assets.differentIcon,
    );

    firstTimeTextFinder = find.text('18:00');
    countOfAppointmentsTextFinder = find.text('7');

    lessThan3AppointmentsCellWidget = Scaffold(
      body: CalendarMarker(
        events: MockDataAppointment.oneAppointmentOfDay,
      ),
    );

    moreThan3AppointmentsCellWidget = Scaffold(
      body: CalendarMarker(
        events: MockDataAppointment.sortedAppointmentsOfDay,
      ),
    );
  });

  group('test month calendar cell when having less than 3 appointments has',
      () {
    testWidgets('a different icon', (tester) async {
      await tester.pumpApp(lessThan3AppointmentsCellWidget);
      await tester.pump();

      expect(differentIconFinder, findsOneWidget);
    });

    testWidgets('2 time text', (tester) async {
      await tester.pumpApp(lessThan3AppointmentsCellWidget);
      await tester.pump();

      expect(firstTimeTextFinder, findsOneWidget);
    });
  });

  group('test month calendar cell when having more than 3 appointments has',
      () {
    testWidgets('a different icon', (tester) async {
      await tester.pumpApp(moreThan3AppointmentsCellWidget);
      await tester.pump();

      expect(differentIconFinder, findsOneWidget);
    });

    testWidgets('a text show count of appointments', (tester) async {
      await tester.pumpApp(moreThan3AppointmentsCellWidget);
      await tester.pump();

      expect(countOfAppointmentsTextFinder, findsOneWidget);
    });
  });
}
