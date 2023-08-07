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
import 'package:salon_appointment/features/appointments/screens/appointments_screen.dart';
import 'package:salon_appointment/features/appointments/screens/appointments_widgets/appointments_widgets.dart';
import 'package:salon_appointment/features/auth/model/user.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../expect_data/expect_data.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AppointmentBloc appointmentBloc;
  late Widget appointmentScreen;
  late List<AppointmentState> expectedStates;
  late List<User> users;
  late List<Appointment> appointments;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    users = ExpectData.allUsers;
    appointments = ExpectData.allAppointments;

    appointmentBloc = MockAppointmentBloc();
    appointmentScreen = MediaQuery(
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
          child: AppointmentScreen(
            focusedDay: DateTime(2023, 08, 15),
          ),
        ),
      ),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      'user',
      ExpectData.adminUserStr,
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
  });

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
}
