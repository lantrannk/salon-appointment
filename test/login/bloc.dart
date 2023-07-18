import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/auth/bloc/auth_bloc.dart';

class MockAuthBloc extends Mock implements AuthBloc {}

void main() {
  group('test auth bloc -', () {
    blocTest<AuthBloc, AuthState>(
      'login successful',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: '123456',
        ),
      ),
      wait: const Duration(seconds: 3),
      expect: () => <AuthState>[
        LoginLoading(),
        LoginSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'login error',
      build: () => AuthBloc(),
      act: (bloc) => bloc.add(
        const LoginEvent(
          phoneNumber: '0905999222',
          password: '123456abcd',
        ),
      ),
      wait: const Duration(seconds: 3),
      expect: () => <AuthState>[
        LoginLoading(),
        const LoginError('invalid-account'),
      ],
    );
  });
}
