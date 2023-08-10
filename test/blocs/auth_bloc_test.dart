import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mock_data/mock_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  group('test auth bloc: login -', () {
    blocTest<AuthBloc, AuthState>(
      'login successful',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: '123456',
        ),
      ),
      wait: const Duration(seconds: 1),
      expect: () => <AuthState>[
        LoginLoading(),
        LoginSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when phone number is empty',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '',
          password: '123456',
        ),
      ),
      wait: const Duration(seconds: 1),
      expect: () => <AuthState>[
        LoginLoading(),
        const LoginError('invalid-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when phone number is not a number',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: 'test_phone',
          password: '123456',
        ),
      ),
      wait: const Duration(seconds: 1),
      expect: () => <AuthState>[
        LoginLoading(),
        const LoginError('invalid-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when phone number is longer than 10 digits',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905123456789',
          password: '123456',
        ),
      ),
      wait: const Duration(seconds: 1),
      expect: () => <AuthState>[
        LoginLoading(),
        const LoginError('invalid-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when phone number is shorter than 10 digits',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905123',
          password: '123456',
        ),
      ),
      wait: const Duration(seconds: 1),
      expect: () => <AuthState>[
        LoginLoading(),
        const LoginError('invalid-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when password is empty',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: '',
        ),
      ),
      wait: const Duration(seconds: 1),
      expect: () => <AuthState>[
        LoginLoading(),
        const LoginError('invalid-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when password is shorter than 6 characters',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: '123',
        ),
      ),
      wait: const Duration(seconds: 1),
      expect: () => <AuthState>[
        LoginLoading(),
        const LoginError('invalid-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when phone number not exist',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905123456',
          password: '123456',
        ),
      ),
      wait: const Duration(seconds: 1),
      expect: () => <AuthState>[
        LoginLoading(),
        const LoginError('incorrect-account'),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error when password is incorrect',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: '123456abcd',
        ),
      ),
      wait: const Duration(seconds: 1),
      expect: () => <AuthState>[
        LoginLoading(),
        const LoginError('incorrect-account'),
      ],
    );
  });

  group('test auth bloc: logout -', () {
    blocTest<AuthBloc, AuthState>(
      'logout successful',
      build: () => AuthBloc(),
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
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(
        const UserLoad(),
      ),
      setUp: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user', MockDataUser.adminUserJson);
      },
      expect: () => <AuthState>[
        UserLoaded(
          MockDataUser.adminUser.name,
          MockDataUser.adminUser.avatar,
        ),
      ],
    );
  });
}
