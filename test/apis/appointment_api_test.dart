import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/api/appointment_api.dart';

import '../expect_data/expect_data.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('test appointment api -', () {
    test(
      'get appointments then return a encoded string of appointments list',
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
            ExpectData.appointmentsStr,
            200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
            },
          ),
        );

        expect(
          await appointmentApi.getAppointments(client),
          ExpectData.appointmentsStr,
        );
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
