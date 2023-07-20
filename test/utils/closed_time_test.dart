import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/utils.dart';

void main() {
  group('test conflict closed time -', () {
    test('time is before 10:00 PM then return false', () {
      final time = DateTime(2023, 7, 20, 21, 59);

      expect(isClosedTime(time), false);
    });

    test('time is 10:00 PM then return false', () {
      final time = DateTime(2023, 7, 20, 22, 0);

      expect(isClosedTime(time), false);
    });

    test('time is after 10:00 PM then return true', () {
      final time = DateTime(2023, 7, 20, 22, 1);

      expect(isClosedTime(time), true);
    });

    test('time is before 8:00 AM then return true', () {
      final time = DateTime(2023, 7, 20, 7, 59);

      expect(isClosedTime(time), true);
    });

    test('time is 8:00 AM then return false', () {
      final time = DateTime(2023, 7, 20, 8, 0);

      expect(isClosedTime(time), false);
    });

    test('time is after 8:00 AM then return false', () {
      final time = DateTime(2023, 7, 20, 8, 1);

      expect(isClosedTime(time), false);
    });
  });
}
