import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pump_widgets/common_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget dropdownWidget;
  late Finder dropdownFinder;
  late Finder valueItemFinder;
  late String? selectedValue;
  late List<String> log;
  late Function(String?)? onChanged;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    dropdownFinder = find.widgetWithText(
      DropdownButton<String>,
      'Select Services',
    );
    valueItemFinder = find.byType(DropdownMenuItem<String>);
    selectedValue = null;

    log = [];
    onChanged = (value) => log.add(value!);

    dropdownWidget = TestWidget(
      body: Dropdown(
        items: const ['1', '2', '3'],
        selectedValue: selectedValue,
        onChanged: onChanged,
      ),
    );
  });

  group('test dropdown widget has', () {
    testWidgets('a dropdown with hint text', (tester) async {
      await tester.pumpWidget(dropdownWidget);
      await tester.pump();

      expect(dropdownFinder, findsOneWidget);
    });
  });

  group('test dropdown widget pressed then', () {
    testWidgets('show items list', (tester) async {
      await tester.pumpWidget(dropdownWidget);
      await tester.pump();

      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      expect(valueItemFinder, findsNWidgets(3));
    });

    testWidgets('select the first item then call onPressed function 1 time',
        (tester) async {
      await tester.pumpWidget(dropdownWidget);
      await tester.pump();

      await tester.tap(dropdownFinder);
      await tester.pumpAndSettle();

      await tester.tapAt(tester.getCenter(valueItemFinder.first));
      await tester.pumpAndSettle();

      expect(log.first, '1');
    });
  });
}
