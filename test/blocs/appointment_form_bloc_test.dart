import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/constants/constants.dart';
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

  late AppointmentFormState initSuccessAppointmentFormState;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    appointmentRepo = MockAppointmentRepo();
    userRepo = MockUserRepository();

    appointment = MockDataAppointment.appointment;
    appointments = MockDataAppointment.allAppointments;

    adminUser = MockDataUser.adminUser;
    users = MockDataUser.allUsers;

    initSuccessAppointmentFormState =
        MockDataState.initSuccessAppointmentFormState;
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

      when(
        () => appointmentRepo.getAllAppointments(),
      ).thenAnswer(
        (_) async => appointments,
      );

      when(
        () => appointmentRepo.addAppointment(appointment),
      ).thenAnswer(
        (_) async => Future.value(),
      );

      when(
        () => appointmentRepo.editAppointment(appointment),
      ).thenAnswer(
        (_) async => Future.value(),
      );
    },
  );

  group('test appointment form bloc - add', () {
    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when can not get list of appointments',
      build: () {
        when(
          () => appointmentRepo.getAllAppointments(),
        ).thenThrow(
          Exception('Not found any appointments.'),
        );

        return AppointmentFormBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentFormAdded(
          date: appointment.date,
          startTime: appointment.startTime,
          endTime: appointment.endTime,
        ),
      ),
      expect: () => <AppointmentFormState>[
        AppointmentFormState(
          date: DateTime.now(),
          startTime: DateTime.now(),
          endTime: DateTime.now(),
          status: AppointmentFormStatus.addFailure,
          error: 'Exception: Not found any appointments.',
        ),
      ],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when services is empty',
      build: () {
        when(
          () => appointmentRepo.getAllAppointments(),
        ).thenAnswer(
          (_) async => appointments,
        );

        return AppointmentFormBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentFormAdded(
          date: appointment.date,
          startTime: appointment.startTime,
          endTime: appointment.endTime,
        ),
      ),
      expect: () => <AppointmentFormState>[
        AppointmentFormState(
          date: DateTime.now(),
          startTime: DateTime.now(),
          endTime: DateTime.now(),
          status: AppointmentFormStatus.addFailure,
          error: ErrorMessage.emptyServices,
        ),
      ],
    );

    // TODO: define a list of full appointments to test
    // blocTest<AppointmentFormBloc, AppointmentFormState>(
    //   'failure when services is full of appointments',
    //   build: () {
    //     when(
    //       () => appointmentRepo.getAllAppointments(),
    //     ).thenAnswer(
    //       (_) async => appointments,
    //     );

    //     return AppointmentFormBloc(
    //       appointmentRepository: appointmentRepo,
    //       userRepository: userRepo,
    //     );
    //   },
    //   act: (bloc) => bloc.add(
    //     AppointmentFormAdded(
    //       date: appointment.date,
    //       startTime: appointment.startTime,
    //       endTime: appointment.endTime,
    //     ),
    //   ),
    //   expect: () => <AppointmentFormState>[
    //     AppointmentFormState(
    //       date: DateTime.now(),
    //       startTime: DateTime.now(),
    //       endTime: DateTime.now(),
    //       status: AppointmentFormStatus.addFailure,
    //       error: ErrorMessage.emptyServices,
    //     ),
    //   ],
    // );

    // FIXME: Fix error Type<Null> is not a subtype of Future<void>
    // blocTest<AppointmentFormBloc, AppointmentFormState>(
    //   'failure when have api error',
    //   build: () {
    //     when(
    //       () => appointmentRepo.addAppointment(appointment),
    //     ).thenThrow(
    //       Exception('Something went wrong!'),
    //     );

    //     return AppointmentFormBloc(
    //       appointmentRepository: appointmentRepo,
    //       userRepository: userRepo,
    //     );
    //   },
    //   seed: () => AppointmentFormState(
    //     user: adminUser,
    //     date: appointment.date,
    //     startTime: appointment.startTime,
    //     endTime: appointment.endTime,
    //     services: appointment.services,
    //     description: appointment.description,
    //     isCompleted: appointment.isCompleted,
    //     status: AppointmentFormStatus.initSuccess,
    //   ),
    //   act: (bloc) => bloc.add(
    //     AppointmentFormAdded(
    //       date: appointment.date,
    //       startTime: appointment.startTime,
    //       endTime: appointment.endTime,
    //       services: appointment.services,
    //       description: appointment.description,
    //     ),
    //   ),
    //   expect: () => <AppointmentFormState>[
    //     AppointmentFormState(
    //       user: adminUser,
    //       date: appointment.date,
    //       startTime: appointment.startTime,
    //       endTime: appointment.endTime,
    //       services: appointment.services,
    //       description: appointment.description,
    //       isCompleted: appointment.isCompleted,
    //       status: AppointmentFormStatus.addInProgress,
    //     ),
    //     AppointmentFormState(
    //       user: adminUser,
    //       date: appointment.date,
    //       startTime: appointment.startTime,
    //       endTime: appointment.endTime,
    //       services: appointment.services,
    //       description: appointment.description,
    //       isCompleted: appointment.isCompleted,
    //       status: AppointmentFormStatus.addFailure,
    //       error: 'Exception: Something went wrong!',
    //     ),
    //   ],
    // );
  });

  group('test appointment form bloc - change services', () {
    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'success',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      seed: () => initSuccessAppointmentFormState,
      act: (bloc) => bloc.add(
        const AppointmentFormServicesChanged(
          services: 'Back',
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          services: 'Back',
          status: AppointmentFormStatus.changeSuccess,
        ),
      ],
    );
  });
}
