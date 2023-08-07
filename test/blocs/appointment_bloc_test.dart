import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../expect_data/expect_data.dart';

class MockAppointmentBloc extends Mock implements AppointmentBloc {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AppointmentBloc appointmentBloc;
  late List<User> users;
  late List<Appointment> appointments;

  final appointment = Appointment.fromJson({
    'date': '2023-08-15T10:55:00.000',
    'startTime': '2023-08-15T19:00:00.000',
    'endTime': '2023-08-15T19:30:00.000',
    'userId': '1',
    'services': 'Non-Invasive Body Contouring',
    'description': 'Nothing to write.',
    'isCompleted': false,
    'id': '81'
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    users = ExpectData.allUsers;
    appointments = ExpectData.allAppointments;

    appointmentBloc = MockAppointmentBloc();
  });

  group('test appointment bloc -', () {
    blocTest(
      'load appointments successful by admin',
      build: () {
        when(() => appointmentBloc.add(AppointmentLoad())).thenAnswer((_) {
          appointmentBloc
            ..emit(AppointmentLoading())
            ..emit(
              AppointmentLoadSuccess(
                users: users,
                appointments: appointments,
              ),
            );
        });
        return appointmentBloc;
      },
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
      tearDown: () => appointmentBloc.close(),
      expect: () => [isA<AppointmentLoading>(), isA<AppointmentLoadSuccess>()],
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
          '{"phoneNumber":"0905999222","name":"Carol Williams","avatar":"https://assets.vogue.in/photos/611cf20c8733032148fe1b06/2:3/w_2560%2Cc_limit/Slide%25201.jpg","password":"123456","isAdmin":false,"id":"2"}',
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
