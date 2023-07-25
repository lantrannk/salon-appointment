import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/screens/calendar_screen.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });
  group('test floating action button -', () {
    late AuthBloc authBloc;
    late AppointmentBloc appointmentBloc;
    late Widget calendarScreen;
    late List<AppointmentState> expectedStates;

    setUp(() async {
      authBloc = MockAuthBloc();
      appointmentBloc = MockAppointmentBloc();
      calendarScreen = MaterialApp(
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
      );

      expectedStates = [
        AppointmentLoading(),
      ];
      whenListen(
        authBloc,
        Stream.fromIterable(expectedStates),
        initialState: AppointmentLoading(),
      );
    });

    testWidgets('Bottom navigation bar has one FAB', (tester) async {
      await tester.pumpWidget(calendarScreen);
      await tester.pumpAndSettle();

      expect(find.byType(FloatingActionButton), findsOneWidget);
    });
  });
}
