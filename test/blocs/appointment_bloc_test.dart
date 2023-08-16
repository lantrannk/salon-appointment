import 'dart:convert';
import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../mock_data/mock_data.dart';

class MockHTTPClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  final headers = {'Content-Type': 'application/json'};
  const String baseUrl =
      'https://63ab8e97fdc006ba60609b9b.mockapi.io/appointments';
  final url = Uri.parse(baseUrl);
  final appointmentUrl = Uri.parse('$baseUrl/84');

  late String appointmentEncoded;

  late http.Client client;
  late SharedPreferences prefs;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    prefs = await SharedPreferences.getInstance();
    client = MockHTTPClient();

    appointmentEncoded = json.encode(MockDataAppointment.appointment);
  });

  blocTest<AppointmentBloc, AppointmentState>(
    'load appointments successful by admin',
    build: () {
      when(
        () => client.get(url),
      ).thenAnswer(
        (_) async => http.Response(
          MockDataAppointment.allAppointmentsJson,
          200,
          headers: headers,
        ),
      );
      return AppointmentBloc(client);
    },
    act: (bloc) => bloc.add(
      AppointmentLoad(),
    ),
    wait: const Duration(seconds: 3),
    setUp: () async {
      await prefs.setString(
        'user',
        MockDataUser.adminUserJson,
      );
    },
    expect: () => <AppointmentState>[
      AppointmentLoading(),
      AppointmentLoadSuccess(
        users: MockDataUser.allUsers,
        appointments: MockDataAppointment.allAppointments,
      ),
    ],
    tearDown: () async {
      await prefs.clear();
    },
  );

  blocTest<AppointmentBloc, AppointmentState>(
    'load appointments successful by customer',
    build: () {
      when(
        () => client.get(url),
      ).thenAnswer(
        (_) async => http.Response(
          MockDataAppointment.allAppointmentsJson,
          200,
          headers: headers,
        ),
      );
      return AppointmentBloc(client);
    },
    act: (bloc) => bloc.add(
      AppointmentLoad(),
    ),
    wait: const Duration(seconds: 3),
    setUp: () async {
      await prefs.setString(
        'user',
        MockDataUser.customerUserJson,
      );
    },
    expect: () => <AppointmentState>[
      AppointmentLoading(),
      AppointmentLoadSuccess(
        users: MockDataUser.allUsers,
        appointments: MockDataAppointment.appointmentsOfUser,
      ),
    ],
    tearDown: () async {
      await prefs.clear();
    },
  );

  blocTest<AppointmentBloc, AppointmentState>(
    'add appointment successful',
    build: () {
      when(
        () => client.post(
          url,
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
      return AppointmentBloc(client);
    },
    act: (bloc) => bloc.add(
      AppointmentAdd(appointment: MockDataAppointment.appointment),
    ),
    wait: const Duration(seconds: 1),
    setUp: () async {
      await prefs.setString(
        'user',
        MockDataUser.adminUserJson,
      );
    },
    expect: () => <AppointmentState>[
      AppointmentAdding(),
      AppointmentAdded(),
    ],
  );

  blocTest<AppointmentBloc, AppointmentState>(
    'update appointment successful',
    build: () {
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
      return AppointmentBloc(client);
    },
    act: (bloc) => bloc.add(
      AppointmentEdit(appointment: MockDataAppointment.appointment),
    ),
    wait: const Duration(seconds: 1),
    setUp: () async {
      await prefs.setString(
        'user',
        MockDataUser.adminUserJson,
      );
    },
    expect: () => <AppointmentState>[
      AppointmentAdding(),
      AppointmentEdited(),
    ],
  );

  blocTest<AppointmentBloc, AppointmentState>(
    'remove appointment successful',
    build: () {
      when(
        () => client.delete(appointmentUrl),
      ).thenAnswer(
        (_) async => http.Response(
          MockDataAppointment.appointmentJson,
          200,
          headers: headers,
        ),
      );
      return AppointmentBloc(client);
    },
    act: (bloc) => bloc.add(
      AppointmentRemovePressed(
        appointmentId: MockDataAppointment.appointment.id!,
      ),
    ),
    wait: const Duration(seconds: 1),
    setUp: () async {
      await prefs.setString(
        'user',
        MockDataUser.adminUserJson,
      );
    },
    expect: () => <AppointmentState>[
      AppointmentRemoving(),
      AppointmentRemoved(),
    ],
  );
}
