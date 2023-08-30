import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/constants/assets.dart';
import 'package:salon_appointment/features/appointments/screens/appointments_widgets/appointments_widgets.dart'
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

  setUp(() {
    editLog = [];
    removeLog = [];
  });

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    onEditPressed = () => editLog.add(0);
    onRemovePressed = () => removeLog.add(0);

    timeFinder = find.widgetWithText(
      widget.Time,
      '10:00 - 10:30',
    );

    customerNameFinder = find.widgetWithText(
      widget.Customer,
      'Lan Tran',
    );

    serviceFinder = find.widgetWithText(
      widget.Service,
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
      body: Scaffold(
        body: widget.AppointmentCard(
          appointment: MockDataAppointment.appointment,
          name: 'Lan Tran',
          avatar:
              'https://www.google.com/imgres?imgurl=https%3A%2F%2Ft3.ftcdn.net%2Fjpg%2F03%2F14%2F36%2F24%2F360_F_314362441_Tx4djxQlxSSRutWEbaWP40jFvbvW0P3J.jpg&tbnid=fxJ8HNBgf3StGM&vet=12ahUKEwiDq4vIj9SAAxWJfXAKHaSTDR0QMygFegUIARCBAg..i&imgrefurl=https%3A%2F%2Fstock.adobe.com%2Fsearch%3Fk%3Dbeauty&docid=sLPERW_WHMMG4M&w=540&h=360&q=beauty%20image&ved=2ahUKEwiDq4vIj9SAAxWJfXAKHaSTDR0QMygFegUIARCBAg',
          onEditPressed: onEditPressed,
          onRemovePressed: onRemovePressed,
        ),
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
