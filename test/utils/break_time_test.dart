import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/utils/common.dart';

void main() {
  group('test conflict break time -', () {
    test('time is before 12:00 PM then return false', () {
      final time = DateTime(2023, 7, 19, 11, 59);

      expect(isBreakTime(time), false);
    });

    test('time is 12:00 PM then return false', () {
      final time = DateTime(2023, 7, 19, 12, 00);

      expect(isBreakTime(time), true);
    });

    test('time is after 12:00 PM then return true', () {
      final time = DateTime(2023, 7, 19, 12, 1);

      expect(isBreakTime(time), true);
    });

    test('time is before 3:20 PM then return true', () {
      final time = DateTime(2023, 7, 19, 15, 7);

      expect(isBreakTime(time), true);
    });

    test('time is 3:20 PM then return true', () {
      final time = DateTime(2023, 7, 19, 15, 20);

      expect(isBreakTime(time), false);
    });

    test('time is after 3:20 PM then return false', () {
      final time = DateTime(2023, 7, 19, 15, 21);

      expect(isBreakTime(time), false);
    });
  });
}
