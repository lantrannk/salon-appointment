import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/constants/assets.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart'
    as appointment;
import 'package:salon_appointment/features/appointments/screens/new_appointment_screen.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart' as auth;
import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:salon_appointment/features/auth/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthBloc extends Mock implements auth.AuthBloc {}

class MockAppointmentBloc extends Mock implements appointment.AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('test logout button -', () {
    late auth.AuthBloc authBloc;
    late Widget profileScreen;
    late List<auth.AuthState> expectedStates;

    setUp(() async {
      authBloc = MockAuthBloc();
      profileScreen = MediaQuery(
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
            value: authBloc,
            child: const ProfileScreen(),
          ),
        ),
      );

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('user',
          '{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"}');

      expectedStates = [
        const auth.UserLoaded(
          'Lan Tran',
          'https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg',
        ),
      ];
      whenListen(
        authBloc,
        Stream.fromIterable(expectedStates),
        initialState: const auth.UserLoaded(
          'Lan Tran',
          'https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg',
        ),
      );
    });

    testWidgets('Profile Screen has one icon button', (tester) async {
      await tester.pumpWidget(profileScreen);
      await tester.pump(const Duration(seconds: 1));

      expect(
          find.widgetWithIcon(IconButton, Assets.logoutIcon), findsOneWidget);
    });
  });

  group('test close icon button -', () {
    late appointment.AppointmentBloc appointmentBloc;
    late Widget newAppointmentScreen;
    late List<appointment.AppointmentState> expectedStates;

    setUp(() async {
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
        appointment.UserLoaded(user),
      ];
      whenListen(
        appointmentBloc,
        Stream.fromIterable(expectedStates),
        initialState: appointment.UserLoaded(user),
      );
    });

    testWidgets('New Appointment Screen has one icon button', (tester) async {
      await tester.pumpWidget(newAppointmentScreen);
      await tester.pump(const Duration(seconds: 1));

      // Customer name
      final customerNameFinder = find.text('Lan Tran');
      // Close button
      final closeButtonFinder =
          find.widgetWithIcon(IconButton, Assets.closeIcon);

      expect(customerNameFinder, findsOneWidget);
      expect(closeButtonFinder, findsOneWidget);

      await tester.tap(closeButtonFinder);
      await tester.pumpAndSettle();

      expect(customerNameFinder, findsNothing);
      expect(closeButtonFinder, findsNothing);
    });
  });
}
