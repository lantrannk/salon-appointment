import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
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

  group('test outlined button -', () {
    group('Press login button with invalid phone number -', () {
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
          const LoginError('invalid-account'),
        ];
        whenListen(
          authBloc,
          Stream.fromIterable(expectedStates),
          initialState: LoginLoading(),
        );
      });

      testWidgets('phone number is blank', (tester) async {
        await tester.pumpWidget(loginScreen);
        await tester.enterText(find.byType(TextFormField).first, '');
        await tester.tap(find.widgetWithText(OutlinedButton, 'Log in'));
        await tester.pump();

        expect(
          find.widgetWithText(
            SnackBar,
            'Phone number or Password is invalid.',
          ),
          findsOneWidget,
        );
      });

      testWidgets('phone number is less than 10 digits', (tester) async {
        await tester.pumpWidget(loginScreen);
        await tester.enterText(find.byType(TextFormField).first, '123');
        await tester.tap(find.widgetWithText(OutlinedButton, 'Log in'));
        await tester.pump();

        expect(
          find.widgetWithText(
            SnackBar,
            'Phone number or Password is invalid.',
          ),
          findsOneWidget,
        );
      });

      testWidgets('phone number is more than 10 digits', (tester) async {
        await tester.pumpWidget(loginScreen);
        await tester.enterText(
            find.byType(TextFormField).first, '1234567890123');
        await tester.tap(find.widgetWithText(OutlinedButton, 'Log in'));
        await tester.pump();

        expect(
          find.widgetWithText(
            SnackBar,
            'Phone number or Password is invalid.',
          ),
          findsOneWidget,
        );
      });

      testWidgets('phone number is not a number', (tester) async {
        await tester.pumpWidget(loginScreen);
        await tester.enterText(find.byType(TextFormField).first, 'test_phone');
        await tester.tap(find.widgetWithText(OutlinedButton, 'Log in'));
        await tester.pump();

        expect(
          find.widgetWithText(
            SnackBar,
            'Phone number or Password is invalid.',
          ),
          findsOneWidget,
        );
      });
    });

    group('Press login button with invalid password -', () {
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
          const LoginError('invalid-account'),
        ];
        whenListen(
          authBloc,
          Stream.fromIterable(expectedStates),
          initialState: LoginLoading(),
        );
      });

      testWidgets('password is blank', (tester) async {
        await tester.pumpWidget(loginScreen);
        await tester.enterText(find.byType(TextFormField).last, '');
        await tester.tap(find.widgetWithText(OutlinedButton, 'Log in'));
        await tester.pump();

        expect(
          find.widgetWithText(
            SnackBar,
            'Phone number or Password is invalid.',
          ),
          findsOneWidget,
        );
      });

      testWidgets('password is less than 6 characters', (tester) async {
        await tester.pumpWidget(loginScreen);
        await tester.enterText(find.byType(TextFormField).last, '123');
        await tester.tap(find.widgetWithText(OutlinedButton, 'Log in'));
        await tester.pump();

        expect(
          find.widgetWithText(
            SnackBar,
            'Phone number or Password is invalid.',
          ),
          findsOneWidget,
        );
      });
    });

    group('Press login button with incorrect account -', () {
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

      testWidgets('phone number is not exist', (tester) async {
        await tester.pumpWidget(loginScreen);
        await tester.enterText(find.byType(TextFormField).first, '0905123456');
        await tester.enterText(find.byType(TextFormField).last, '123456');
        await tester.tap(find.widgetWithText(OutlinedButton, 'Log in'));
        await tester.pump();

        expect(
          find.widgetWithText(
            SnackBar,
            'Phone number or Password is incorrect.',
          ),
          findsOneWidget,
        );
      });

      testWidgets('password is not correct', (tester) async {
        await tester.pumpWidget(loginScreen);
        await tester.enterText(find.byType(TextFormField).first, '0905999222');
        await tester.enterText(find.byType(TextFormField).last, '123456abcd');
        await tester.tap(find.widgetWithText(OutlinedButton, 'Log in'));
        await tester.pump();

        expect(
          find.widgetWithText(
            SnackBar,
            'Phone number or Password is incorrect.',
          ),
          findsOneWidget,
        );
      });
    });
  });
}
