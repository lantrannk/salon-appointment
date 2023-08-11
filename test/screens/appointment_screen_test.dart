import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/constants/assets.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/screens/appointments_screen.dart';
import 'package:salon_appointment/features/appointments/screens/appointments_widgets/appointments_widgets.dart';
import 'package:salon_appointment/features/auth/model/user.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/pump_app.dart';
import '../mock_data/mock_data.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AppointmentBloc appointmentBloc;
  late Widget appointmentScreen;
  late List<AppointmentState> expectedStates;
  late List<User> users;
  late List<Appointment> appointments;

  late Finder editButtonFinder;
  late Finder removeButtonFinder;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    users = MockDataUser.allUsers;
    appointments = MockDataAppointment.allAppointments;

    appointmentBloc = MockAppointmentBloc();
    appointmentScreen = BlocProvider.value(
      value: appointmentBloc,
      child: AppointmentScreen(
        focusedDay: DateTime(2023, 08, 15),
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', MockDataUser.adminUserJson);

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

    editButtonFinder = find.widgetWithIcon(
      IconButton,
      Assets.editIcon,
    );

    removeButtonFinder = find.widgetWithIcon(
      IconButton,
      Assets.removeIcon,
    );
  });

  testWidgets(
    'Show indicator when loading appointments in appointment screen',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(appointmentScreen);
        await tester.pump();

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      });
    },
  );

  group('test edit button -', () {
    testWidgets(
      'Appointment Screen has one edit icon button on each appointment card',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentScreen);
          await tester.pump();

          // Loading appointments
          expect(find.byType(CircularProgressIndicator), findsOneWidget);

          await Future.delayed(const Duration(seconds: 2));
          await tester.pumpAndSettle();

          // Edit icon button
          expect(editButtonFinder, findsNWidgets(2));
        });
      },
    );

    testWidgets(
      'Navigate to edit appointment screen when pressing edit icon button',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentScreen);
          await tester.pump();

          // Loading appointments
          expect(find.byType(CircularProgressIndicator), findsOneWidget);

          await Future.delayed(const Duration(seconds: 2));
          await tester.pumpAndSettle();

          // Press edit icon button
          await tester.tap(editButtonFinder.first);
          await tester.pumpAndSettle();

          // Navigate to edit appointment screen when pressing edit icon button
          expect(find.text('Edit Appointment'), findsOneWidget);
        });
      },
    );
  });

  group('test remove button -', () {
    testWidgets(
      'Appointment Screen has one remove icon button on each appointment card',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentScreen);
          await tester.pump();

          // Loading appointments
          expect(find.byType(CircularProgressIndicator), findsOneWidget);

          await Future.delayed(const Duration(seconds: 2));
          await tester.pumpAndSettle();

          // Remove icon button
          expect(removeButtonFinder, findsNWidgets(2));
        });
      },
    );

    testWidgets(
      'Show confirm dialog when pressing remove icon button',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpApp(appointmentScreen);
          await tester.pump();

          // Loading appointments
          expect(find.byType(CircularProgressIndicator), findsOneWidget);

          await Future.delayed(const Duration(seconds: 2));
          await tester.pumpAndSettle();

          // Press remove icon button
          await tester.tap(removeButtonFinder.first);
          await tester.pumpAndSettle();

          // Show confirm dialog when pressing remove icon button
          expect(
            find.widgetWithText(Dialog, 'Remove Appointment'),
            findsOneWidget,
          );
        });
      },
    );
  });

  group('test appointment card -', () {
    testWidgets(
      'Appointment Card has one appointment time widget',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(appointmentScreen);
          await tester.pump();

          await Future.delayed(const Duration(seconds: 3));
          await tester.pumpAndSettle();

          expect(
            find.widgetWithText(
              AppointmentCard,
              '18:00 - 18:30',
            ),
            findsOneWidget,
          );

          expect(
            find.widgetWithText(
              AppointmentCard,
              '19:00 - 19:30',
            ),
            findsOneWidget,
          );

          expect(
            find.widgetWithText(
              AppointmentCard,
              'Beauty Salon',
            ),
            findsNWidgets(2),
          );
        });
      },
    );

    testWidgets(
      'Appointment Card has one customer\'s name widget',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(appointmentScreen);
          await tester.pump();

          await Future.delayed(const Duration(seconds: 3));
          await tester.pumpAndSettle();

          expect(
            find.widgetWithText(AppointmentCard, 'Carol Williams'),
            findsOneWidget,
          );

          expect(
            find.widgetWithText(AppointmentCard, 'Lan Tran'),
            findsOneWidget,
          );
        });
      },
    );

    testWidgets(
      'Appointment Card has one appointment service widget',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(appointmentScreen);
          await tester.pump();

          await Future.delayed(const Duration(seconds: 3));
          await tester.pumpAndSettle();

          expect(
            find.widgetWithText(
              AppointmentCard,
              'Non-Invasive Body Contouring',
            ),
            findsNWidgets(2),
          );
        });
      },
    );

    testWidgets(
      'Appointment Card has one appointment description widget',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(appointmentScreen);
          await tester.pump();

          await Future.delayed(const Duration(seconds: 3));
          await tester.pumpAndSettle();

          expect(
            find.widgetWithText(
              AppointmentCard,
              'Nothing to write.',
            ),
            findsNWidgets(2),
          );
        });
      },
    );
  });

  group('test table calendar -', () {
    testWidgets(
      'Appointment Screen has a weekly calendar (7 Calendar Cell widgets)',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(appointmentScreen);
          await tester.pump();

          await Future.delayed(const Duration(seconds: 3));
          await tester.pumpAndSettle();

          expect(
            find.byType(CalendarCell),
            findsNWidgets(7),
          );
        });
      },
    );

    testWidgets(
      'Selected Calendar Cell has gradient color',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(appointmentScreen);
          await tester.pump();

          await Future.delayed(const Duration(seconds: 3));
          await tester.pumpAndSettle();

          expect(
            (tester.widget(find.byType(CalendarCell).at(1)) as CalendarCell)
                .gradient,
            isA<LinearGradient>(),
          );
        });
      },
    );

    testWidgets(
      'Change selected day when tapping another day',
      (tester) async {
        await tester.runAsync(() async {
          await tester.pumpWidget(appointmentScreen);
          await tester.pump();

          await Future.delayed(const Duration(seconds: 3));

          expect(
            (tester.widget(find.byType(CalendarCell).at(1)) as CalendarCell)
                .gradient,
            isA<LinearGradient>(),
          );
          await tester.pumpAndSettle();

          await tester.tap(find.widgetWithText(CalendarCell, '17'));
          await tester.pumpAndSettle();

          expect(
            (tester.widget(find.byType(CalendarCell).at(1)) as CalendarCell)
                .gradient,
            null,
          );

          expect(
            (tester.widget(find.byType(CalendarCell).at(3)) as CalendarCell)
                .gradient,
            isA<LinearGradient>(),
          );
        });
      },
    );
  });
}
