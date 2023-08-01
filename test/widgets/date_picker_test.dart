import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/constants/assets.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/screens/new_appointment_screen.dart';
import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AppointmentBloc appointmentBloc;
  late Widget newAppointmentScreen;
  late List<AppointmentState> expectedStates;
  late Finder datePickerFinder;
  late Finder scheduleIconFinder;
  late Finder calendarIconFinder;

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
          ),
        ),
      ),
    );

    final user = User.fromJson({
      'phoneNumber': '0794542105',
      'name': 'Lan Tran',
      'avatar':
          'https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg',
      'password': '123456',
      'isAdmin': true,
      'id': '1'
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user',
        '{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"}');

    expectedStates = [
      UserLoaded(user),
    ];
    whenListen(
      appointmentBloc,
      Stream.fromIterable(expectedStates),
      initialState: UserLoaded(user),
    );

    datePickerFinder = find.widgetWithText(TextButton, '15/08/2023');
    scheduleIconFinder = find.byIcon(Assets.scheduleIcon);
    calendarIconFinder = find.byIcon(Assets.calendarIcon);
  });

  testWidgets(
    'New Appointment Screen has one date picker widget',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(newAppointmentScreen);
        await tester.pumpAndSettle();

        // Date picker widget has 3 elements: schedule icon, date text button, calendar icon
        expect(datePickerFinder, findsOneWidget);
        expect(scheduleIconFinder, findsOneWidget);
        expect(calendarIconFinder, findsOneWidget);
      });
    },
  );

  testWidgets(
    'Show date picker dialog when pressing date text button',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(newAppointmentScreen);
        await tester.pumpAndSettle();

        // Press date text button
        await tester.tap(datePickerFinder);
        await tester.pumpAndSettle();

        // Show date picker dialog when pressing date text button
        expect(find.byType(DatePickerDialog), findsOneWidget);
      });
    },
  );

  testWidgets(
    'Show another date text button after selecting on date picker dialog',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(newAppointmentScreen);
        await tester.pumpAndSettle();

        // Press date text button
        await tester.tap(datePickerFinder);
        await tester.pumpAndSettle();

        // Press date and OK
        await tester.tap(find.text('20'));
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Show another date text button after selecting
        expect(find.widgetWithText(TextButton, '20/08/2023'), findsOneWidget);
      });
    },
  );
}
