import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/constants/assets.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/screens/appointment_form.dart';
import 'package:salon_appointment/features/auth/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/mock_data/mock_data.dart';
import '../helpers/pump_app.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AppointmentBloc appointmentBloc;
  late Widget appointmentForm;
  late List<AppointmentState> expectedStates;

  late Finder editTitleTextFinder;
  late Finder closeButtonFinder;
  late Finder customerNameTextFinder;
  late Finder datePickerFinder;
  late Finder scheduleIconFinder;
  late Finder calendarIconFinder;
  late Finder fromTextFinder;
  late Finder toTextFinder;
  late Finder startTimeFinder;
  late Finder endTimeFinder;
  late Finder dropdownFinder;
  late Finder descriptionFinder;
  late Finder submitButtonFinder;

  late Finder newTitleTextFinder;
  late Finder hintDropdownFinder;
  late Finder hintDescriptionFinder;
  late Finder createButtonFinder;

  final appointment = Appointment.fromJson(const {
    'date': '2023-10-15T10:55:00.000',
    'startTime': '2023-10-15T20:00:00.000',
    'endTime': '2023-10-15T20:30:00.000',
    'userId': '1',
    'services': 'Non-Invasive Body Contouring',
    'description': 'Nothing to write.',
    'isCompleted': false,
    'id': '80'
  });

  const user = MockDataUser.adminUser;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    appointmentBloc = MockAppointmentBloc();

    final UserRepository userRepository = UserRepository();
    await userRepository.setUser(user);

    expectedStates = [
      AppointmentInitializeInProgress(),
      const AppointmentInitializeSuccess(
        user: MockDataUser.adminUser,
      ),
    ];

    whenListen(
      appointmentBloc,
      Stream.fromIterable(expectedStates),
      initialState: AppointmentInitializeInProgress(),
    );
  });

  group('Test edit appointment form -', () {
    setUpAll(() {
      appointmentForm = BlocProvider.value(
        value: appointmentBloc,
        child: AppointmentForm(
          selectedDay: DateTime(2023, 10, 15),
          appointment: appointment,
          user: user,
        ),
      );

      editTitleTextFinder = find.text('Edit Appointment');
      closeButtonFinder = find.widgetWithIcon(IconButton, Assets.closeIcon);
      customerNameTextFinder = find.text('Lan Tran');

      // date picker widget
      datePickerFinder = find.widgetWithText(TextButton, '15/10/2023');
      scheduleIconFinder = find.byIcon(Assets.scheduleIcon);
      calendarIconFinder = find.byIcon(Assets.calendarIcon);

      // time picker widget
      fromTextFinder = find.text('From:');
      toTextFinder = find.text('To:');
      startTimeFinder = find.widgetWithText(OutlinedButton, '20:00');
      endTimeFinder = find.widgetWithText(OutlinedButton, '20:30');

      dropdownFinder = find.widgetWithText(
        DropdownButton<String>,
        'Non-Invasive Body Contouring',
      );
      descriptionFinder = find.widgetWithText(
        TextFormField,
        'Nothing to write.',
      );
      submitButtonFinder = find.widgetWithText(ElevatedButton, 'Submit');
    });

    testWidgets(
      'Show app bar title text',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentForm);
          await tester.pumpAndSettle();

          // Show text 'Edit Appointment'
          expect(editTitleTextFinder, findsOneWidget);
        });
      },
    );

    testWidgets(
      'Pop appointment form when pressing close icon button',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentForm);
          await tester.pumpAndSettle();

          // Show close icon button
          expect(closeButtonFinder, findsOneWidget);

          await tester.tap(closeButtonFinder);
          await tester.pumpAndSettle();

          // Not found title text
          expect(editTitleTextFinder, findsNothing);
        });
      },
    );

    testWidgets(
      'Show customer name text',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentForm);
          await tester.pumpAndSettle();

          // Show customer name text 'Lan Tran'
          expect(customerNameTextFinder, findsOneWidget);
        });
      },
    );

    testWidgets(
      'Show date picker dialog when pressing date text button',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentForm);
          await tester.pumpAndSettle();

          // Date picker widget has 3 elements: schedule icon, date text button, calendar icon
          expect(datePickerFinder, findsOneWidget);
          expect(scheduleIconFinder, findsOneWidget);
          expect(calendarIconFinder, findsOneWidget);

          // Press date text button
          await tester.tap(
            datePickerFinder,
            warnIfMissed: false,
          );
          await tester.pumpAndSettle();

          // Show date picker dialog when pressing date text button
          expect(find.byType(DatePickerDialog), findsOneWidget);
        });
      },
    );

    testWidgets(
      'Show time picker dialog when pressing start time outlined button',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentForm);
          await tester.pumpAndSettle();

          // Date picker widget has 4 elements:
          // from text, start time outlined button, to text, end time outlined button
          expect(fromTextFinder, findsOneWidget);
          expect(toTextFinder, findsOneWidget);
          expect(startTimeFinder, findsOneWidget);
          expect(endTimeFinder, findsOneWidget);

          // Press start time outlined button
          await tester.tap(startTimeFinder);
          await tester.pumpAndSettle();

          // Show time picker dialog when pressing start time outlined button
          expect(find.byType(TimePickerDialog), findsOneWidget);
        });
      },
    );

    testWidgets(
      'Show services menu list when pressing services dropdown button',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentForm);
          await tester.pumpAndSettle();

          // Dropdown widget is a dropdown button with text 'Non-Invasive Body Contouring'
          expect(dropdownFinder, findsOneWidget);

          await tester.tap(dropdownFinder);
          await tester.pumpAndSettle();

          // Show services menu list when pressing services dropdown button
          expect(find.byType(DropdownMenuItem<String>), findsWidgets);
        });
      },
    );

    testWidgets(
      'Enter another text in description text form field widget',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentForm);
          await tester.pumpAndSettle();

          // Description widget is a text form field with text 'Nothing to write.'
          expect(descriptionFinder, findsOneWidget);

          // Enter another text in description text form field widget
          await tester.enterText(descriptionFinder, 'Test description widget.');
          await tester.pumpAndSettle();

          // Show entered text
          expect(
            find.widgetWithText(
              TextFormField,
              'Test description widget.',
            ),
            findsWidgets,
          );
        });
      },
    );

    testWidgets(
      'Show submit elevated button',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentForm);
          await tester.pumpAndSettle();

          // Show elevated button with text 'Submit'
          expect(submitButtonFinder, findsOneWidget);
        });
      },
    );
  });

  group('Test new appointment form -', () {
    setUpAll(() {
      appointmentForm = BlocProvider.value(
        value: appointmentBloc,
        child: AppointmentForm(
          selectedDay: DateTime(2023, 10, 15),
        ),
      );

      newTitleTextFinder = find.text('New Appointment');

      hintDropdownFinder = find.widgetWithText(
        DropdownButton<String>,
        'Select Services',
      );
      hintDescriptionFinder = find.widgetWithText(
        TextFormField,
        'Description',
      );
      createButtonFinder = find.widgetWithText(
        ElevatedButton,
        'Create New Appointment',
      );
    });

    testWidgets(
      'Show app bar title text',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentForm);
          await tester.pumpAndSettle();

          // Show text 'New Appointment'
          expect(newTitleTextFinder, findsOneWidget);
        });
      },
    );

    testWidgets(
      'Show dropdown button with hint text',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentForm);
          await tester.pumpAndSettle();

          // Show dropdown button with text 'Select Services'
          expect(hintDropdownFinder, findsOneWidget);
        });
      },
    );

    testWidgets(
      'Show description text form field with hint text',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentForm);
          await tester.pumpAndSettle();

          // Show description text form field with text 'Description'
          expect(hintDescriptionFinder, findsOneWidget);
        });
      },
    );

    testWidgets(
      'Show create new appointment elevated button',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentForm);
          await tester.pumpAndSettle();

          // Show elevated button with text 'Create New Appointment'
          expect(createButtonFinder, findsOneWidget);
        });
      },
    );
  });
}
