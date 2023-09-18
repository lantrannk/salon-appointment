import 'package:salon_appointment/features/appointments/model/appointment.dart';

class MockDataAppointment {
  static const String allAppointmentsJson =
      '[{"date":"2023-05-12T00:00:00.000","startTime":"2023-05-12T18:00:00.000","endTime":"2023-05-12T18:30:00.000","userId":"2","services":"Neck & Shoulders","description":"Nothing to write.","isCompleted":false,"id":"7"},{"date":"2023-05-23T00:00:00.000","startTime":"2023-05-23T16:35:00.000","endTime":"2023-05-23T17:05:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"6"},{"date":"2023-05-23T00:00:00.000","startTime":"2023-05-23T18:00:00.000","endTime":"2023-05-23T18:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"7"},{"date":"2023-05-22T18:03:33.900524","startTime":"2023-05-22T20:03:00.000","endTime":"2023-05-22T20:33:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"9"},{"date":"2023-05-24T00:00:00.000","startTime":"2023-05-24T18:19:00.000","endTime":"2023-05-24T18:49:00.000","userId":"1","services":"Back","description":"Nothing to write.","isCompleted":false,"id":"12"},{"date":"2023-05-24T00:00:00.000","startTime":"2023-05-24T18:30:00.000","endTime":"2023-05-24T19:00:00.000","userId":"1","services":"Neck & Shoulders","description":"Nothing to write.","isCompleted":false,"id":"20"},{"date":"2023-06-29T00:00:00.000","startTime":"2023-06-29T11:00:00.000","endTime":"2023-06-29T11:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"25"},{"date":"2023-06-23T17:44:05.534356","startTime":"2023-06-23T18:00:00.000","endTime":"2023-06-23T18:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"32"},{"date":"2023-07-01T00:00:00.000","startTime":"2023-07-01T09:45:00.000","endTime":"2023-07-01T10:15:00.000","userId":"1","services":"Back","description":"There is a distinction between a beauty salon and a hair salon and although many small businesses do offer both sets of treatments.","isCompleted":false,"id":"57"},{"date":"2023-07-02T00:00:00.000","startTime":"2023-07-02T16:00:00.000","endTime":"2023-07-02T16:30:00.000","userId":"1","services":"Neck & Shoulders","description":"Nothing to write.","isCompleted":false,"id":"60"},{"date":"2023-07-03T00:00:00.000","startTime":"2023-07-03T20:00:00.000","endTime":"2023-07-03T20:30:00.000","userId":"2","services":"Neck & Shoulders","description":"Nothing to write.","isCompleted":false,"id":"63"},{"date":"2023-07-03T11:48:00.000","startTime":"2023-07-03T09:30:00.000","endTime":"2023-07-03T10:00:00.000","userId":"2","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"64"},{"date":"2023-06-28T17:55:00.000","startTime":"2023-06-28T20:30:00.000","endTime":"2023-06-28T21:00:00.000","userId":"1","services":"Back","description":"There is a distinction between a beauty salon and a hair salon and although many small businesses do offer both sets of treatments.","isCompleted":false,"id":"66"},{"date":"2023-06-30T00:00:00.000","startTime":"2023-06-30T11:00:00.000","endTime":"2023-06-30T11:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"67"},{"date":"2023-06-30T11:29:00.000","startTime":"2023-06-30T11:30:00.000","endTime":"2023-06-30T12:00:00.000","userId":"1","services":"Neck & Shoulders","description":"Nothing to write.","isCompleted":false,"id":"68"},{"date":"2023-06-30T00:00:00.000","startTime":"2023-06-30T20:00:00.000","endTime":"2023-06-30T20:30:00.000","userId":"1","services":"Back","description":"Test BLoC","isCompleted":false,"id":"69"},{"date":"2023-06-29T17:29:00.000","startTime":"2023-06-29T18:00:00.000","endTime":"2023-06-29T18:30:00.000","userId":"1","services":"Back","description":"Nothing to write.","isCompleted":false,"id":"70"},{"date":"2023-07-11T00:00:00.000","startTime":"2023-07-11T09:00:00.000","endTime":"2023-07-11T09:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"There is a distinction between a beauty salon and a hair salon and although many small businesses do offer both sets of treatments.","isCompleted":false,"id":"72"},{"date":"2023-07-08T00:00:00.000","startTime":"2023-07-08T08:30:00.000","endTime":"2023-07-08T09:00:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"74"},{"date":"2023-07-07T00:00:00.000","startTime":"2023-07-07T08:42:00.000","endTime":"2023-07-07T09:12:00.000","userId":"1","services":"Back","description":"Nothing to write.","isCompleted":false,"id":"75"},{"date":"2023-07-07T08:43:00.000","startTime":"2023-07-07T18:00:00.000","endTime":"2023-07-07T18:30:00.000","userId":"1","services":"Back","description":"Nothing to write.","isCompleted":false,"id":"76"},{"date":"2023-07-21T10:55:00.000","startTime":"2023-07-21T18:00:00.000","endTime":"2023-07-21T18:30:00.000","userId":"2","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"78"},{"date":"2023-08-15T10:55:00.000","startTime":"2023-08-15T18:00:00.000","endTime":"2023-08-15T18:30:00.000","userId":"2","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"79"},{"date":"2023-08-15T10:55:00.000","startTime":"2023-08-15T20:00:00.000","endTime":"2023-08-15T20:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"80"},{"date":"2023-08-15T10:55:00.000","startTime":"2023-08-15T19:00:00.000","endTime":"2023-08-15T19:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"82"},{"date":"2023-08-15T10:55:00.000","startTime":"2023-08-15T19:00:00.000","endTime":"2023-08-15T19:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"83"}]';

