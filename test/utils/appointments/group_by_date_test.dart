import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/utils/common.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';

import '../../constants/mock_data/mock_data.dart';

void main() {
  late List<Appointment> appointments;
  late List<Appointment> appointmentsGroupByDate;

  setUpAll(() {
    appointments = MockDataAppointment.allAppointments;
    appointmentsGroupByDate = MockDataAppointment.sortedAppointmentsOfDay;
  });

  tearDownAll(() => appointments = []);

  test(
    'date input is August 15th 2023 then return a sorted list of appointments on date',
    () {
      final DateTime date = DateTime(2023, 8, 15);

      final List<Appointment> actual = groupByDate(appointments, date);

      expect(actual, appointmentsGroupByDate);
    },
  );
}
