import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/core/utils/common.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';

void main() {
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
        'startTime': '2023-07-20T08:00:00.000',
        'endTime': '2023-07-20T08:30:00.000',
        'userId': '1',
        'services': 'Non-Invasive Body Contouring',
        'description': 'Nothing to write.',
        'isCompleted': false,
        'id': '2'
      },
      {
        'date': '2023-07-20T00:00:00.000',
        'startTime': '2023-07-20T16:00:00.000',
        'endTime': '2023-07-20T16:30:00.000',
        'userId': '1',
        'services': 'Non-Invasive Body Contouring',
        'description': 'Nothing to write.',
        'isCompleted': false,
        'id': '3'
      },
      {
        'date': '2023-07-20T00:00:00.000',
        'startTime': '2023-07-20T10:00:00.000',
        'endTime': '2023-07-20T10:30:00.000',
        'userId': '1',
        'services': 'Non-Invasive Body Contouring',
        'description': 'Nothing to write.',
        'isCompleted': false,
        'id': '4'
      },
      {
        'date': '2023-07-20T00:00:00.000',
        'startTime': '2023-07-20T20:00:00.000',
        'endTime': '2023-07-20T20:30:00.000',
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
        'startTime': '2023-07-19T11:00:00.000',
        'endTime': '2023-07-19T11:30:00.000',
        'userId': '1',
        'services': 'Non-Invasive Body Contouring',
        'description': 'Nothing to write.',
        'isCompleted': false,
        'id': '7'
      },
      {
        'date': '2023-07-19T00:00:00.000',
        'startTime': '2023-07-19T16:00:00.000',
        'endTime': '2023-07-19T16:30:00.000',
        'userId': '1',
        'services': 'Non-Invasive Body Contouring',
        'description': 'Nothing to write.',
        'isCompleted': false,
        'id': '8'
      },
      {
        'date': '2023-07-19T00:00:00.000',
        'startTime': '2023-07-19T21:00:00.000',
        'endTime': '2023-07-19T21:30:00.000',
        'userId': '1',
        'services': 'Back',
        'description': 'Nothing to write.',
        'isCompleted': false,
        'id': '9'
      }
    ].map((e) => Appointment.fromJson(e)).toList();
  });

  tearDownAll(() => appointments = []);

  test(
      'date input is July 19th 2023 then return a sorted list of appointments on date',
      () {
    final expected = [
      {
        'date': '2023-07-19T00:00:00.000',
        'startTime': '2023-07-19T11:00:00.000',
        'endTime': '2023-07-19T11:30:00.000',
        'userId': '1',
        'services': 'Non-Invasive Body Contouring',
        'description': 'Nothing to write.',
        'isCompleted': false,
        'id': '7'
      },
      {
        'date': '2023-07-19T00:00:00.000',
        'startTime': '2023-07-19T16:00:00.000',
        'endTime': '2023-07-19T16:30:00.000',
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
        'services': 'Non-Invasive Body Contouring',
        'description': 'Nothing to write.',
        'isCompleted': false,
        'id': '6'
      },
      {
        'date': '2023-07-19T00:00:00.000',
        'startTime': '2023-07-19T21:00:00.000',
        'endTime': '2023-07-19T21:30:00.000',
        'userId': '1',
        'services': 'Back',
        'description': 'Nothing to write.',
        'isCompleted': false,
        'id': '9'
      }
    ];

    final DateTime date = DateTime(2023, 7, 19);

    final actual = groupByDate(appointments, date).map(
      (e) => e.toJson(),
    );

    expect(actual, expected);
  });

  test(
      'date input is July 20th 2023 then return a sorted list of appointments on date',
      () {
    final expected = [
      {
        'date': '2023-07-20T00:00:00.000',
        'startTime': '2023-07-20T08:00:00.000',
        'endTime': '2023-07-20T08:30:00.000',
        'userId': '1',
        'services': 'Non-Invasive Body Contouring',
        'description': 'Nothing to write.',
        'isCompleted': false,
        'id': '2'
      },
      {
        'date': '2023-07-20T00:00:00.000',
        'startTime': '2023-07-20T10:00:00.000',
        'endTime': '2023-07-20T10:30:00.000',
        'userId': '1',
        'services': 'Non-Invasive Body Contouring',
        'description': 'Nothing to write.',
        'isCompleted': false,
        'id': '4'
      },
      {
        'date': '2023-07-20T00:00:00.000',
        'startTime': '2023-07-20T16:00:00.000',
        'endTime': '2023-07-20T16:30:00.000',
        'userId': '1',
        'services': 'Non-Invasive Body Contouring',
        'description': 'Nothing to write.',
        'isCompleted': false,
        'id': '3'
      },
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
        'startTime': '2023-07-20T20:00:00.000',
        'endTime': '2023-07-20T20:30:00.000',
        'userId': '1',
        'services': 'Back',
        'description': 'Nothing to write.',
        'isCompleted': false,
        'id': '5'
      },
    ];

    final DateTime date = DateTime(2023, 7, 20);

    final actual = groupByDate(appointments, date).map(
      (e) => e.toJson(),
    );

    expect(actual, expected);
  });
}
