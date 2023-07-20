import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/utils.dart';

void main() {
  group('test end time difference from start time -', () {
    late DateTime startTime;

    setUpAll(() => startTime = DateTime(2023, 7, 20, 17, 0));

    test('end time is before start time then return false', () {
      final DateTime endTime = DateTime(2023, 7, 20, 16, 59);

      expect(isAfterStartTime(startTime, endTime), false);
    });

    test('end time equals start time then return false', () {
      final DateTime endTime = DateTime(2023, 7, 20, 17, 0);

      expect(isAfterStartTime(startTime, endTime), false);
    });

    test('end time is after start time 1 minutes then return false', () {
      final DateTime endTime = DateTime(2023, 7, 20, 17, 1);

      expect(isAfterStartTime(startTime, endTime), false);
    });

    test('end time is after start time 29 minutes then return false', () {
      final DateTime endTime = DateTime(2023, 7, 20, 17, 29);

      expect(isAfterStartTime(startTime, endTime), false);
    });

    test('end time is after start time 30 minutes then return true', () {
      final DateTime endTime = DateTime(2023, 7, 20, 17, 30);

      expect(isAfterStartTime(startTime, endTime), true);
    });

    test('end time is after start time more than 30 minutes then return true',
        () {
      final DateTime endTime = DateTime(2023, 7, 20, 17, 31);

      expect(isAfterStartTime(startTime, endTime), true);
    });
  });
}
