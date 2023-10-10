import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/constants/assets.dart';
import 'package:salon_appointment/features/appointments/screens/appointment/ui/appointment_ui.dart';
import 'package:salon_appointment/features/appointments/screens/appointment/ui/appointment_ui.dart'
    as widget;
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/mock_data/mock_data.dart';
import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget appointmentCardWidget;

  late Finder timeFinder;
  late Finder customerNameFinder;
  late Finder serviceFinder;
  late Finder descriptionFinder;
  late Finder editButtonFinder;
  late Finder removeButtonFinder;

  late VoidCallback onEditPressed;
  late VoidCallback onRemovePressed;
  late List<int> editLog;
  late List<int> removeLog;

  const user = MockDataUser.adminUser;
  final appointment = MockDataAppointment.appointment;

  setUp(() {
    editLog = [];
    removeLog = [];
  });

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    onEditPressed = () => editLog.add(0);
    onRemovePressed = () => removeLog.add(0);

    timeFinder = find.widgetWithText(
      Time,
      '10:00 - 10:30',
    );

    customerNameFinder = find.widgetWithText(
      Customer,
      'Lan Tran',
    );

    serviceFinder = find.widgetWithText(
      Service,
      'Non-Invasive Body Contouring',
    );

    descriptionFinder = find.widgetWithText(
      widget.Description,
      'Nothing to write.',
    );

    editButtonFinder = find.widgetWithIcon(
      IconButton,
      Assets.editIcon,
    );

    removeButtonFinder = find.widgetWithIcon(
      IconButton,
      Assets.removeIcon,
    );

    appointmentCardWidget = Scaffold(
      body: AppointmentCard(
        appointment: appointment,
        name: user.name,
        avatar: user.avatar,
        onEditPressed: onEditPressed,
        onRemovePressed: onRemovePressed,
      ),
    );
  });

  group('test appointment card has', () {
    testWidgets('a time widget', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(appointmentCardWidget);
        await tester.pump();

        expect(timeFinder, findsOneWidget);
      });
    });

    testWidgets('a customer name widget', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(appointmentCardWidget);
        await tester.pump();

        expect(customerNameFinder, findsOneWidget);
      });
    });

    testWidgets('a service widget', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(appointmentCardWidget);
        await tester.pump();

        expect(serviceFinder, findsOneWidget);
      });
    });

    testWidgets('a description widget', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(appointmentCardWidget);
        await tester.pump();

        expect(descriptionFinder, findsOneWidget);
      });
    });

    testWidgets('a edit icon button widget', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(appointmentCardWidget);
        await tester.pump();

        expect(editButtonFinder, findsOneWidget);
      });
    });

    testWidgets('a remove icon button widget', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(appointmentCardWidget);
        await tester.pump();

        expect(removeButtonFinder, findsOneWidget);
      });
    });
  });

  group('test edit icon button pressed', () {
    testWidgets('then call onEditPressed function 1 time', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(appointmentCardWidget);
        await tester.pump();

        await tester.tap(editButtonFinder);
        await tester.pumpAndSettle();

        expect(editLog.length, 1);
        expect(removeLog.length, 0);
      });
    });
  });

  group('test remove icon button pressed', () {
    testWidgets('then call onRemovePressed function 1 time', (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(appointmentCardWidget);
        await tester.pump();

        await tester.tap(removeButtonFinder);
        await tester.pumpAndSettle();

        expect(editLog.length, 0);
        expect(removeLog.length, 1);
      });
    });
  });
}