  static const String appointmentJson =
      '{"date":"2023-08-15T10:55:00.000","startTime":"2023-08-15T10:00:00.000","endTime":"2023-08-15T10:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"84"}';

  static const appointmentToJson = {
    'date': '2023-08-15T10:55:00.000',
    'startTime': '2023-08-15T10:00:00.000',
    'endTime': '2023-08-15T10:30:00.000',
    'userId': '1',
    'services': 'Non-Invasive Body Contouring',
    'description': 'Nothing to write.',
    'isCompleted': false,
    'id': '84'
  };

  static final appointment = Appointment(
    date: DateTime(2023, 8, 15, 10, 55),
    startTime: DateTime(2023, 8, 15, 10, 0),
    endTime: DateTime(2023, 8, 15, 10, 30),
    userId: '1',
    services: 'Non-Invasive Body Contouring',
    description: 'Nothing to write.',
    isCompleted: false,
    id: '84',
  );

  static final appointmentAfterNow = Appointment(
    date: DateTime(2023, 10, 15, 10, 55),
    startTime: DateTime(2023, 10, 15, 20, 0),
    endTime: DateTime(2023, 10, 15, 20, 30),
    userId: '1',
    services: 'Non-Invasive Body Contouring',
    description: 'Nothing to write.',
    isCompleted: false,
    id: '80',
  );

