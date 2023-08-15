import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/api/appointment_api.dart';

import '../constants/api_error_message.dart';
import '../mock_data/mock_data.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  final headers = {'Content-Type': 'application/json'};
  final url = Uri.parse(
    'https://63ab8e97fdc006ba60609b9b.mockapi.io/appointments',
  );

  late http.Client client;
  late AppointmentApi appointmentApi;

  late String appointmentEncoded;

  late http.Response notModifiedError;
  late http.Response badRequestError;
  late http.Response notFoundError;
  late http.Response gatewayTimeoutError;

  setUp(() {
    client = MockClient();
    appointmentApi = AppointmentApi(client);
  });

  setUpAll(() {
    appointmentEncoded = json.encode(MockDataAppointment.appointment);

    notModifiedError = http.Response(
      ApiErrorMessage.notModified,
      304,
      headers: headers,
    );

    badRequestError = http.Response(
      ApiErrorMessage.badRequest,
      400,
      headers: headers,
    );

    notFoundError = http.Response(
      ApiErrorMessage.notFound,
      404,
      headers: headers,
    );

    gatewayTimeoutError = http.Response(
      ApiErrorMessage.gatewayTimeout,
      504,
      headers: headers,
    );
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
      'get appointments with error code 304',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(url),
        ).thenAnswer(
          (_) async => notModifiedError,
        );

        expect(
          await appointmentApi.getAppointments(),
          ApiErrorMessage.notModified,
        );
      },
    );

    test(
      'get appointments with error code 400',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(url),
        ).thenAnswer(
          (_) async => badRequestError,
        );

        expect(
          await appointmentApi.getAppointments(),
          ApiErrorMessage.badRequest,
        );
      },
    );

    test(
      'get appointments with error code 404',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(url),
        ).thenAnswer(
          (_) async => notFoundError,
        );

        expect(
          await appointmentApi.getAppointments(),
          ApiErrorMessage.notFound,
        );
      },
    );

    test(
      'get appointments with error code 504',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(url),
        ).thenAnswer(
          (_) async => gatewayTimeoutError,
        );

        expect(
          await appointmentApi.getAppointments(),
          ApiErrorMessage.gatewayTimeout,
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
