import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget dialogWidget;

  late Finder dialogTitleFinder;
  late Finder dialogContentFinder;
  late Finder dialogLeftButtonFinder;
  late Finder dialogRightButtonFinder;

  late List<int> rightLog;
  late List<int> leftLog;
  late VoidCallback onPressedRight;
  late VoidCallback onPressedLeft;

  setUp(() {
    rightLog = [];
    leftLog = [];
  });

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    dialogTitleFinder = find.widgetWithText(
      AlertDialog,
      'Dialog Title',
    );
    dialogContentFinder = find.widgetWithText(
      AlertDialog,
      'Dialog Content',
    );
    dialogLeftButtonFinder = find.widgetWithText(
      TextButton,
      'Left Button',
    );
    dialogRightButtonFinder = find.widgetWithText(
      TextButton,
      'Right Button',
    );

    onPressedRight = () => rightLog.add(0);
    onPressedLeft = () => leftLog.add(0);

    dialogWidget = Scaffold(
      body: AlertConfirmDialog(
        title: 'Dialog Title',
        content: 'Dialog Content',
        textButtonLeft: 'Left Button',
        textButtonRight: 'Right Button',
        onPressedLeft: onPressedLeft,
        onPressedRight: onPressedRight,
      ),
    );
  });

  group('test dialog widget has', () {
    testWidgets('a title text', (tester) async {
      await tester.pumpApp(dialogWidget);
      await tester.pump();

      expect(dialogTitleFinder, findsOneWidget);
    });

    testWidgets('a content text', (tester) async {
      await tester.pumpApp(dialogWidget);
      await tester.pump();

      expect(dialogContentFinder, findsOneWidget);
    });

    testWidgets('a left text button', (tester) async {
      await tester.pumpApp(dialogWidget);
      await tester.pump();

      expect(dialogLeftButtonFinder, findsOneWidget);
    });

    testWidgets('a right text button', (tester) async {
      await tester.pumpApp(dialogWidget);
      await tester.pump();

      expect(dialogRightButtonFinder, findsOneWidget);
    });
  });

  group('test left text button pressed', () {
    testWidgets('pressed then call onPressedLeft function 1 time',
        (tester) async {
      await tester.pumpApp(dialogWidget);
      await tester.pump();

      await tester.tap(dialogLeftButtonFinder);
      await tester.pumpAndSettle();

      expect(leftLog.length, 1);
      expect(rightLog.length, 0);
    });
  });

  group('test right text button pressed', () {
    testWidgets('pressed then call onPressedRight function 1 time',
        (tester) async {
      await tester.pumpApp(dialogWidget);
      await tester.pump();

      await tester.tap(dialogRightButtonFinder);
      await tester.pumpAndSettle();

      expect(leftLog.length, 0);
      expect(rightLog.length, 1);
    });
  });
}
