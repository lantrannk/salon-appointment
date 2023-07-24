import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart';
import 'package:salon_appointment/features/auth/screens/login_screen.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  late AuthBloc authBloc;
  late Widget loginScreen;
  late List<AuthState> expectedStates;

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
}
