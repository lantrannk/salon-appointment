import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../pump_widgets/common_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget inputWidget;

  late Finder hintTextInputFinder;
  late Finder enteredTextInputFinder;

  late TextEditingController textEditingController;
  late VoidCallback onEditCompleted;
  late FocusNode focusNode;
  late List<int> log;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    textEditingController = TextEditingController();
    focusNode = FocusNode();
    log = [];
    onEditCompleted = () => log.add(0);

    hintTextInputFinder = find.widgetWithText(
      TextFormField,
      'Name',
    );

    enteredTextInputFinder = find.widgetWithText(
      TextFormField,
      'Lan Tran',
    );

    inputWidget = TestWidget(
      body: Input(
        text: 'Name',
        controller: textEditingController,
        focusNode: focusNode,
        onEditCompleted: onEditCompleted,
      ),
    );
  });

  group('test input widget', () {
    testWidgets('has a hint text', (tester) async {
      await tester.pumpWidget(inputWidget);
      await tester.pump();

      // find a text form field with hint text
      expect(hintTextInputFinder, findsOneWidget);
    });

    testWidgets('shows the text that was entered', (tester) async {
      await tester.pumpWidget(inputWidget);
      await tester.pump();

      await tester.enterText(hintTextInputFinder, 'Lan Tran');
      await tester.pumpAndSettle();

      // find a text form field with entered text
      expect(enteredTextInputFinder, findsOneWidget);
    });

    testWidgets(
      'pressed ENTER then call onEditCompleted function 1 time',
      (tester) async {
        await tester.pumpWidget(inputWidget);
        await tester.pump();

        await tester.enterText(hintTextInputFinder, 'Lan Tran');
        await tester.testTextInput.receiveAction(TextInputAction.done);
        await tester.pumpAndSettle();

        // call onEditCompleted function
        expect(log.length, 1);
      },
    );
  });
}
