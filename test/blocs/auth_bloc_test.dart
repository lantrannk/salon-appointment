import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart';
import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:salon_appointment/features/auth/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/mock_data/mock_data.dart';

class MockUserRepo extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late UserRepository userRepo;

  final List<User> users = MockDataUser.allUsers;
  const User adminUser = MockDataUser.adminUser;

  const String invalidAccountError = 'invalid-account';
  const String incorrectAccountError = 'incorrect-account';

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    userRepo = MockUserRepo();

    when(() => userRepo.getUsers()).thenAnswer(
      (_) async => users,
    );

    when(() => userRepo.setUser(adminUser)).thenAnswer(
      (_) async => Future.value(),
    );

    when(() => userRepo.getUser()).thenAnswer(
      (_) async => adminUser,
    );

    when(() => userRepo.clearStorage()).thenAnswer(
      (_) async => Future.value(),
    );
  });

  group('test auth bloc: login', () {
    blocTest<AuthBloc, AuthState>(
      'error when phone number is empty',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '',
          password: '123456',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure(invalidAccountError),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'error when phone number is not a number',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: 'test_phone',
          password: '123456',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure(invalidAccountError),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'error when phone number is longer than 10 digits',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905123456789',
          password: '123456',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure(invalidAccountError),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'error when phone number is shorter than 10 digits',
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
        const LoginFailure(invalidAccountError),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'error when password is empty',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: '',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure(invalidAccountError),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'error when password is shorter than 8 characters',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: '123',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure(invalidAccountError),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'error when password has no Uppercase character',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: 'qwe123!@#',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure(invalidAccountError),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'error when password has no lowercase character',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: 'QWE123!@#',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure(invalidAccountError),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'error when password has no numeric character',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: 'qweQWE!@#',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure(invalidAccountError),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'error when password has no special character',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: 'qwe123QWE',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure(invalidAccountError),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'error when phone number not exist',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905123456',
          password: '123456',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure(incorrectAccountError),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'error when password is incorrect',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: '123456abcd',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        const LoginFailure(incorrectAccountError),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'successful',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0794542105',
          password: 'qwQW12!@',
        ),
      ),
      expect: () => <AuthState>[
        LoginInProgress(),
        LoginSuccess(),
      ],
    );
  });

  group('test auth bloc: logout', () {
    blocTest<AuthBloc, AuthState>(
      'successful',
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

  group('test auth bloc: user load', () {
    blocTest<AuthBloc, AuthState>(
      'successful',
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const UserLoad(),
      ),
      expect: () => <AuthState>[
        UserLoadSuccess(
          adminUser.name,
          adminUser.avatar,
        ),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'failure',
      setUp: () async {
        when(() => userRepo.getUser()).thenThrow(
          Exception('User not found.'),
        );
      },
      build: () => AuthBloc(userRepo),
      act: (bloc) => bloc.add(
        const UserLoad(),
      ),
      expect: () => <AuthState>[
        const UserLoadFailure(
          error: 'User not found.',
        ),
      ],
    );
  });
}
