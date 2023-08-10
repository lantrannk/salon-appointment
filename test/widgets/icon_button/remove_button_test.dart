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
import 'package:salon_appointment/features/appointments/screens/appointments_screen.dart';
import 'package:salon_appointment/features/auth/model/user.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../mock_data/mock_data.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AppointmentBloc appointmentBloc;
  late Widget appointmentScreen;
  late List<AppointmentState> expectedStates;
  late Finder removeButtonFinder;
  late List<User> users;
  late List<Appointment> appointments;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    users = MockDataUser.allUsers;
    appointments = MockDataAppointment.allAppointments;

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

    removeButtonFinder = find.widgetWithIcon(
      IconButton,
      Assets.removeIcon,
    );
  });

  testWidgets(
    'Appointment Screen has one remove icon button on each appointment card',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(appointmentScreen);
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
        await tester.pumpWidget(appointmentScreen);
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
}
