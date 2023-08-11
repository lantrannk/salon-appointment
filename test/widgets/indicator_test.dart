import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/widgets/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Widget indicatorWidget;
  late Finder indicatorFinder;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    indicatorFinder = find.byType(
      CircularProgressIndicator,
    );

    indicatorWidget = const Scaffold(
      body: SAIndicator(
        height: 24,
      ),
    );
  });

  testWidgets('test indicator show', (tester) async {
    await tester.pumpApp(indicatorWidget);
    await tester.pump();

    expect(indicatorFinder, findsOneWidget);
  });
}
