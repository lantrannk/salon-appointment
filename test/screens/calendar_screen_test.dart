import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:salon_appointment/core/theme/theme_provider.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/screens/appointments_widgets/appointments_widgets.dart';
import 'package:salon_appointment/features/appointments/screens/calendar_screen.dart';
import 'package:salon_appointment/features/auth/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../constants/mock_data/mock_data.dart';
import '../helpers/pump_app.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AppointmentBloc appointmentBloc;
  late Widget calendarScreen;
  late List<AppointmentState> expectedStates;

  late Finder calendarTitleTextFinder;
  late Finder monthCalendarFinder;
  late Finder currentMonthFinder;
  late Finder previousMonthFinder;
  late Finder nextMonthFinder;
  late Finder monthCalendarCellFinder;

  final appointments = MockDataAppointment.allAppointments;

  final users = MockDataUser.allUsers;
  final user = MockDataUser.adminUser;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    appointmentBloc = MockAppointmentBloc();

    final UserRepository userRepository = UserRepository();
    await userRepository.setUser(user);

    expectedStates = [
      AppointmentLoadInProgress(),
      AppointmentLoadSuccess(
        appointments: appointments,
        users: users,
      ),
    ];

    whenListen(
      appointmentBloc,
      Stream.fromIterable(expectedStates),
      initialState: AppointmentLoadInProgress(),
    );

    calendarScreen = ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
      child: BlocProvider.value(
        value: appointmentBloc,
        child: const CalendarScreen(),
      ),
    );

    calendarTitleTextFinder = find.widgetWithText(AppBar, 'Calendar');
    monthCalendarFinder = find.byType(TableCalendar<Appointment>);
    currentMonthFinder = find.widgetWithText(
      TableCalendar<Appointment>,
      'September 2023',
    );
    previousMonthFinder = find.widgetWithText(
      TableCalendar<Appointment>,
      'August 2023',
    );
    nextMonthFinder = find.widgetWithText(
      TableCalendar<Appointment>,
      'October 2023',
    );
    monthCalendarCellFinder = find.byType(MonthCalendarCell);
  });

  testWidgets(
    'Show app bar title text',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(calendarScreen);
        await tester.pump();

        // Show text 'Calendar'
        expect(calendarTitleTextFinder, findsOneWidget);
      });
    },
  );

  testWidgets(
    'Show table calendar with format month',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(calendarScreen);
        await tester.pump();

        // Show table calendar with format month
        // that has 5 weeks equivalent to 35 day cells (September 2023)
        expect(monthCalendarFinder, findsOneWidget);
        expect(monthCalendarCellFinder, findsNWidgets(35));
      });
    },
  );

  testWidgets(
    'Show table calendar with format month',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(calendarScreen);
        await tester.pump();

        // Show table calendar with format month
        // that has 5 weeks equivalent to 35 day cells (September 2023)
        // and 2 date 27th
        expect(monthCalendarFinder, findsOneWidget);
        expect(monthCalendarCellFinder, findsNWidgets(35));
      });
    },
  );

  testWidgets(
    'Show current month on calendar header',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(calendarScreen);
        await tester.pump();

        // Show current month on calendar header
        // September has no date 31st
        expect(currentMonthFinder, findsOneWidget);
        expect(find.text('31'), findsNothing);
      });
    },
  );

  testWidgets(
    'Show the previous month when pressing previous month on calendar header',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(calendarScreen);
        await tester.pump();

        // Show previous month on calendar header
        expect(previousMonthFinder, findsOneWidget);

        await tester.tap(previousMonthFinder);

        // August has date 31st
        expect(find.text('31'), findsNWidgets(2));
      });
    },
  );

  testWidgets(
    'Show the next month when pressing next month on calendar header',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(calendarScreen);
        await tester.pump();

        // Show next month on calendar header
        expect(nextMonthFinder, findsOneWidget);

        await tester.tap(nextMonthFinder);

        // October has date 31st
        expect(find.text('31'), findsOneWidget);
      });
    },
  );
}
