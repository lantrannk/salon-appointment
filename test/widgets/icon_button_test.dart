import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/generated/l10n.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart';
import 'package:salon_appointment/features/auth/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('test icon button -', () {
    late AuthBloc authBloc;
    late Widget profileScreen;
    late List<AuthState> expectedStates;

    setUp(() async {
      authBloc = MockAuthBloc();
      profileScreen = MaterialApp(
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
      );

      final prefs = await SharedPreferences.getInstance();

      await prefs.setString('user',
          '{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"}');

      expectedStates = [
        const UserLoaded(
          'Lan Tran',
          'https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg',
        ),
        LogoutInProgress(),
        LogoutSuccess(),
      ];
      whenListen(
        authBloc,
        Stream.fromIterable(expectedStates),
        initialState: const UserLoaded(
          'Lan Tran',
          'https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg',
        ),
      );
    });

    testWidgets('Press logout button', (tester) async {
      await tester.pumpWidget(profileScreen);
      // await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(find.byType(IconButton), findsOneWidget);
    });
  });
}
