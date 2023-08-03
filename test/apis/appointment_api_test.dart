import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/api/appointment_api.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('test appointment api -', () {
    test(
      'get appointments then return a encoded string of appointments list',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        final client = MockClient();
        final appointmentApi = AppointmentApi();
        const expectedData =
            '[{"date":"2023-05-12T00:00:00.000","startTime":"2023-05-12T18:00:00.000","endTime":"2023-05-12T18:30:00.000","userId":"2","services":"Neck & Shoulders","description":"Nothing to write.","isCompleted":false,"id":"7"},{"date":"2023-05-23T00:00:00.000","startTime":"2023-05-23T16:35:00.000","endTime":"2023-05-23T17:05:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"6"},{"date":"2023-05-23T00:00:00.000","startTime":"2023-05-23T18:00:00.000","endTime":"2023-05-23T18:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"7"},{"date":"2023-05-22T18:03:33.900524","startTime":"2023-05-22T20:03:00.000","endTime":"2023-05-22T20:33:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"9"},{"date":"2023-05-24T00:00:00.000","startTime":"2023-05-24T18:19:00.000","endTime":"2023-05-24T18:49:00.000","userId":"1","services":"Back","description":"Nothing to write.","isCompleted":false,"id":"12"},{"date":"2023-05-24T00:00:00.000","startTime":"2023-05-24T18:30:00.000","endTime":"2023-05-24T19:00:00.000","userId":"1","services":"Neck & Shoulders","description":"Nothing to write.","isCompleted":false,"id":"20"},{"date":"2023-06-29T00:00:00.000","startTime":"2023-06-29T11:00:00.000","endTime":"2023-06-29T11:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"25"},{"date":"2023-06-23T17:44:05.534356","startTime":"2023-06-23T18:00:00.000","endTime":"2023-06-23T18:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"32"},{"date":"2023-07-01T00:00:00.000","startTime":"2023-07-01T09:45:00.000","endTime":"2023-07-01T10:15:00.000","userId":"1","services":"Back","description":"There is a distinction between a beauty salon and a hair salon and although many small businesses do offer both sets of treatments; beauty salons provide extended services related to skin health, facial aesthetic, foot care, nail manicures, aromatherapy — even meditation, oxygen therapy, mud baths and many other services.","isCompleted":false,"id":"57"},{"date":"2023-07-02T00:00:00.000","startTime":"2023-07-02T16:00:00.000","endTime":"2023-07-02T16:30:00.000","userId":"1","services":"Neck & Shoulders","description":"Nothing to write.","isCompleted":false,"id":"60"},{"date":"2023-07-03T00:00:00.000","startTime":"2023-07-03T20:00:00.000","endTime":"2023-07-03T20:30:00.000","userId":"2","services":"Neck & Shoulders","description":"Nothing to write.","isCompleted":false,"id":"63"},{"date":"2023-07-03T11:48:00.000","startTime":"2023-07-03T09:30:00.000","endTime":"2023-07-03T10:00:00.000","userId":"2","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"64"},{"date":"2023-06-28T17:55:00.000","startTime":"2023-06-28T20:30:00.000","endTime":"2023-06-28T21:00:00.000","userId":"1","services":"Back","description":"There is a distinction between a beauty salon and a hair salon and although many small businesses do offer both sets of treatments; beauty salons provide extended services related to skin health, facial aesthetic, foot care, nail manicures, aromatherapy — even meditation, oxygen therapy, mud baths and many other services.","isCompleted":false,"id":"66"},{"date":"2023-06-30T00:00:00.000","startTime":"2023-06-30T11:00:00.000","endTime":"2023-06-30T11:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"67"},{"date":"2023-06-30T11:29:00.000","startTime":"2023-06-30T11:30:00.000","endTime":"2023-06-30T12:00:00.000","userId":"1","services":"Neck & Shoulders","description":"Nothing to write.","isCompleted":false,"id":"68"},{"date":"2023-06-30T00:00:00.000","startTime":"2023-06-30T20:00:00.000","endTime":"2023-06-30T20:30:00.000","userId":"1","services":"Back","description":"Test BLoC","isCompleted":false,"id":"69"},{"date":"2023-06-29T17:29:00.000","startTime":"2023-06-29T18:00:00.000","endTime":"2023-06-29T18:30:00.000","userId":"1","services":"Back","description":"Nothing to write.","isCompleted":false,"id":"70"},{"date":"2023-07-11T00:00:00.000","startTime":"2023-07-11T09:00:00.000","endTime":"2023-07-11T09:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"There is a distinction between a beauty salon and a hair salon and although many small businesses do offer both sets of treatments; beauty salons provide extended services related to skin health, facial aesthetic, foot care, nail manicures, aromatherapy — even meditation, oxygen therapy, mud baths and many other services.","isCompleted":false,"id":"72"},{"date":"2023-07-08T00:00:00.000","startTime":"2023-07-08T08:30:00.000","endTime":"2023-07-08T09:00:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"74"},{"date":"2023-07-07T00:00:00.000","startTime":"2023-07-07T08:42:00.000","endTime":"2023-07-07T09:12:00.000","userId":"1","services":"Back","description":"Nothing to write.","isCompleted":false,"id":"75"},{"date":"2023-07-07T08:43:00.000","startTime":"2023-07-07T18:00:00.000","endTime":"2023-07-07T18:30:00.000","userId":"1","services":"Back","description":"Nothing to write.","isCompleted":false,"id":"76"},{"date":"2023-07-21T10:55:00.000","startTime":"2023-07-21T18:00:00.000","endTime":"2023-07-21T18:30:00.000","userId":"2","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"78"},{"date":"2023-08-15T10:55:00.000","startTime":"2023-08-15T18:00:00.000","endTime":"2023-08-15T18:30:00.000","userId":"2","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"79"},{"date":"2023-08-15T10:55:00.000","startTime":"2023-08-15T20:00:00.000","endTime":"2023-08-15T20:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"80"},{"date":"2023-08-15T10:55:00.000","startTime":"2023-08-15T19:00:00.000","endTime":"2023-08-15T19:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"82"},{"date":"2023-08-15T10:55:00.000","startTime":"2023-08-15T19:00:00.000","endTime":"2023-08-15T19:30:00.000","userId":"1","services":"Non-Invasive Body Contouring","description":"Nothing to write.","isCompleted":false,"id":"83"}]';

        when(
          () => client.get(
            Uri.parse(
                'https://63ab8e97fdc006ba60609b9b.mockapi.io/appointments'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            expectedData,
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ),
        );

        expect(await appointmentApi.getAppointments(client), expectedData);
      },
    );

    test(
      'get appointments error',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        final client = MockClient();
        final appointmentApi = AppointmentApi();

        when(
          () => client.get(
            Uri.parse(
                'https://63ab8e97fdc006ba60609b9b.mockapi.io/appointments'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            'Not Found',
            404,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ),
        );

        expect(await appointmentApi.getAppointments(client), '');
      },
    );
  });
}
