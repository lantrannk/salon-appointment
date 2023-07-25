import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
import 'package:salon_appointment/core/widgets/widgets.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart';
import 'package:salon_appointment/features/auth/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('test indicator when login success', () {
    late AuthBloc authBloc;
    late Widget loginScreen;
    late List<AuthState> expectedStates;

    setUp(() async {
      authBloc = MockAuthBloc();
      loginScreen = MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: BlocProvider.value(
          value: authBloc,
          child: const LoginScreen(),
        ),
      );

      expectedStates = [
        LoginLoading(),
        const LoginError('incorrect-account'),
      ];
      whenListen(
        authBloc,
        Stream.fromIterable(expectedStates),
        initialState: LoginLoading(),
      );
    });

    testWidgets('', (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.enterText(find.byType(TextFormField).first, '0905123456');
      await tester.enterText(find.byType(TextFormField).last, '123456');
      await tester.tap(find.widgetWithText(OutlinedButton, 'Log in'));
      await tester.pump();

      expect(
        find.byType(SAIndicator),
        findsOneWidget,
      );
    });
  });
}
