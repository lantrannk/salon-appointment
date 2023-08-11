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

  late AuthBloc authBloc;
  late Widget loginScreen;
  late List<AuthState> expectedStates;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('test input widget -', () {
    setUp(() {
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

    testWidgets('Login Screen has two text form field', (tester) async {
      // Run app with LoginScreen()
      await tester.pumpWidget(loginScreen);
      await tester.pumpAndSettle();

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(
        find.widgetWithText(TextFormField, 'Phone number'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(TextFormField, 'Password'),
        findsOneWidget,
      );
    });

    group('phone number input -', () {
      testWidgets(
          'Enter an empty text to phone number input then show an error text',
          (tester) async {
        // Run app with LoginScreen()
        await tester.pumpWidget(loginScreen);

        // Enter a less-than-10-digit to phone number input
        await tester.enterText(find.byType(TextFormField).first, '123');

        // Enter an empty text to phone number input
        await tester.enterText(find.byType(TextFormField).first, '');

        await tester.pumpAndSettle();

        // Error text: Phone number is blank.
        expect(find.text('Phone number is blank.'), findsOneWidget);
      });

      testWidgets(
          'Enter a less-than-10-digit text to phone number input then show an error text',
          (tester) async {
        // Run app with LoginScreen()
        await tester.pumpWidget(loginScreen);

        // Enter a less-than-10-digit to phone number input
        await tester.enterText(find.byType(TextFormField).first, '123');

        await tester.pumpAndSettle();

        // Error text: Phone number must have 10 digits.
        expect(find.text('Phone number must have 10 digits.'), findsOneWidget);
      });

      testWidgets(
          'Enter a more-10-digit text to phone number input then show an error text',
          (tester) async {
        // Run app with LoginScreen()
        await tester.pumpWidget(loginScreen);

        // Enter a more-than-10-digit text to phone number input
        await tester.enterText(
            find.byType(TextFormField).first, '0905123456789');

        await tester.pumpAndSettle();

        // Error text: Phone number must have 10 digits.
        expect(find.text('Phone number must have 10 digits.'), findsOneWidget);
      });

      testWidgets(
          'Enter a not-number text to phone number input then show an error text',
          (tester) async {
        // Run app with LoginScreen()
        await tester.pumpWidget(loginScreen);

        // Enter a not-number text to phone number input
        await tester.enterText(find.byType(TextFormField).first, 'test_phone');

        await tester.pumpAndSettle();

        // Error text: Phone number must be a string of digits.
        expect(find.text('Phone number must be a string of digits.'),
            findsOneWidget);
      });

      testWidgets('Enter valid text to phone number input after an invalid one',
          (tester) async {
        // Run app with LoginScreen()
        await tester.pumpWidget(loginScreen);

        // Enter a less-than-10-digit to phone number input
        await tester.enterText(find.byType(TextFormField).first, '123');
        await tester.pumpAndSettle();

        // Error text: Phone number must have 10 digits.
        expect(find.text('Phone number must have 10 digits.'), findsOneWidget);

        // Enter an empty text to phone number input
        await tester.enterText(find.byType(TextFormField).first, '');
        await tester.pumpAndSettle();

        // Error text: Replaced by Phone number is blank.
        expect(find.text('Phone number must have 10 digits.'), findsNothing);
        expect(find.text('Phone number is blank.'), findsOneWidget);

        // Enter a more-than-10-digit text to phone number input
        await tester.enterText(
            find.byType(TextFormField).first, '0905123456789');
        await tester.pumpAndSettle();

        // Error text: Replaced by Phone number must have 10 digits.
        expect(find.text('Phone number is blank.'), findsNothing);
        expect(find.text('Phone number must have 10 digits.'), findsOneWidget);

        // Enter a not-number text to phone number input
        await tester.enterText(find.byType(TextFormField).first, 'test_phone');
        await tester.pumpAndSettle();

        // Error text: Replaced by Phone number must be a string of digits.
        expect(find.text('Phone number must have 10 digits.'), findsNothing);
        expect(find.text('Phone number must be a string of digits.'),
            findsOneWidget);

        // Enter a valid phone number input
        await tester.enterText(find.byType(TextFormField).first, '0905123456');
        await tester.pumpAndSettle();

        // Error text: Null
        expect(find.text('Phone number must be a string of digits.'),
            findsNothing);
        expect(find.text('Phone number must have 10 digits.'), findsNothing);
        expect(find.text('Phone number is blank.'), findsNothing);
      });
    });

    group('password input -', () {
      testWidgets(
          'Enter an empty text to password input then show an error text',
          (tester) async {
        // Run app with LoginScreen()
        await tester.pumpWidget(loginScreen);

        // Enter a less-than-6-character text to password input
        await tester.enterText(find.byType(TextFormField).last, '123');

        // Enter an empty text to password input
        await tester.enterText(find.byType(TextFormField).last, '');
        await tester.pumpAndSettle();

        // Error text: Password is blank.
        expect(find.text('Password is blank.'), findsOneWidget);
      });

      testWidgets(
          'Enter a less-6-character text to password input then show an error text',
          (tester) async {
        // Run app with LoginScreen()
        await tester.pumpWidget(loginScreen);

        // Enter a less-than-6-character text to password input
        await tester.enterText(find.byType(TextFormField).last, '123');
        await tester.pumpAndSettle();

        // Error text: Password must be at least 6 characters.
        expect(find.text('Password must be at least 6 characters.'),
            findsOneWidget);
      });

      testWidgets('Enter valid text to password input after an invalid one',
          (tester) async {
        // Run app with LoginScreen()
        await tester.pumpWidget(loginScreen);

        // Enter a less-than-6-character text to password input
        await tester.enterText(find.byType(TextFormField).last, '123');
        await tester.pumpAndSettle();

        // Error text: Password must be at least 6 characters.
        expect(find.text('Password must be at least 6 characters.'),
            findsOneWidget);

        // Enter an empty text to password input
        await tester.enterText(find.byType(TextFormField).last, '');
        await tester.pumpAndSettle();

        // Error text: Replaced by Password is blank.
        expect(
            find.text('Password must be at least 6 characters.'), findsNothing);
        expect(find.text('Password is blank.'), findsOneWidget);

        // Enter a valid password input
        await tester.enterText(find.byType(TextFormField).last, '123456789');
        await tester.pumpAndSettle();

        // Error text: Null
        expect(find.text('Password is blank.'), findsNothing);
        expect(
            find.text('Password must be at least 6 characters.'), findsNothing);
      });
    });
  });

  group('test outlined button -', () {
    group('Press login button with invalid phone number -', () {
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
