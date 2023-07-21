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

  setUpAll(() {
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
  });

  group('test login screen widgets -', () {
    testWidgets('Login Screen has one logo text', (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.pumpAndSettle();

      expect(find.text('avisit'), findsOneWidget);
    });

    testWidgets('Login Screen has two text form field', (tester) async {
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

    testWidgets('Login Screen has one outlined button', (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.pumpAndSettle();

      expect(
        find.widgetWithText(OutlinedButton, 'Log in'),
        findsOneWidget,
      );
    });
  });

  group('test phone number text form field -', () {
    testWidgets(
        'Enter an empty text to phone number text field then show an error text',
        (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.enterText(find.byType(TextFormField).first, '123');
      await tester.enterText(find.byType(TextFormField).first, '');
      await tester.pumpAndSettle();

      expect(find.text('Phone number is blank.'), findsOneWidget);
    });

    testWidgets(
        'Enter a less-10-digit text to phone number text field then show an error text',
        (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.enterText(find.byType(TextFormField).first, '123');
      await tester.pumpAndSettle();

      expect(find.text('Phone number must have 10 digits.'), findsOneWidget);
    });

    testWidgets(
        'Enter a greater-10-digit text to phone number text field then show an error text',
        (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.enterText(find.byType(TextFormField).first, '0905123456789');
      await tester.pumpAndSettle();

      expect(find.text('Phone number must have 10 digits.'), findsOneWidget);
    });

    testWidgets(
        'Enter a not-number text to phone number text field then show an error text',
        (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.enterText(find.byType(TextFormField).first, 'test_phone');
      await tester.pumpAndSettle();

      expect(find.text('Phone number must be a string of digits.'),
          findsOneWidget);
    });

    testWidgets('Enter a valid text to phone number text field',
        (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.enterText(find.byType(TextFormField).first, '0905123456');
      await tester.pumpAndSettle();

      expect(find.text('Phone number is blank.'), findsNothing);
      expect(find.text('Phone number must have 10 digits.'), findsNothing);
      expect(
          find.text('Phone number must be a string of digits.'), findsNothing);
    });
  });

  group('test password text form field -', () {
    testWidgets(
        'Enter an empty text to password text field then show an error text',
        (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.enterText(find.byType(TextFormField).last, '123');
      await tester.enterText(find.byType(TextFormField).last, '');
      await tester.pumpAndSettle();

      expect(find.text('Password is blank.'), findsOneWidget);
    });

    testWidgets(
        'Enter a less-6-character text to password text field then show an error text',
        (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.enterText(find.byType(TextFormField).last, '123');
      await tester.pumpAndSettle();

      expect(
          find.text('Password must be at least 6 characters.'), findsOneWidget);
    });

    testWidgets('Enter a valid text to password text field', (tester) async {
      await tester.pumpWidget(loginScreen);
      await tester.enterText(find.byType(TextFormField).last, '123456789');
      await tester.pumpAndSettle();

      expect(find.text('Password is blank.'), findsNothing);
      expect(
          find.text('Password must be at least 6 characters.'), findsNothing);
    });
  });

  group('test outlined button -', () {
    testWidgets('Press login button with invalid phone number', (tester) async {
      final expectedStates = [
        LoginLoading(),
        const LoginError('invalid-account'),
      ];

      whenListen(
        authBloc,
        Stream.fromIterable(expectedStates),
        initialState: LoginLoading(),
      );

      await tester.pumpWidget(loginScreen);
      await tester.enterText(find.byType(TextFormField).first, 'test_phone');
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
  });
}