  static final List<Appointment> allAppointments = [
    {
      'date': '2023-05-12T00:00:00.000',
      'startTime': '2023-05-12T18:00:00.000',
      'endTime': '2023-05-12T18:30:00.000',
      'userId': '2',
      'services': 'Neck & Shoulders',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '7'
    },
    {
      'date': '2023-05-23T00:00:00.000',
      'startTime': '2023-05-23T16:35:00.000',
      'endTime': '2023-05-23T17:05:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '6'
    },
    {
      'date': '2023-05-23T00:00:00.000',
      'startTime': '2023-05-23T18:00:00.000',
      'endTime': '2023-05-23T18:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '7'
    },
    {
      'date': '2023-05-22T18:03:33.900524',
      'startTime': '2023-05-22T20:03:00.000',
      'endTime': '2023-05-22T20:33:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '9'
    },
    {
      'date': '2023-05-24T00:00:00.000',
      'startTime': '2023-05-24T18:19:00.000',
      'endTime': '2023-05-24T18:49:00.000',
      'userId': '1',
      'services': 'Back',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '12'
    },
    {
      'date': '2023-05-24T00:00:00.000',
      'startTime': '2023-05-24T18:30:00.000',
      'endTime': '2023-05-24T19:00:00.000',
      'userId': '1',
      'services': 'Neck & Shoulders',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '20'
    },
    {
      'date': '2023-06-29T00:00:00.000',
      'startTime': '2023-06-29T11:00:00.000',
      'endTime': '2023-06-29T11:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '25'
    },
    {
      'date': '2023-06-23T17:44:05.534356',
      'startTime': '2023-06-23T18:00:00.000',
      'endTime': '2023-06-23T18:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '32'
    },
    {
      'date': '2023-07-01T00:00:00.000',
      'startTime': '2023-07-01T09:45:00.000',
      'endTime': '2023-07-01T10:15:00.000',
      'userId': '1',
      'services': 'Back',
      'description':
          'There is a distinction between a beauty salon and a hair salon and although many small businesses do offer both sets of treatments.',
      'isCompleted': false,
      'id': '57'
    },
    {
      'date': '2023-07-02T00:00:00.000',
      'startTime': '2023-07-02T16:00:00.000',
      'endTime': '2023-07-02T16:30:00.000',
      'userId': '1',
      'services': 'Neck & Shoulders',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '60'
    },
    {
      'date': '2023-07-03T00:00:00.000',
      'startTime': '2023-07-03T20:00:00.000',
      'endTime': '2023-07-03T20:30:00.000',
      'userId': '2',
      'services': 'Neck & Shoulders',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '63'
    },
    {
      'date': '2023-07-03T11:48:00.000',
      'startTime': '2023-07-03T09:30:00.000',
      'endTime': '2023-07-03T10:00:00.000',
      'userId': '2',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '64'
    },
    {
      'date': '2023-06-28T17:55:00.000',
      'startTime': '2023-06-28T20:30:00.000',
      'endTime': '2023-06-28T21:00:00.000',
      'userId': '1',
      'services': 'Back',
      'description':
          'There is a distinction between a beauty salon and a hair salon and although many small businesses do offer both sets of treatments.',
      'isCompleted': false,
      'id': '66'
    },
    {
      'date': '2023-06-30T00:00:00.000',
      'startTime': '2023-06-30T11:00:00.000',
      'endTime': '2023-06-30T11:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '67'
    },
    {
      'date': '2023-06-30T11:29:00.000',
      'startTime': '2023-06-30T11:30:00.000',
      'endTime': '2023-06-30T12:00:00.000',
      'userId': '1',
      'services': 'Neck & Shoulders',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '68'
    },
    {
      'date': '2023-06-30T00:00:00.000',
      'startTime': '2023-06-30T20:00:00.000',
      'endTime': '2023-06-30T20:30:00.000',
      'userId': '1',
      'services': 'Back',
      'description': 'Test BLoC',
      'isCompleted': false,
      'id': '69'
    },
    {
      'date': '2023-06-29T17:29:00.000',
      'startTime': '2023-06-29T18:00:00.000',
      'endTime': '2023-06-29T18:30:00.000',
      'userId': '1',
      'services': 'Back',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '70'
    },
    {
      'date': '2023-07-11T00:00:00.000',
      'startTime': '2023-07-11T09:00:00.000',
      'endTime': '2023-07-11T09:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description':
          'There is a distinction between a beauty salon and a hair salon and although many small businesses do offer both sets of treatments.',
      'isCompleted': false,
      'id': '72'
    },
    {
      'date': '2023-07-08T00:00:00.000',
      'startTime': '2023-07-08T08:30:00.000',
      'endTime': '2023-07-08T09:00:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '74'
    },
    {
      'date': '2023-07-07T00:00:00.000',
      'startTime': '2023-07-07T08:42:00.000',
      'endTime': '2023-07-07T09:12:00.000',
      'userId': '1',
      'services': 'Back',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '75'
    },
    {
      'date': '2023-07-07T08:43:00.000',
      'startTime': '2023-07-07T18:00:00.000',
      'endTime': '2023-07-07T18:30:00.000',
      'userId': '1',
      'services': 'Back',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '76'
    },
    {
      'date': '2023-07-21T10:55:00.000',
      'startTime': '2023-07-21T18:00:00.000',
      'endTime': '2023-07-21T18:30:00.000',
      'userId': '2',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '78'
    },
    {
      'date': '2023-08-15T10:55:00.000',
      'startTime': '2023-08-15T18:00:00.000',
      'endTime': '2023-08-15T18:30:00.000',
      'userId': '2',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '79'
    },
    {
      'date': '2023-08-15T10:55:00.000',
      'startTime': '2023-08-15T20:00:00.000',
      'endTime': '2023-08-15T20:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '80'
    },
    {
      'date': '2023-08-15T10:55:00.000',
      'startTime': '2023-08-15T19:00:00.000',
      'endTime': '2023-08-15T19:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '82'
    },
    {
      'date': '2023-08-15T10:55:00.000',
      'startTime': '2023-08-15T19:00:00.000',
      'endTime': '2023-08-15T19:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '83'
    }
  ].map((e) => Appointment.fromJson(e)).toList();

