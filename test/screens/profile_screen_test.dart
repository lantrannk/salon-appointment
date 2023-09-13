import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';
import 'package:salon_appointment/core/constants/constants.dart';
import 'package:salon_appointment/core/theme/theme_provider.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart';
import 'package:salon_appointment/features/auth/repository/user_repository.dart';
import 'package:salon_appointment/features/auth/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/mock_data/mock_data.dart';
import '../helpers/pump_app.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AuthBloc authBloc;
  late Widget profileScreen;
  late List<AuthState> expectedStates;

  late Finder titleTextFinder;
  late Finder userAvatarFinder;
  late Finder userNameFinder;
  late Finder logoutButtonFinder;

  final user = MockDataUser.adminUser;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    authBloc = MockAuthBloc();

    final UserRepository userRepository = UserRepository();
    await userRepository.setUser(user);

    profileScreen = ChangeNotifierProvider<ThemeProvider>(
      create: (context) => ThemeProvider(),
      child: BlocProvider.value(
        value: authBloc,
        child: const ProfileScreen(),
      ),
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

    titleTextFinder = find.widgetWithText(AppBar, 'Profile');
    userAvatarFinder = find.image(NetworkImage(user.avatar));
    userNameFinder = find.text('Lan Tran');
    logoutButtonFinder = find.widgetWithIcon(
      IconButton,
      Assets.logoutIcon,
    );
  });

  testWidgets(
    'Show app bar title text',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(profileScreen);
        await tester.pumpAndSettle();

        // Show text 'Profile'
        expect(titleTextFinder, findsOneWidget);
      });
    },
  );

  /// Cannot find [Image]

  // testWidgets(
  //   'Show user avatar image',
  //   (tester) async {
  //     await tester.runAsync(() async {
  //       await tester.pumpApp(profileScreen);
  //       await tester.pumpAndSettle();

  //       // Show user avatar image
  //       expect(userAvatarFinder, findsOneWidget);
  //     });
  //   },
  // );

  testWidgets(
    'Show user name text',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(profileScreen);
        await tester.pumpAndSettle();

        // Show user name text 'Lan Tran'
        expect(userNameFinder, findsOneWidget);
      });
    },
  );

  testWidgets(
    'Show a confirm dialog when pressing logout icon button',
    (tester) async {
      await tester.runAsync(() async {
        await tester.pumpApp(profileScreen);
        await tester.pumpAndSettle();

        // Show logout icon button
        expect(logoutButtonFinder, findsOneWidget);

        // Press logout icon button
        await tester.tap(logoutButtonFinder);
        await tester.pumpAndSettle();

        // Show a dialog with title text 'Logout'
        expect(find.widgetWithText(Dialog, 'Logout'), findsOneWidget);
      });
    },
  );
}
