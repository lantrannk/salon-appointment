import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/constants/assets.dart';
import 'package:salon_appointment/core/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pump_widgets/common_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget floatingActionButtonWidget;
  late Widget iconButtonWidget;
  late Widget textButtonWidget;
  late Widget outlinedButtonWidget;
  late Widget elevatedButtonWidget;

  late Finder floatingActionButtonFinder;
  late Finder iconButtonFinder;
  late Finder textButtonFinder;
  late Finder outlinedButtonFinder;
  late Finder elevatedButtonFinder;

  late List<int> log;
  late VoidCallback onPressed;

  setUp(() => log = []);

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    floatingActionButtonFinder = find.widgetWithIcon(
      FloatingActionButton,
      Assets.addIcon,
    );
    iconButtonFinder = find.widgetWithIcon(
      IconButton,
      Assets.closeIcon,
    );
    textButtonFinder = find.widgetWithText(
      TextButton,
      'Text Button',
    );
    outlinedButtonFinder = find.widgetWithText(
      OutlinedButton,
      'Outlined Button',
    );
    elevatedButtonFinder = find.widgetWithText(
      ElevatedButton,
      'Elevated Button',
    );

    onPressed = () => log.add(0);

    floatingActionButtonWidget = TestWidget(
      body: SAButton.floating(
        onPressed: onPressed,
        child: const Icon(Assets.addIcon),
      ),
    );

    iconButtonWidget = TestWidget(
      body: SAButton.icon(
        onPressed: onPressed,
        child: const Icon(Assets.closeIcon),
      ),
    );

    textButtonWidget = TestWidget(
      body: SAButton.text(
        onPressed: onPressed,
        child: const Text('Text Button'),
      ),
    );

    outlinedButtonWidget = TestWidget(
      body: SAButton.outlined(
        onPressed: onPressed,
        child: const Text('Outlined Button'),
      ),
    );

    elevatedButtonWidget = TestWidget(
      body: SAButton.elevated(
        onPressed: onPressed,
        child: const Text('Elevated Button'),
      ),
    );
  });

  group('test floating action button', () {
    testWidgets('has an icon child', (tester) async {
      await tester.pumpWidget(floatingActionButtonWidget);
      await tester.pump();

      expect(floatingActionButtonFinder, findsOneWidget);
    });

    testWidgets('pressed then call onPressed function 1 time', (tester) async {
      await tester.pumpWidget(floatingActionButtonWidget);
      await tester.pump();

      await tester.tap(floatingActionButtonFinder);
      await tester.pumpAndSettle();

      expect(log.length, 1);
    });
  });

  group('test icon button', () {
    testWidgets('has an icon child', (tester) async {
      await tester.pumpWidget(iconButtonWidget);
      await tester.pump();

      expect(iconButtonFinder, findsOneWidget);
    });

    testWidgets('pressed then call onPressed function 1 time', (tester) async {
      await tester.pumpWidget(iconButtonWidget);
      await tester.pump();

      await tester.tap(iconButtonFinder);
      await tester.pumpAndSettle();

      expect(log.length, 1);
    });
  });

  group('test text button', () {
    testWidgets('has an text child', (tester) async {
      await tester.pumpWidget(textButtonWidget);
      await tester.pump();

      expect(textButtonFinder, findsOneWidget);
    });

    testWidgets('pressed then call onPressed function 1 time', (tester) async {
      await tester.pumpWidget(textButtonWidget);
      await tester.pump();

      await tester.tap(textButtonFinder);
      await tester.pumpAndSettle();

      expect(log.length, 1);
    });
  });

  group('test outlined button', () {
    testWidgets('has an text child', (tester) async {
      await tester.pumpWidget(outlinedButtonWidget);
      await tester.pump();

      expect(outlinedButtonFinder, findsOneWidget);
    });

    testWidgets('pressed then call onPressed function 1 time', (tester) async {
      await tester.pumpWidget(outlinedButtonWidget);
      await tester.pump();

      await tester.tap(outlinedButtonFinder);
      await tester.pumpAndSettle();

      expect(log.length, 1);
    });
  });

  group('test elevated button', () {
    testWidgets('has an text child', (tester) async {
      await tester.pumpWidget(elevatedButtonWidget);
      await tester.pump();

      expect(elevatedButtonFinder, findsOneWidget);
    });

    testWidgets('pressed then call onPressed function 1 time', (tester) async {
      await tester.pumpWidget(elevatedButtonWidget);
      await tester.pump();

      await tester.tap(elevatedButtonFinder);
      await tester.pumpAndSettle();

      expect(log.length, 1);
    });
  });
}
