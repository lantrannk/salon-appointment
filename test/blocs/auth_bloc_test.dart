import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart';
import 'package:salon_appointment/features/auth/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/mock_data/mock_data.dart';

class MockUserRepo extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late UserRepository userRepo;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    userRepo = MockUserRepo();

    when(() => userRepo.getUsers())
        .thenAnswer((_) async => MockDataUser.allUsers);

    when(() => userRepo.setUser(MockDataUser.adminUser))
        .thenAnswer((_) async => Future.value());

    when(() => userRepo.getUser())
        .thenAnswer((_) async => MockDataUser.adminUser);

    when(() => userRepo.removeUser()).thenAnswer((_) async => Future.value());
  });

  group('test auth bloc: login -', () {
    blocTest<AuthBloc, AuthState>(
      'login successful',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0794542105',
          password: '123456',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        LoginSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when phone number is empty',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '',
          password: '123456',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure('invalid-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when phone number is not a number',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: 'test_phone',
          password: '123456',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure('invalid-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when phone number is longer than 10 digits',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905123456789',
          password: '123456',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure('invalid-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when phone number is shorter than 10 digits',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905123',
          password: '123456',
        ),
      ),
      wait: const Duration(seconds: 2),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure('invalid-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when password is empty',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: '',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure('invalid-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when password is shorter than 6 characters',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: '123',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure('invalid-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when phone number not exist',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905123456',
          password: '123456',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure('incorrect-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when password is incorrect',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: '123456abcd',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure('incorrect-account'),
      ],
    );
  });

  group('test auth bloc: logout -', () {
    blocTest<AuthBloc, AuthState>(
      'logout successful',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LogoutEvent(),
      ),
      expect: () => <AuthState>[
        LogoutInProgress(),
        LogoutSuccess(),
      ],
    );
  });

  group('test auth bloc: user load -', () {
    blocTest<AuthBloc, AuthState>(
      'user load successful',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const UserLoad(),
      ),
      expect: () => <AuthState>[
        UserLoadSuccess(
          MockDataUser.adminUser.name,
          MockDataUser.adminUser.avatar,
        ),
      ],
    );
  });
}
