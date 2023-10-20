import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/utils/common.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';

import '../../constants/mock_data/mock_data.dart';

void main() {
  group('test full appointments -', () {
    late List<Appointment> appointments;

    setUpAll(() {
      appointments = MockDataAppointment.allAppointments;
    });

    tearDownAll(() => appointments = []);

    test('there are less than 5 appointments at the time then return false',
        () {
      final DateTime startTime = DateTime(2023, 7, 19, 18, 0);
      final DateTime endTime = DateTime(2023, 7, 19, 18, 30);

      expect(isFullAppointments(appointments, startTime, endTime), false);
    });

    test('there are 5 or more appointments at the time then return true', () {
      final DateTime startTime = DateTime(2023, 8, 15, 19, 0);
      final DateTime endTime = DateTime(2023, 8, 15, 19, 30);

      expect(isFullAppointments(appointments, startTime, endTime), true);
    });
  });
}
