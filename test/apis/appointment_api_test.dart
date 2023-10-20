import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/error_handle/exception_handler.dart';
import 'package:salon_appointment/features/appointments/api/appointment_api.dart';

import '../constants/constants.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  final headers = {'Content-Type': 'application/json'};

  late http.Client client;
  late AppointmentApi appointmentApi;

  late String appointmentEncoded;

  setUp(() {
    client = MockClient();
    appointmentApi = AppointmentApi(client);
  });

  setUpAll(() {
    appointmentEncoded = json.encode(MockDataAppointment.appointment);
  });

  group('test appointment api get request -', () {
    test(
      'get appointments then return a encoded string of appointments list',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(allAppointmentsUrl),
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
          () => client.get(allAppointmentsUrl),
        ).thenAnswer(
          (_) async => ApiError.notModifiedError,
        );

        expect(
          await appointmentApi.getAppointments(),
          ResponseMessage.notModified,
        );
      },
    );

    test(
      'get appointments with error code 400',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(allAppointmentsUrl),
        ).thenAnswer(
          (_) async => ApiError.badRequestError,
        );

        expect(
          await appointmentApi.getAppointments(),
          ResponseMessage.badRequest,
        );
      },
    );

    test(
      'get appointments with error code 404',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(allAppointmentsUrl),
        ).thenAnswer(
          (_) async => ApiError.notFoundError,
        );

        expect(
          await appointmentApi.getAppointments(),
          ResponseMessage.notFound,
        );
      },
    );

    test(
      'get appointments with error code 500',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(allAppointmentsUrl),
        ).thenAnswer(
          (_) async => ApiError.internalServerError,
        );

        expect(
          await appointmentApi.getAppointments(),
          ResponseMessage.internalServerError,
        );
      },
    );
  });

  group('test appointment api post request -', () {
    test(
      'add appointments success',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.post(
            allAppointmentsUrl,
            body: appointmentEncoded,
            headers: headers,
          ),
        ).thenAnswer(
          (_) async => http.Response(
            MockDataAppointment.appointmentJson,
            200,
            headers: headers,
          ),
        );

        expect(
          await appointmentApi.addAppointment(MockDataAppointment.appointment),
          MockDataAppointment.appointmentJson,
        );
      },
    );

    test(
      'add appointment with error code 304',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.post(
            allAppointmentsUrl,
            body: appointmentEncoded,
            headers: headers,
          ),
        ).thenAnswer(
          (_) async => ApiError.notModifiedError,
        );

        expect(
          await appointmentApi.addAppointment(MockDataAppointment.appointment),
          ResponseMessage.notModified,
        );
      },
    );

    test(
      'add appointment with error code 400',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.post(
            allAppointmentsUrl,
            body: appointmentEncoded,
            headers: headers,
          ),
        ).thenAnswer(
          (_) async => ApiError.badRequestError,
        );

        expect(
          await appointmentApi.addAppointment(MockDataAppointment.appointment),
          ResponseMessage.badRequest,
        );
      },
    );

    test(
      'add appointment with error code 404',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.post(
            allAppointmentsUrl,
            body: appointmentEncoded,
            headers: headers,
          ),
        ).thenAnswer(
          (_) async => ApiError.notFoundError,
        );

        expect(
          await appointmentApi.addAppointment(MockDataAppointment.appointment),
          ResponseMessage.notFound,
        );
      },
    );

    test(
      'add appointment with error code 500',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.post(
            allAppointmentsUrl,
            body: appointmentEncoded,
            headers: headers,
          ),
        ).thenAnswer(
          (_) async => ApiError.internalServerError,
        );

        expect(
          await appointmentApi.addAppointment(MockDataAppointment.appointment),
          ResponseMessage.internalServerError,
        );
      },
    );
  });

  group('test appointment api put request -', () {
    test(
      'update appointments success',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.put(
            appointmentUrl,
            body: appointmentEncoded,
            headers: headers,
          ),
        ).thenAnswer(
          (_) async => http.Response(
            MockDataAppointment.appointmentJson,
            200,
            headers: headers,
          ),
        );

        expect(
          await appointmentApi.updateAppointment(
            MockDataAppointment.appointment,
          ),
          MockDataAppointment.appointmentJson,
        );
      },
    );

    test(
      'update appointment with error code 304',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.put(
            appointmentUrl,
            body: appointmentEncoded,
            headers: headers,
          ),
        ).thenAnswer(
          (_) async => ApiError.notModifiedError,
        );

        expect(
          await appointmentApi.updateAppointment(
            MockDataAppointment.appointment,
          ),
          ResponseMessage.notModified,
        );
      },
    );

    test(
      'update appointment with error code 400',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.put(
            appointmentUrl,
            body: appointmentEncoded,
            headers: headers,
          ),
        ).thenAnswer(
          (_) async => ApiError.badRequestError,
        );

        expect(
          await appointmentApi.updateAppointment(
            MockDataAppointment.appointment,
          ),
          ResponseMessage.badRequest,
        );
      },
    );

    test(
      'update appointment with error code 404',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.put(
            appointmentUrl,
            body: appointmentEncoded,
            headers: headers,
          ),
        ).thenAnswer(
          (_) async => ApiError.notFoundError,
        );

        expect(
          await appointmentApi.updateAppointment(
            MockDataAppointment.appointment,
          ),
          ResponseMessage.notFound,
        );
      },
    );

    test(
      'update appointment with error code 500',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.put(
            appointmentUrl,
            body: appointmentEncoded,
            headers: headers,
          ),
        ).thenAnswer(
          (_) async => ApiError.internalServerError,
        );

        expect(
          await appointmentApi.updateAppointment(
            MockDataAppointment.appointment,
          ),
          ResponseMessage.internalServerError,
        );
      },
    );
  });

  group('test appointment api delete request -', () {
    test(
      'delete appointments success',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.delete(appointmentUrl),
        ).thenAnswer(
          (_) async => http.Response(
            MockDataAppointment.appointmentJson,
            200,
            headers: headers,
          ),
        );

        expect(
          await appointmentApi.deleteAppointment('84'),
          MockDataAppointment.appointmentJson,
        );
      },
    );

    test(
      'delete appointment with error code 304',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.delete(appointmentUrl),
        ).thenAnswer(
          (_) async => ApiError.notModifiedError,
        );

        expect(
          await appointmentApi.deleteAppointment('84'),
          ResponseMessage.notModified,
        );
      },
    );

    test(
      'delete appointment with error code 400',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.delete(appointmentUrl),
        ).thenAnswer(
          (_) async => ApiError.badRequestError,
        );

        expect(
          await appointmentApi.deleteAppointment('84'),
          ResponseMessage.badRequest,
        );
      },
    );

    test(
      'delete appointment with error code 404',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.delete(appointmentUrl),
        ).thenAnswer(
          (_) async => ApiError.notFoundError,
        );

        expect(
          await appointmentApi.deleteAppointment('84'),
          ResponseMessage.notFound,
        );
      },
    );

    test(
      'delete appointment with error code 500',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.delete(appointmentUrl),
        ).thenAnswer(
          (_) async => ApiError.internalServerError,
        );

        expect(
          await appointmentApi.deleteAppointment('84'),
          ResponseMessage.internalServerError,
        );
      },
    );
  });
}
