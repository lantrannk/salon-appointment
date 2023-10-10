import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/repository/appointment_repository.dart';
import 'package:salon_appointment/features/appointments/screens/appointment_form/bloc/appointment_form_bloc.dart';
import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:salon_appointment/features/auth/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class MockAppointmentRepo extends Mock implements AppointmentRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Appointment appointment;
  late List<Appointment> appointments;

  late AppointmentRepository appointmentRepo;
  late UserRepository userRepo;
  late User adminUser;
  late List<User> users;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    appointmentRepo = MockAppointmentRepo();
    userRepo = MockUserRepository();

    appointment = MockDataAppointment.appointment;
    appointments = MockDataAppointment.allAppointments;

    adminUser = MockDataUser.adminUser;
    users = MockDataUser.allUsers;
  });

  setUp(
    () async {
      when(() => userRepo.setUser(adminUser)).thenAnswer(
        (_) async => Future.value(),
      );

      when(() => userRepo.getUser()).thenAnswer(
        (_) async => adminUser,
      );

      when(
        () => userRepo.getUsers(),
      ).thenAnswer(
        (_) async => users,
      );
    },
  );

  group('test init appointment form bloc -', () {
    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'init appointment form failure when can not get list of users',
      build: () {
        when(
          () => userRepo.getUsers(),
        ).thenThrow(
          Exception('Not found any users.'),
        );

        return AppointmentFormBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        const AppointmentFormInitialized(),
      ),
      expect: () => <AppointmentFormState>[
        const AppointmentFormState(
          status: AppointmentFormStatus.initFailure,
          error: 'Exception: Not found any users.',
        ),
      ],
    );

    // TODO: test initializing appointment form on more different time
    // TODO: (in break time, in closed time, not in both break time and closed time)

    // blocTest<AppointmentFormBloc, AppointmentFormState>(
    //   'init edit appointment form successful',
    //   build: () => AppointmentFormBloc(
    //     appointmentRepository: appointmentRepo,
    //     userRepository: userRepo,
    //   ),
    //   act: (bloc) => bloc.add(
    //     const AppointmentFormInitialized(),
    //   ),
    //   expect: () => <AppointmentFormState>[
    //     const AppointmentFormState(
    //       status: AppointmentFormStatus.initInProgress,
    //     ),
    //     AppointmentFormState(
    //       user: adminUser,
    //       date: DateTime.now(),
    //       startTime: DateTime.now(),
    //       endTime: DateTime.now(),
    //       status: AppointmentFormStatus.initInProgress,
    //     ),
    //     AppointmentFormState(
    //       user: adminUser,
    //       date: DateTime.now(),
    //       startTime: DateTime.now(),
    //       endTime: DateTime.now(),
    //       status: AppointmentFormStatus.initSuccess,
    //     ),
    //   ],
    // );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'init edit appointment form successful when have input appointment',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      act: (bloc) => bloc.add(
        AppointmentFormInitialized(appointment: appointment),
      ),
      expect: () => <AppointmentFormState>[
        const AppointmentFormState(
          status: AppointmentFormStatus.initInProgress,
        ),
        AppointmentFormState(
          user: adminUser,
          date: appointment.date,
          startTime: appointment.startTime,
          endTime: appointment.endTime,
          services: appointment.services,
          description: appointment.description,
          status: AppointmentFormStatus.initInProgress,
        ),
        AppointmentFormState(
          user: adminUser,
          date: appointment.date,
          startTime: appointment.startTime,
          endTime: appointment.endTime,
          services: appointment.services,
          description: appointment.description,
          status: AppointmentFormStatus.initSuccess,
        ),
      ],
    );
  });
}
