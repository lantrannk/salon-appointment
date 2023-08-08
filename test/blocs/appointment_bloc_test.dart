import 'dart:io' as io;
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../expect_data/expect_data.dart';

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

  late Appointment appointment;
  late http.Client client;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    appointment = ExpectData.appointment;

    client = MockHTTPClient();
  });

  group('test appointment bloc -', () {
    blocTest<AppointmentBloc, AppointmentState>(
      'load appointments successful by admin',
      build: () {
        when(
          () => client.get(url),
        ).thenAnswer(
          (_) async => http.Response(
            ExpectData.appointmentsStr,
            200,
            headers: headers,
          ),
        );
        return AppointmentBloc(client);
      },
      seed: () => AppointmentLoading(),
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
      expect: () => <AppointmentState>[
        AppointmentLoadSuccess(
          users: ExpectData.allUsers,
          appointments: ExpectData.allAppointments,
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'load appointments successful by customer',
      build: () {
        when(
          () => client.get(url),
        ).thenAnswer(
          (_) async => http.Response(
            ExpectData.appointmentsStr,
            200,
            headers: headers,
          ),
        );
        return AppointmentBloc(client);
      },
      act: (bloc) => bloc.add(
        AppointmentLoad(),
      ),
      seed: () => AppointmentLoading(),
      wait: const Duration(seconds: 3),
      setUp: () async {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
          'user',
          ExpectData.customerUserStr,
        );
      },
      expect: () => <AppointmentState>[
        AppointmentLoadSuccess(
          users: ExpectData.allUsers,
          appointments: ExpectData.appointmentsOfUser,
        ),
      ],
    );

    // blocTest<AppointmentBloc, AppointmentState>(
    //   'add appointment successful',
    //   build: () {
    //     when(
    //       () => client.post(
    //         url,
    //         body: appointment,
    //         headers: headers,
    //       ),
    //     ).thenAnswer(
    //       (_) async => http.Response(
    //         ExpectData.appointmentStr,
    //         200,
    //         headers: headers,
    //       ),
    //     );
    //     return AppointmentBloc(client);
    //   },
    //   act: (bloc) => bloc.add(
    //     AppointmentAdd(appointment: appointment),
    //   ),
    //   seed: () => AppointmentAdding(),
    //   wait: const Duration(seconds: 3),
    //   setUp: () async {
    //     final prefs = await SharedPreferences.getInstance();
    //     await prefs.setString(
    //       'user',
    //       ExpectData.adminUserStr,
    //     );
    //   },
    //   expect: () => <AppointmentState>[
    //     AppointmentAdded(),
    //   ],
    // );

    // blocTest<AppointmentBloc, AppointmentState>(
    //   'update appointment successful',
    //   build: () {
    //     when(
    //       () => client.put(
    //         url,
    //         body: appointment,
    //         headers: headers,
    //       ),
    //     ).thenAnswer(
    //       (_) async => http.Response(
    //         ExpectData.appointmentStr,
    //         200,
    //         headers: headers,
    //       ),
    //     );
    //     return AppointmentBloc(client);
    //   },
    //   act: (bloc) => bloc.add(
    //     AppointmentEdit(appointment: appointment),
    //   ),
    //   seed: () => AppointmentAdding(),
    //   wait: const Duration(seconds: 3),
    //   setUp: () async {
    //     final prefs = await SharedPreferences.getInstance();
    //     await prefs.setString(
    //       'user',
    //       ExpectData.adminUserStr,
    //     );
    //   },
    //   expect: () => <AppointmentState>[
    //     AppointmentEdited(),
    //   ],
    // );

    // blocTest<AppointmentBloc, AppointmentState>(
    //   'remove appointment successful',
    //   build: () {
    //     when(
    //       () => client.delete(
    //         url,
    //         body: appointment,
    //         headers: headers,
    //       ),
    //     ).thenAnswer(
    //       (_) async => http.Response(
    //         ExpectData.appointmentStr,
    //         200,
    //         headers: headers,
    //       ),
    //     );
    //     return AppointmentBloc(client);
    //   },
    //   act: (bloc) => bloc.add(
    //     AppointmentRemovePressed(appointmentId: appointment.id!),
    //   ),
    //   seed: () => AppointmentAdding(),
    //   wait: const Duration(seconds: 3),
    //   setUp: () async {
    //     final prefs = await SharedPreferences.getInstance();
    //     await prefs.setString(
    //       'user',
    //       ExpectData.adminUserStr,
    //     );
    //   },
    //   expect: () => <AppointmentState>[
    //     AppointmentRemoved(),
    //   ],
    // );
  });
}
