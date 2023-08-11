import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget showSnackBarButtonWidget;

  late Finder showSnackBarButtonFinder;
  late Finder snackBarFinder;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    showSnackBarButtonFinder = find.widgetWithText(
      TextButton,
      'Show Snack Bar',
    );

    snackBarFinder = find.widgetWithText(
      SnackBar,
      'Success',
    );

    showSnackBarButtonWidget = const Scaffold(
      body: ShowSnackBarButton(),
    );
  });

  testWidgets(
    'test snack bar show in 3 seconds then hiding',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(showSnackBarButtonWidget);
        await tester.pump();

        // tap button to show snack bar
        await tester.tap(showSnackBarButtonFinder);
        await tester.pumpAndSettle();

        // find one snack bar widget
        expect(snackBarFinder, findsOneWidget);

        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        // show snack bar widget 1 second
        expect(snackBarFinder, findsOneWidget);

        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        // show snack bar widget 2 seconds
        expect(snackBarFinder, findsOneWidget);

        await Future.delayed(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        // hide snack bar widget after 3 seconds
        expect(snackBarFinder, findsNothing);
      });
    },
  );
}

class ShowSnackBarButton extends StatelessWidget {
  const ShowSnackBarButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => showSnackBar(
        context: context,
        message: 'Success',
        isSuccess: true,
      ),
      child: const Text('Show Snack Bar'),
    );
  }
}

void showSnackBar({
  required BuildContext context,
  required String message,
  required bool isSuccess,
}) {
  SASnackBar.show(
    context: context,
    message: message,
    isSuccess: isSuccess,
  );
}
