import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/constants/assets.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart';
import 'package:salon_appointment/features/auth/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AuthBloc authBloc;
  late Widget profileScreen;
  late List<AuthState> expectedStates;
  late Finder logoutButtonFinder;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

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
      const UserLoaded(
        'Lan Tran',
        'https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg',
      ),
    ];
    whenListen(
      authBloc,
      Stream.fromIterable(expectedStates),
      initialState: const UserLoaded(
        'Lan Tran',
        'https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg',
      ),
    );

    logoutButtonFinder = find.widgetWithIcon(IconButton, Assets.logoutIcon);
  });

  testWidgets(
    'Profile Screen has one logout icon button',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(profileScreen);
        await tester.pumpAndSettle();

        // Logout icon button
        expect(logoutButtonFinder, findsOneWidget);
      });
    },
  );

  testWidgets(
    'Show confirm dialog when pressing logout icon button',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(profileScreen);
        await tester.pumpAndSettle();

        await tester.tap(logoutButtonFinder);
        await tester.pumpAndSettle();

        // Show confirm dialog when pressing logout button
        expect(find.byType(Dialog), findsOneWidget);
      });
    },
  );
}
