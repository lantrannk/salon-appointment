import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/constants/assets.dart';
import 'package:salon_appointment/core/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget datePickerWidget;
  late Finder datePickerFinder;
  late Finder scheduleIconFinder;
  late Finder calendarIconFinder;
  late List<int> log;
  late VoidCallback onPressed;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    datePickerFinder = find.widgetWithText(TextButton, '15/08/2023');
    scheduleIconFinder = find.byIcon(Assets.scheduleIcon);
    calendarIconFinder = find.byIcon(Assets.calendarIcon);

    log = [];
    onPressed = () => log.add(0);

    datePickerWidget = MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        home: Scaffold(
          body: SizedBox(
            child: DatePicker(
              dateTime: DateTime(2023, 08, 15),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  });

  group('test date picker widget has', () {
    testWidgets('a schedule icon', (tester) async {
      await tester.pumpWidget(datePickerWidget);
      await tester.pump();

      expect(scheduleIconFinder, findsOneWidget);
    });

    testWidgets('a calendar icon', (tester) async {
      await tester.pumpWidget(datePickerWidget);
      await tester.pump();

      expect(calendarIconFinder, findsOneWidget);
    });

    testWidgets('a date text button', (tester) async {
      await tester.pumpWidget(datePickerWidget);
      await tester.pump();

      expect(datePickerFinder, findsOneWidget);
    });
  });

  group('test date picker pressed then', () {
    testWidgets('call onPressed function 1 time', (tester) async {
      await tester.pumpWidget(datePickerWidget);
      await tester.pump();

      await tester.tap(datePickerFinder);
      await tester.pumpAndSettle();

      expect(log.length, 1);
    });
  });
}
