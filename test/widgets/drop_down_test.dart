import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart'
    as appointment;
import 'package:salon_appointment/features/appointments/screens/new_appointment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../expect_data/expect_data.dart';

class MockAppointmentBloc extends Mock implements appointment.AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late appointment.AppointmentBloc appointmentBloc;
  late Widget newAppointmentScreen;
  late List<appointment.AppointmentState> expectedStates;
  late Finder initialDropDownFinder;
  late Finder backDropDownFinder;
  late Finder servicesFinder;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    appointmentBloc = MockAppointmentBloc();
    newAppointmentScreen = MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: BlocProvider.value(
          value: appointmentBloc,
          child: NewAppointmentScreen(
            selectedDay: DateTime.now(),
          ),
        ),
      ),
    );

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user', ExpectData.adminUserStr);

    expectedStates = [
      appointment.UserLoaded(ExpectData.adminUser),
    ];
    whenListen(
      appointmentBloc,
      Stream.fromIterable(expectedStates),
      initialState: appointment.UserLoaded(ExpectData.adminUser),
    );

    initialDropDownFinder = find.widgetWithText(
      DropdownButton<String>,
      'Select Services',
    );
    backDropDownFinder = find.widgetWithText(
      DropdownButton<String>,
      'Back',
    );
    servicesFinder = find.byType(DropdownMenuItem<String>);
  });

  testWidgets(
    'New Appointment Screen has one drop down button',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(newAppointmentScreen);
        await tester.pump(const Duration(seconds: 1));

        // Drop down button
        expect(initialDropDownFinder, findsOneWidget);
      });
    },
  );

  testWidgets(
    'Show list of 3 items when pressing drop down button',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(newAppointmentScreen);
        await tester.pumpAndSettle();

        // Press drop down button
        await tester.tap(initialDropDownFinder);
        await tester.pumpAndSettle();

        // Drop down has 3 items
        expect(servicesFinder, findsNWidgets(3));
      });
    },
  );

  testWidgets(
    'Show drop down with selected item when pressing item on list',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(newAppointmentScreen);
        await tester.pumpAndSettle();

        // Press drop down button
        await tester.tap(initialDropDownFinder);
        await tester.pumpAndSettle();

        // Press first item of list
        await tester.tap(servicesFinder.first, warnIfMissed: false);
        await tester.pumpAndSettle();

        // Show drop down with the first item: 'Back'
        expect(backDropDownFinder, findsOneWidget);
      });
    },
  );
}
