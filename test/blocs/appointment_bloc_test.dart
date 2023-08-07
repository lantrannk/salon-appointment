import 'dart:io' as io;
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../expect_data/expect_data.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {
  MockAppointmentBloc(this.client);

  @override
  final http.Client client;
}

class MockHTTPClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  final headers = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
  };
  final url = Uri.parse(
    'https://63ab8e97fdc006ba60609b9b.mockapi.io/appointments',
  );

  late AppointmentBloc appointmentBloc;
  late List<User> users;
  late List<Appointment> appointments;
  late Appointment appointment;
  late http.Client client;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    users = ExpectData.allUsers;
    appointments = ExpectData.allAppointments;
    appointment = ExpectData.appointment;

    client = MockHTTPClient();
    appointmentBloc = MockAppointmentBloc(client);
  });

  group('test appointment bloc -', () {
    blocTest(
      'load appointments successful by admin',
      build: () => appointmentBloc,
      act: (bloc) => bloc.add(
        AppointmentLoad(),
      ),
      wait: const Duration(seconds: 3),
      setUp: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user',
          ExpectData.adminUserStr,
        );

        when(
          () => client.get(url),
        ).thenAnswer(
          (_) async => http.Response(
            ExpectData.appointmentsStr,
            200,
            headers: headers,
          ),
        );
      },
      expect: () => [
        isA<AppointmentLoading>(),
        isA<AppointmentLoadSuccess>(),
      ],
    );

    blocTest(
      'load appointments successful by customer',
      build: () => appointmentBloc,
      act: (bloc) => bloc.add(
        AppointmentLoad(),
      ),
      wait: const Duration(seconds: 3),
      setUp: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user',
          ExpectData.adminUserStr,
        );
      },
      expect: () => [
        isA<AppointmentLoading>(),
        isA<AppointmentLoadSuccess>(),
      ],
    );

    blocTest(
      'add appointment successful',
      build: () => appointmentBloc,
      act: (bloc) => bloc.add(
        AppointmentAdd(appointment: appointment),
      ),
      wait: const Duration(seconds: 3),
      setUp: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user',
          ExpectData.adminUserStr,
        );
      },
      expect: () => [
        isA<AppointmentAdding>(),
        isA<AppointmentAdded>(),
      ],
    );

    blocTest(
      'update appointment successful',
      build: () => appointmentBloc,
      act: (bloc) => bloc.add(
        AppointmentEdit(
          appointment: appointment.copyWith(services: 'Back'),
        ),
      ),
      wait: const Duration(seconds: 3),
      setUp: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user',
          ExpectData.adminUserStr,
        );
      },
      expect: () => [
        isA<AppointmentAdding>(),
        isA<AppointmentEdited>(),
      ],
    );

    blocTest(
      'remove appointment successful',
      build: () => appointmentBloc,
      act: (bloc) => bloc.add(
        AppointmentRemovePressed(
          appointmentId: appointment.id!,
        ),
      ),
      wait: const Duration(seconds: 3),
      setUp: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user',
          ExpectData.adminUserStr,
        );
      },
      expect: () => [
        isA<AppointmentRemoving>(),
        isA<AppointmentRemoved>(),
      ],
    );
  });
}
