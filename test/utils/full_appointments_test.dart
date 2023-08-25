import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/features/appointments/appointment_utils.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';

void main() {
  group('test full appointments -', () {
    late List<Appointment> appointments;

    setUpAll(() {
      return appointments = [
        {
          'date': '2023-07-20T17:01:05.738070',
          'startTime': '2023-07-20T18:00:00.000',
          'endTime': '2023-07-20T18:30:00.000',
          'userId': '2',
          'services': 'Neck & Shoulders',
          'description': 'Nothing to write.',
          'isCompleted': false,
          'id': '1'
        },
        {
          'date': '2023-07-20T00:00:00.000',
          'startTime': '2023-07-20T18:15:00.000',
          'endTime': '2023-07-20T18:45:00.000',
          'userId': '1',
          'services': 'Non-Invasive Body Contouring',
          'description': 'Nothing to write.',
          'isCompleted': false,
          'id': '2'
        },
        {
          'date': '2023-07-20T00:00:00.000',
          'startTime': '2023-07-20T18:05:00.000',
          'endTime': '2023-07-20T18:35:00.000',
          'userId': '1',
          'services': 'Non-Invasive Body Contouring',
          'description': 'Nothing to write.',
          'isCompleted': false,
          'id': '3'
        },
        {
          'date': '2023-07-20T00:00:00.000',
          'startTime': '2023-07-20T18:00:00.000',
          'endTime': '2023-07-20T18:30:00.000',
          'userId': '1',
          'services': 'Non-Invasive Body Contouring',
          'description': 'Nothing to write.',
          'isCompleted': false,
          'id': '4'
        },
        {
          'date': '2023-07-20T00:00:00.000',
          'startTime': '2023-07-20T18:20:00.000',
          'endTime': '2023-07-20T18:50:00.000',
          'userId': '1',
          'services': 'Back',
          'description': 'Nothing to write.',
          'isCompleted': false,
          'id': '5'
        },
        {
          'date': '2023-07-19T00:00:00.000',
          'startTime': '2023-07-19T18:00:00.000',
          'endTime': '2023-07-19T18:30:00.000',
          'userId': '1',
          'services': 'Non-Invasive Body Contouring',
          'description': 'Nothing to write.',
          'isCompleted': false,
          'id': '6'
        },
        {
          'date': '2023-07-19T00:00:00.000',
          'startTime': '2023-07-19T18:00:00.000',
          'endTime': '2023-07-19T18:30:00.000',
          'userId': '1',
          'services': 'Non-Invasive Body Contouring',
          'description': 'Nothing to write.',
          'isCompleted': false,
          'id': '7'
        },
        {
          'date': '2023-07-19T00:00:00.000',
          'startTime': '2023-07-19T18:00:00.000',
          'endTime': '2023-07-19T18:30:00.000',
          'userId': '1',
          'services': 'Non-Invasive Body Contouring',
          'description': 'Nothing to write.',
          'isCompleted': false,
          'id': '8'
        },
        {
          'date': '2023-07-19T00:00:00.000',
          'startTime': '2023-07-19T18:00:00.000',
          'endTime': '2023-07-19T18:30:00.000',
          'userId': '1',
          'services': 'Back',
          'description': 'Nothing to write.',
          'isCompleted': false,
          'id': '9'
        }
      ].map((e) => Appointment.fromJson(e)).toList();
    });

    tearDownAll(() => appointments = []);

    test('there are less than 5 appointments at the time then return false',
        () {
      final DateTime startTime = DateTime(2023, 7, 19, 18, 0);
      final DateTime endTime = DateTime(2023, 7, 19, 18, 30);

      expect(isFullAppointments(appointments, startTime, endTime), false);
    });

    test('there are 5 or more appointments at the time then return true', () {
      final DateTime startTime = DateTime(2023, 7, 20, 18, 0);
      final DateTime endTime = DateTime(2023, 7, 20, 18, 30);

      expect(isFullAppointments(appointments, startTime, endTime), true);
    });
  });
}
