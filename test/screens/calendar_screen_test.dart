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
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/screens/appointments_widgets/appointments_widgets.dart';
import 'package:salon_appointment/features/appointments/screens/calendar_screen.dart';
import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mock_data/mock_data.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('test floating action button -', () {
    late AppointmentBloc appointmentBloc;
    late Widget calendarScreen;
    late List<AppointmentState> expectedStates;

    setUp(() async {
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
        UserLoaded(MockDataUser.adminUser),
      ];
      whenListen(
        appointmentBloc,
        Stream.fromIterable(expectedStates),
        initialState: AppointmentLoading(),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', MockDataUser.adminUserJson);
    });

    testWidgets(
      'Show indicator when loading appointments in calendar screen',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(calendarScreen);
          await tester.pump();

          expect(find.byType(CircularProgressIndicator), findsOneWidget);
        });
      },
    );

    testWidgets('Bottom navigation bar has one FAB', (tester) async {
      await tester.pumpWidget(calendarScreen);
      await tester.pump(const Duration(seconds: 1));

      // Add floating action button
      expect(
        find.widgetWithIcon(FloatingActionButton, Assets.addIcon),
        findsOneWidget,
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Navigate to new appointment screen when pressing add FAB
      expect(find.text('New Appointment'), findsOneWidget);
    });
  });

  group('test month schedule -', () {
    late AppointmentBloc appointmentBloc;
    late Widget calendarScreen;
    late List<AppointmentState> expectedStates;
    late Finder tappedFinder;
    late Finder scheduleFinder;
    late Finder textButtonFinder;
    late List<User> users;
    late List<Appointment> appointments;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});

      users = MockDataUser.allUsers;
      appointments = MockDataAppointment.allAppointments;

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
        Stream.fromIterable([expectedStates, expectedStates]),
        initialState: AppointmentLoading(),
      );

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user', MockDataUser.adminUserJson);

      tappedFinder = find.widgetWithText(MonthCalendarCell, '15').first;
      scheduleFinder = find.byType(CalendarSchedule);
      textButtonFinder =
          find.widgetWithText(TextButton, 'Show appointments (4)');
    });

    testWidgets(
      'Current day has no appointments then show an empty notification',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(calendarScreen);
          await tester.pump();

          await Future.delayed(const Duration(seconds: 3));
          await tester.pumpAndSettle();

          expect(
            find.text('There are no appointments.'),
            findsOneWidget,
          );
        });
      },
    );

    testWidgets(
      'Select a day that has appointments then show calendar schedule',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(calendarScreen);
          await tester.pump();

          await Future.delayed(const Duration(seconds: 3));
          await tester.tap(tappedFinder);
          await tester.pumpAndSettle();

          expect(scheduleFinder, findsOneWidget);
        });
      },
    );

    testWidgets(
      'Select a day that has appointments then show calendar schedule with text button',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(calendarScreen);
          await tester.pump();

          await Future.delayed(const Duration(seconds: 3));
          await tester.tap(tappedFinder);
          await tester.pumpAndSettle();

          expect(textButtonFinder, findsOneWidget);
        });
      },
    );

    testWidgets(
      'Tap on text button then navigate to Appointment Screen',
      timeout: Timeout.none,
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(calendarScreen);
          await tester.pump();

          await Future.delayed(const Duration(seconds: 3));
          await tester.tap(tappedFinder);
          await tester.pumpAndSettle();

          await tester.tap(
            textButtonFinder,
            warnIfMissed: false,
          );
          await Future.delayed(const Duration(seconds: 3));
          await tester.pumpAndSettle();

          expect(find.text('Appointments'), findsOneWidget);
        });
      },
    );
  });

  group('test month table calendar -', () {
    late AppointmentBloc appointmentBloc;
    late Widget calendarScreen;
    late List<AppointmentState> expectedStates;
    late List<User> users;
    late List<Appointment> appointments;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});

      users = MockDataUser.allUsers;
      appointments = MockDataAppointment.allAppointments;

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
      await prefs.setString('user', MockDataUser.adminUserJson);
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
  });
}
