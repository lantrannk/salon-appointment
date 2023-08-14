import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/api/appointment_api.dart';

import '../mock_data/mock_data.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  final headers = {'Content-Type': 'application/json'};
  final url = Uri.parse(
    'https://63ab8e97fdc006ba60609b9b.mockapi.io/appointments',
  );

  late http.Client client;
  late AppointmentApi appointmentApi;

  setUp(() {
    client = MockClient();
    appointmentApi = AppointmentApi(client);
  });

  group('test appointment api get request -', () {
    test(
      'get appointments then return a encoded string of appointments list',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(url),
        ).thenAnswer(
          (_) async => http.Response(
            MockDataAppointment.allAppointmentsJson,
            200,
            headers: headers,
          ),
        );

        expect(
          await appointmentApi.getAppointments(),
          MockDataAppointment.allAppointmentsJson,
        );
      },
    );

    test(
      'get appointments error 304',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(url),
        ).thenAnswer(
          (_) async => http.Response(
            'Not Modified',
            304,
            headers: headers,
          ),
        );

        expect(
          await appointmentApi.getAppointments(),
          'Not Modified',
        );
      },
    );

    test(
      'get appointments error 400',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(url),
        ).thenAnswer(
          (_) async => http.Response(
            'Bad Request',
            400,
            headers: headers,
          ),
        );

        expect(
          await appointmentApi.getAppointments(),
          'Bad Request',
        );
      },
    );

    test(
      'get appointments error 404',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(url),
        ).thenAnswer(
          (_) async => http.Response(
            'Not Found',
            404,
            headers: headers,
          ),
        );

        expect(
          await appointmentApi.getAppointments(),
          'Not Found',
        );
      },
    );

    test(
      'get appointments error 504',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(url),
        ).thenAnswer(
          (_) async => http.Response(
            'Gateway Timeout',
            504,
            headers: headers,
          ),
        );

        expect(
          await appointmentApi.getAppointments(),
          'Gateway Timeout',
        );
      },
    );
  });

  // group('test appointment api post request -', () {
  //   test(
  //     'add appointments success',
  //     timeout: const Timeout(Duration(seconds: 5)),
  //     () async {
  //       when(
  //         () => client.post(
  //           url,
  //           body: MockDataAppointment.appointmentJson,
  //           headers: headers,
  //         ),
  //       ).thenAnswer(
  //         (_) async => http.Response(
  //           MockDataAppointment.appointmentJson,
  //           200,
  //           headers: headers,
  //         ),
  //       );

  //       expect(
  //         await appointmentApi.addAppointment(MockDataAppointment.appointment),
  //         MockDataAppointment.appointmentJson,
  //       );
  //     },
  //   );
  // });
}
