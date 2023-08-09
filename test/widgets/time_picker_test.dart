import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/screens/new_appointment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../expect_data/expect_data.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AppointmentBloc appointmentBloc;
  late Widget newAppointmentScreen;
  late List<AppointmentState> expectedStates;
  late Finder fromTextFinder;
  late Finder toTextFinder;
  late Finder startTimeFinder;
  late Finder endTimeFinder;

  final appointment = Appointment.fromJson(const {
    'date': '2023-08-15T10:55:00.000',
    'startTime': '2023-08-15T20:00:00.000',
    'endTime': '2023-08-15T20:30:00.000',
    'userId': '1',
    'services': 'Non-Invasive Body Contouring',
    'description': 'Nothing to write.',
    'isCompleted': false,
    'id': '80'
  });

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
            selectedDay: DateTime(2023, 08, 15),
            appointment: appointment,
          ),
        ),
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', UserExpect.adminUserEncoded);

    expectedStates = [
      UserLoaded(UserExpect.adminUser),
    ];
    whenListen(
      appointmentBloc,
      Stream.fromIterable(expectedStates),
      initialState: UserLoaded(UserExpect.adminUser),
    );

    fromTextFinder = find.text('From:');
    toTextFinder = find.text('To:');
    startTimeFinder = find.widgetWithText(OutlinedButton, '20:00');
    endTimeFinder = find.widgetWithText(OutlinedButton, '20:30');
  });

  testWidgets(
    'New Appointment Screen has one time picker widget',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(newAppointmentScreen);
        await tester.pumpAndSettle();

        // Date picker widget has 4 elements:
        // from text, start time outlined button, to text, end time outlined button
        expect(fromTextFinder, findsOneWidget);
        expect(toTextFinder, findsOneWidget);
        expect(startTimeFinder, findsOneWidget);
        expect(endTimeFinder, findsOneWidget);
      });
    },
  );

  testWidgets(
    'Show time picker dialog when pressing start time outlined button',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(newAppointmentScreen);
        await tester.pumpAndSettle();

        // Press start time outlined button
        await tester.tap(startTimeFinder);
        await tester.pumpAndSettle();

        // Show time picker dialog when pressing start time outlined button
        expect(find.byType(TimePickerDialog), findsOneWidget);
      });
    },
  );

  testWidgets(
    'Show another start time outlined button after selecting on time picker dialog',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(newAppointmentScreen);
        await tester.pumpAndSettle();

        // Press start time outlined button
        await tester.tap(startTimeFinder);
        await tester.pumpAndSettle();

        // Press time and OK
        await tester.tap(find.text('AM'));
        await tester.tap(find.text('OK'));
        await Future.delayed(const Duration(seconds: 3));
        await tester.pumpAndSettle();

        // Show another start time outlined button after selecting
        expect(find.widgetWithText(OutlinedButton, '08:00'), findsOneWidget);
      });
    },
  );
}
