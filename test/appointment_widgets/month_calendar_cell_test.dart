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
import 'package:salon_appointment/features/appointments/screens/appointments_widgets/appointments_widgets.dart';
import 'package:salon_appointment/features/appointments/screens/calendar_screen.dart';

import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../expect_data/expect_data.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AppointmentBloc appointmentBloc;
  late Widget calendarScreen;
  late List<AppointmentState> expectedStates;
  late List<User> users;
  late List<Appointment> appointments;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    users = ExpectData.allUsers;
    appointments = ExpectData.allAppointments;

    appointmentBloc = MockAppointmentBloc();
    calendarScreen = MediaQuery(
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
          child: const CalendarScreen(),
        ),
      ),
    );

    expectedStates = [
      AppointmentLoading(),
      AppointmentLoadSuccess(
        users: users,
        appointments: appointments,
      ),
    ];
    whenListen(
      appointmentBloc,
      Stream.fromIterable(expectedStates),
      initialState: AppointmentLoading(),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', ExpectData.adminUserStr);
  });

  testWidgets(
    'Selected day cell has gradient color',
    (tester) async {
      final nowFinder = find.widgetWithText(
        MonthCalendarCell,
        DateTime.now().day.toString(),
      );

      await tester.runAsync(() async {
        await tester.pumpWidget(calendarScreen);
        await tester.pump();

        expect(
          (tester.widget(nowFinder) as MonthCalendarCell).gradient,
          isA<LinearGradient>(),
        );
      });
    },
  );

  testWidgets(
    'Change selected day when tapping another day',
    (tester) async {
      final tappedFinder = find
          .widgetWithText(
            MonthCalendarCell,
            '1',
          )
          .first;

      await tester.runAsync(() async {
        await tester.pumpWidget(calendarScreen);
        await tester.pump();

        await Future.delayed(const Duration(seconds: 3));
        await tester.tap(tappedFinder);
        await tester.pumpAndSettle();

        expect(
          (tester.widget(tappedFinder) as MonthCalendarCell).gradient,
          isA<LinearGradient>(),
        );
      });
    },
  );
}
