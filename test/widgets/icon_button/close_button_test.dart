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
import 'package:shared_preferences/shared_preferences.dart';

import '../../expect_data/expect_data.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AppointmentBloc appointmentBloc;
  late Widget newAppointmentScreen;
  late List<AppointmentState> expectedStates;
  late Finder closeButtonFinder;

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
    await prefs.setString('user', UserExpect.adminUserEncoded);

    expectedStates = [
      UserLoaded(UserExpect.adminUser),
    ];
    whenListen(
      appointmentBloc,
      Stream.fromIterable(expectedStates),
      initialState: UserLoaded(UserExpect.adminUser),
    );

    closeButtonFinder = find.widgetWithIcon(
      IconButton,
      Assets.closeIcon,
    );
  });

  testWidgets(
    'New Appointment Screen has one close icon button',
    (tester) async {
      await tester.pumpWidget(newAppointmentScreen);
      await tester.pump(const Duration(seconds: 1));

      // Close icon button
      expect(closeButtonFinder, findsOneWidget);
    },
  );

  testWidgets(
    'Pop new appointment screen when pressing close icon button',
    (tester) async {
      await tester.pumpWidget(newAppointmentScreen);
      await tester.pump(const Duration(seconds: 1));

      // Press close icon button
      await tester.tap(closeButtonFinder);
      await tester.pumpAndSettle();

      // Pop new appointment screen when pressing close icon button
      expect(closeButtonFinder, findsNothing);
    },
  );
}