  static final List<Appointment> appointmentsOfUser = [
    {
      'date': '2023-05-12T00:00:00.000',
      'startTime': '2023-05-12T18:00:00.000',
      'endTime': '2023-05-12T18:30:00.000',
      'userId': '2',
      'services': 'Neck & Shoulders',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '7'
    },
    {
      'date': '2023-07-03T00:00:00.000',
      'startTime': '2023-07-03T20:00:00.000',
      'endTime': '2023-07-03T20:30:00.000',
      'userId': '2',
      'services': 'Neck & Shoulders',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '63'
    },
    {
      'date': '2023-07-03T11:48:00.000',
      'startTime': '2023-07-03T09:30:00.000',
      'endTime': '2023-07-03T10:00:00.000',
      'userId': '2',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '64'
    },
    {
      'date': '2023-07-21T10:55:00.000',
      'startTime': '2023-07-21T18:00:00.000',
      'endTime': '2023-07-21T18:30:00.000',
      'userId': '2',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '78'
    },
    {
      'date': '2023-08-15T10:55:00.000',
      'startTime': '2023-08-15T18:00:00.000',
      'endTime': '2023-08-15T18:30:00.000',
      'userId': '2',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '79'
    },
  ].map((e) => Appointment.fromJson(e)).toList();

  static final List<Appointment> sortedAppointmentsOfDay = [
    {
      'date': '2023-08-15T10:55:00.000',
      'startTime': '2023-08-15T18:00:00.000',
      'endTime': '2023-08-15T18:30:00.000',
      'userId': '2',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '79'
    },
    {
      'date': '2023-08-15T10:55:00.000',
      'startTime': '2023-08-15T19:00:00.000',
      'endTime': '2023-08-15T19:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '82'
    },
    {
      'date': '2023-08-15T10:55:00.000',
      'startTime': '2023-08-15T19:00:00.000',
      'endTime': '2023-08-15T19:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '83'
    },
    {
      'date': '2023-08-15T10:55:00.000',
      'startTime': '2023-08-15T20:00:00.000',
      'endTime': '2023-08-15T20:30:00.000',
      'userId': '1',
      'services': 'Non-Invasive Body Contouring',
      'description': 'Nothing to write.',
      'isCompleted': false,
      'id': '80'
    },
  ].map((e) => Appointment.fromJson(e)).toList();

  static final List<Appointment> fullAppointments = [
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
}
