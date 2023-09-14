import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/validations/validations.dart';
import 'package:salon_appointment/features/auth/api/user_api.dart';
import 'package:salon_appointment/features/auth/model/user.dart';

import '../constants/mock_data/mock_data.dart';

class MockUser extends Mock implements UserApi {}

void main() {
  const String phoneNumberErrorText = 'Invalid phone number.';
  const String passwordErrorText = 'Invalid password.';

  group('test form validations -', () {
    test('phone number is blank then return an error string', () {
      const String phoneNumber = '';

      expect(
        FormValidation.isValidPhoneNumber(phoneNumber),
        'Phone number is blank.',
      );
    });

    test('phone number has less than 10 digits then return an error string',
        () {
      const String phoneNumber = '123456789';

      expect(
        FormValidation.isValidPhoneNumber(phoneNumber),
        phoneNumberErrorText,
      );
    });

    test('phone number has greater than 10 digits then return an error string',
        () {
      const String phoneNumber = '01234567890';

      expect(
        FormValidation.isValidPhoneNumber(phoneNumber),
        phoneNumberErrorText,
      );
    });

    test(
        'phone number has special character (except +) then return an error string',
        () {
      const String phoneNumber = '0905-123-123';

      expect(
        FormValidation.isValidPhoneNumber(phoneNumber),
        phoneNumberErrorText,
      );
    });

    test('password is blank then return an error string', () {
      const String password = '';

      expect(
        FormValidation.isValidPassword(password),
        'Password is blank.',
      );
    });

    test('password has less than 8 digits then return an error string', () {
      const String password = '123456';

      expect(
        FormValidation.isValidPassword(password),
        passwordErrorText,
      );
    });

    test('password has no Uppercase then return an error string', () {
      const String password = 'qwe123!@#';

      expect(
        FormValidation.isValidPassword(password),
        passwordErrorText,
      );
    });

    test('password has no lowercase then return an error string', () {
      const String password = 'QWE123!@#';

      expect(
        FormValidation.isValidPassword(password),
        passwordErrorText,
      );
    });

    test('password has no numberic character then return an error string', () {
      const String password = 'QWEqwe!@#';

      expect(
        FormValidation.isValidPassword(password),
        passwordErrorText,
      );
    });

    test('password has no allow special character then return an error string',
        () {
      const String password = 'QWEqwe123';

      expect(
        FormValidation.isValidPassword(password),
        passwordErrorText,
      );
    });
  });

  group('test valid user info -', () {
    test('phone number is valid then return null', () {
      const String phoneNumber = '0905999222';

      expect(
        FormValidation.isValidPhoneNumber(phoneNumber),
        null,
      );
    });

    test('password is valid then return null', () {
      const String password = 'qwQW12!@';

      expect(
        FormValidation.isValidPassword(password),
        null,
      );
    });
  });

  group('test incorrect user login -', () {
    late List<User> users;

    setUpAll(() {
      users = [
        MockDataUser.adminUser,
        MockDataUser.customerUser,
      ];
    });

    tearDownAll(() => users = []);

    test('phone number not exist then return a boolean', () {
      const String phoneNumber = '0905123456';
      const String password = '123456';

      expect(
        FormValidation.isLoginSuccess(users, phoneNumber, password),
        false,
      );
    });

    test(
        'phone number exists but password is not correct then return a boolean',
        () {
      const String phoneNumber = '0905999222';
      const String password = 'testpassword';

      expect(
        FormValidation.isLoginSuccess(users, phoneNumber, password),
        false,
      );
    });

    test('phone number and password are correct then return a boolean', () {
      const String phoneNumber = '0905999222';
      const String password = 'qwQW12!@';

      expect(
        FormValidation.isLoginSuccess(users, phoneNumber, password),
        true,
      );
    });
  });
}
