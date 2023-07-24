import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart';
import 'package:salon_appointment/features/auth/screens/login_screen.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

class MockClient extends Mock implements http.Client {}

void main() {
  group('test outlined button -', () {
    late AuthBloc authBloc;
    late Widget loginScreen;
    late List<AuthState> expectedStates;
    late http.Client client;

    const expectedStr =
        '[{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"},{"phoneNumber":"0905999222","name":"Carol Williams","avatar":"https://assets.vogue.in/photos/611cf20c8733032148fe1b06/2:3/w_2560%2Cc_limit/Slide%25201.jpg","password":"123456","isAdmin":false,"id":"2"},{"phoneNumber":"0934125689","name":"Hailee Steinfeld","avatar":"https://glints.com/vn/blog/wp-content/uploads/2022/08/co%CC%82ng-vie%CC%A3%CC%82c-beauty-blogger-819x1024.jpg","password":"123456","isAdmin":false,"id":"3"},{"phoneNumber":"0902335577","name":"Ruby Nguyen","avatar":"https://studiochupanhdep.com//Upload/Images/Album/anh-beauty-11.jpg","password":"123456","isAdmin":false,"id":"4"},{"phoneNumber":"070456123","name":"Elizabeth Taylor","avatar":"https://www.m1-beauty.de/assets/images/f/Ronja_VorherNachher_45Grad_2-c7cc48ca.jpg","password":"123456","isAdmin":false,"id":"5"}]';
    setUp(() async {
      authBloc = MockAuthBloc();
      client = MockClient();
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

      when(
        () => client.get(
          Uri.parse('https://63ab8e97fdc006ba60609b9b.mockapi.io/users'),
        ),
      ).thenAnswer(
        (_) async => http.Response(
          expectedStr,
          200,
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

    group('Press login button with invalid phone number -', () {
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
    });
  });
}
