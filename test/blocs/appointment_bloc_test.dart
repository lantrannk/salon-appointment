import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../expect_data/expect_data.dart';

class MockHTTPClient extends Mock implements http.Client {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  final headers = {'Content-Type': 'application/json'};
  final url = Uri.parse(
    'https://63ab8e97fdc006ba60609b9b.mockapi.io/appointments',
  );

  late http.Client client;
  late SharedPreferences prefs;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    prefs = await SharedPreferences.getInstance();
    client = MockHTTPClient();
  });

  blocTest<AppointmentBloc, AppointmentState>(
    'load appointments successful by admin',
    build: () {
      when(
        () => client.get(url),
      ).thenAnswer(
        (_) async => http.Response(
          AppointmentExpect.allAppointmentsEncoded,
          200,
          headers: headers,
        ),
      );
      return AppointmentBloc(client);
    },
    // why need seed
    // seed: () => AppointmentLoading(),
    act: (bloc) => bloc.add(
      AppointmentLoad(),
    ),
    wait: const Duration(seconds: 3),
    setUp: () async {
      await prefs.setString(
        'user',
        UserExpect.adminUserEncoded,
      );
    },
    tearDown: () async {
      await prefs.clear();
    },
    expect: () => <AppointmentState>[
      AppointmentLoading(),
      AppointmentLoadSuccess(
        users: UserExpect.allUsers,
        appointments: AppointmentExpect.allAppointments,
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
          AppointmentExpect.allAppointmentsEncoded,
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
      await prefs.setString(
        'user',
        UserExpect.customerUserEncoded,
      );
    },
    tearDown: () async {
      await prefs.clear();
    },
    expect: () => <AppointmentState>[
      AppointmentLoadSuccess(
        users: UserExpect.allUsers,
        appointments: AppointmentExpect.appointmentsOfUser,
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
  //     await prefs.setString(
  //       'user',
  //       ExpectData.adminUserStr,
  //     );
  //   },
  //   expect: () => <AppointmentState>[
  //     AppointmentRemoved(),
  //   ],
  // );
}
