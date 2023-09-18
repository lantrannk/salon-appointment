import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart';
import 'package:salon_appointment/features/auth/screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/mock_data/mock_data.dart';
import '../helpers/pump_app.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AuthBloc authBloc;
  late Widget loginScreen;
  late List<AuthState> expectedStates;

  late Finder logoTextFinder;
  late Finder phoneNumberInputFinder;
  late Finder passwordInputFinder;
  late Finder loginButtonFinder;

  const user = MockDataUser.adminUser;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    authBloc = MockAuthBloc();
    loginScreen = BlocProvider.value(
      value: authBloc,
      child: const LoginScreen(),
    );

    expectedStates = [
      UserLoadSuccess(
        user.name,
        user.avatar,
      ),
    ];

    whenListen(
      authBloc,
      Stream.fromIterable(expectedStates),
      initialState: UserLoadSuccess(
        user.name,
        user.avatar,
      ),
    );

    logoTextFinder = find.text('avisit');
    phoneNumberInputFinder = find.widgetWithText(TextFormField, 'Phone number');
    passwordInputFinder = find.widgetWithText(TextFormField, 'Password');
    loginButtonFinder = find.widgetWithText(OutlinedButton, 'Log in');
  });

  testWidgets(
    'Show app logo text',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(loginScreen);
        await tester.pumpAndSettle();

        // Show text 'avisit'
        expect(logoTextFinder, findsOneWidget);
      });
    },
  );

  testWidgets(
    'Show error text when enter an invalid text into phone number text form field',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(loginScreen);
        await tester.pumpAndSettle();

        // Show text form field with hint text 'Phone number'
        expect(phoneNumberInputFinder, findsOneWidget);

        // Enter an invalid phone number
        // Valid phone number includes:
        // Phone numbers must contain 10 digits
        // In case country code us used, it can be 12 digits
        // No space or no characters allowed between digits
        await tester.enterText(phoneNumberInputFinder, '090-234-4567');
        await tester.pumpAndSettle();

        // Show error text
        expect(find.text('Invalid phone number.'), findsOneWidget);
      });
    },
  );

  testWidgets(
    'Enter a valid text into phone number text form field',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(loginScreen);
        await tester.pumpAndSettle();

        // Show text form field with hint text 'Phone number'
        expect(phoneNumberInputFinder, findsOneWidget);

        // Enter a valid phone number
        await tester.enterText(phoneNumberInputFinder, '0794542105');
        await tester.pumpAndSettle();

        // Show valid text
        expect(find.text('0794542105'), findsOneWidget);
      });
    },
  );

  testWidgets(
    'Show error text when enter an invalid text into password text form field',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(loginScreen);
        await tester.pumpAndSettle();

        // Show text form field with hint text 'Password'
        expect(passwordInputFinder, findsOneWidget);

        // Enter an invalid password
        // Valid phone number includes:
        // At least 8 characters
        // At least 1 Uppercase
        // At least 1 lowercase
        // At least 1 numberic character
        // At least 1 special character
        // Common Allow Character ( ! @ # $ & * ~ )
        await tester.enterText(passwordInputFinder, '12345678');
        await tester.pumpAndSettle();

        // Show error text
        expect(find.text('Invalid password.'), findsOneWidget);
      });
    },
  );

  testWidgets(
    'Enter a valid text into password text form field',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(loginScreen);
        await tester.pumpAndSettle();

        // Show text form field with hint text 'Password'
        expect(passwordInputFinder, findsOneWidget);

        // Enter a valid password
        await tester.enterText(passwordInputFinder, 'qwQW12!@');
        await tester.pumpAndSettle();

        // Error text not found
        expect(find.text('Invalid password.'), findsNothing);
      });
    },
  );

  testWidgets(
    'Show login outlined button',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(loginScreen);
        await tester.pumpAndSettle();

        // Show login outlined button
        expect(loginButtonFinder, findsOneWidget);
      });
    },
  );
}
