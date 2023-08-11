import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget timePickerWidget;
  late Finder fromTextFinder;
  late Finder toTextFinder;
  late Finder startTimeFinder;
  late Finder endTimeFinder;
  late List<int> startTimeLog;
  late List<int> endTimeLog;
  late VoidCallback onStartTimePressed;
  late VoidCallback onEndTimePressed;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    fromTextFinder = find.text('From:');
    toTextFinder = find.text('To:');
    startTimeFinder = find.widgetWithText(OutlinedButton, '10:00');
    endTimeFinder = find.widgetWithText(OutlinedButton, '10:30');

    startTimeLog = [];
    endTimeLog = [];
    onStartTimePressed = () => startTimeLog.add(0);
    onEndTimePressed = () => endTimeLog.add(0);

    timePickerWidget = Scaffold(
      body: TimePicker(
        startTime: DateTime(2023, 08, 25, 10, 0),
        endTime: DateTime(2023, 08, 25, 10, 30),
        onStartTimePressed: onStartTimePressed,
        onEndTimePressed: onEndTimePressed,
      ),
    );
  });

  group('test time picker widget has', () {
    testWidgets('a from text', (tester) async {
      await tester.pumpApp(timePickerWidget);
      await tester.pump();

      expect(fromTextFinder, findsOneWidget);
    });

    testWidgets('a to text', (tester) async {
      await tester.pumpApp(timePickerWidget);
      await tester.pump();

      expect(toTextFinder, findsOneWidget);
    });

    testWidgets('a start time outlined button', (tester) async {
      await tester.pumpApp(timePickerWidget);
      await tester.pump();

      expect(startTimeFinder, findsOneWidget);
    });

    testWidgets('a end time outlined button', (tester) async {
      await tester.pumpApp(timePickerWidget);
      await tester.pump();

      expect(endTimeFinder, findsOneWidget);
    });
  });

  group('test start time pressed then', () {
    testWidgets('call onStartTimePressed function 1 time', (tester) async {
      await tester.pumpApp(timePickerWidget);
      await tester.pump();

      await tester.tap(startTimeFinder);
      await tester.pumpAndSettle();

      expect(startTimeLog.length, 1);
    });
  });

  group('test end time pressed then', () {
    testWidgets('call onEndTimePressed function 1 time', (tester) async {
      await tester.pumpApp(timePickerWidget);
      await tester.pump();

      await tester.tap(endTimeFinder);
      await tester.pumpAndSettle();

      expect(endTimeLog.length, 1);
    });
  });
}
