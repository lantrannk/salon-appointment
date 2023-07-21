import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/validations/validations.dart';
import 'package:salon_appointment/features/auth/api/user_api.dart';
import 'package:salon_appointment/features/auth/model/user.dart';

class MockUser extends Mock implements UserApi {}

void main() {
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
        'Phone number must have 10 digits.',
      );
    });

    test('phone number has greater than 10 digits then return an error string',
        () {
      const String phoneNumber = '01234567890';

      expect(
        FormValidation.isValidPhoneNumber(phoneNumber),
        'Phone number must have 10 digits.',
      );
    });

    test('phone number is not a string of digits then return an error string',
        () {
      const String phoneNumber = '415465463s';

      expect(
        FormValidation.isValidPhoneNumber(phoneNumber),
        'Phone number must be a string of digits.',
      );
    });

    test('password is blank then return an error string', () {
      const String password = '';

      expect(
        FormValidation.isValidPassword(password),
        'Password is blank.',
      );
    });

    test('password has less than 6 digits then return an error string', () {
      const String password = '12345';

      expect(
        FormValidation.isValidPassword(password),
        'Password must be at least 6 characters.',
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
      const String password = '123456';

      expect(
        FormValidation.isValidPassword(password),
        null,
      );
    });
  });

  group('test user login -', () {
    late List<User> users;

    setUpAll(() {
      users = [
        User(
          id: '1',
          name: 'Lan Tran',
          phoneNumber: '0794542105',
          avatar:
              'https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg',
          password: '123456',
          isAdmin: true,
        ),
        User(
          id: '2',
          name: 'Carol Williams',
          phoneNumber: '0905999222',
          avatar:
              'https://assets.vogue.in/photos/611cf20c8733032148fe1b06/2:3/w_2560%2Cc_limit/Slide%25201.jpg',
          password: '123456',
          isAdmin: false,
        ),
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
      const String password = '123456';

      expect(
        FormValidation.isLoginSuccess(users, phoneNumber, password),
        true,
      );
    });
  });
}
