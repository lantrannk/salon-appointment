import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/utils.dart';

void main() {
  group('test get range day of a week -', () {
    late DateTime dateTime;

    setUpAll(() => dateTime = DateTime(2023, 7, 20));

    test(
      'date is July 20th 2023 then return the first day of week is July 17th 2023',
      () {
        final DateTime expectedStartDay = DateTime(2023, 7, 17);

        expect(rangeStartDay(dateTime), expectedStartDay);
      },
    );

    test(
      'date is July 20th 2023 then return the last day of week is July 23rd 2023',
      () {
        final DateTime expectedEndDay = DateTime(2023, 7, 23);

        expect(rangeEndDay(dateTime), expectedEndDay);
      },
    );
  });
}
