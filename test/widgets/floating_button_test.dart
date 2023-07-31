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
import 'package:salon_appointment/features/appointments/screens/calendar_screen.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart'
    as auth_bloc;
import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthBloc extends Mock implements auth_bloc.AuthBloc {}

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('test floating action button -', () {
    late auth_bloc.AuthBloc authBloc;
    late AppointmentBloc appointmentBloc;
    late Widget calendarScreen;
    late List<AppointmentState> expectedStates;

    setUp(() async {
      authBloc = MockAuthBloc();
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
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: authBloc),
              BlocProvider.value(value: appointmentBloc),
            ],
            child: const CalendarScreen(),
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

      expectedStates = [
        AppointmentLoading(),
        UserLoaded(user),
      ];
      whenListen(
        authBloc,
        Stream.fromIterable(expectedStates),
        initialState: AppointmentLoading(),
      );

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('user',
          '{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"}');
    });

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
}
