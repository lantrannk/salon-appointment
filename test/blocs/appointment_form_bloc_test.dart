import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/constants/constants.dart';
import 'package:salon_appointment/core/utils/common.dart';
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

  late DateTime initialDateTime;
  late DateTime initialDateTimeInBreak;
  late DateTime initialDateTimeInClosed;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    appointmentRepo = MockAppointmentRepo();
    userRepo = MockUserRepository();

    appointment = MockDataAppointment.appointment;
    appointments = MockDataAppointment.allAppointments;

    adminUser = MockDataUser.adminUser;
    users = MockDataUser.allUsers;

    initialDateTime = DateTime(2023, 11, 3, 10, 30);
    initialDateTimeInBreak = DateTime(2023, 11, 3, 13, 0);
    initialDateTimeInClosed = DateTime(2023, 11, 3, 22, 45, 54, 485, 123);
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
        () => appointmentRepo.loadAllAppointments(),
      ).thenAnswer(
        (_) async => appointments,
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

      when(
        () => appointmentRepo.removeAppointment(appointment.id!),
      ).thenAnswer(
        (_) async => Future.value(),
      );
    },
  );

  group('test appointment form bloc - init', () {
    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when can not get list of users',
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
        AppointmentFormInitialized(initDateTime: DateTime.now()),
      ),
      expect: () => <AppointmentFormState>[
        AppointmentFormState(
          date: DateTime.now(),
          startTime: DateTime.now(),
          endTime: DateTime.now(),
          status: AppointmentFormStatus.initFailure,
          error: 'Exception: Not found any users.',
        ),
      ],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'successful when init date time is not in break time or closed time',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      act: (bloc) => bloc.add(
        AppointmentFormInitialized(
          initDateTime: initialDateTime,
        ),
      ),
      expect: () => <AppointmentFormState>[
        MockDataState.initialAppointmentFormState,
        MockDataState.initialAppointmentFormState.copyWith(
          user: adminUser,
          date: initialDateTime,
          startTime: initialDateTime,
          endTime: autoAddHalfHour(initialDateTime),
        ),
        MockDataState.initialAppointmentFormState.copyWith(
          user: adminUser,
          date: initialDateTime,
          startTime: initialDateTime,
          endTime: autoAddHalfHour(initialDateTime),
          status: AppointmentFormStatus.initSuccess,
        ),
      ],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'successful when init date time is in break time',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      act: (bloc) => bloc.add(
        AppointmentFormInitialized(
          initDateTime: initialDateTimeInBreak,
        ),
      ),
      expect: () => <AppointmentFormState>[
        MockDataState.initialAppointmentFormState,
        MockDataState.initialAppointmentFormState.copyWith(
          user: adminUser,
          date: DateTime(2023, 11, 03, 15, 20),
          startTime: DateTime(2023, 11, 03, 15, 20),
          endTime: DateTime(2023, 11, 03, 15, 50),
        ),
        MockDataState.initialAppointmentFormState.copyWith(
          user: adminUser,
          date: DateTime(2023, 11, 03, 15, 20),
          startTime: DateTime(2023, 11, 03, 15, 20),
          endTime: DateTime(2023, 11, 03, 15, 50),
          status: AppointmentFormStatus.initSuccess,
        ),
      ],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'successful when init date time is in closed time',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      act: (bloc) => bloc.add(
        AppointmentFormInitialized(
          initDateTime: initialDateTimeInClosed,
        ),
      ),
      expect: () => <AppointmentFormState>[
        MockDataState.initialAppointmentFormState,
        MockDataState.initialAppointmentFormState.copyWith(
          user: adminUser,
          date: DateTime(2023, 11, 04, 8, 0),
          startTime: DateTime(2023, 11, 04, 8, 0),
          endTime: DateTime(2023, 11, 04, 8, 30),
        ),
        MockDataState.initialAppointmentFormState.copyWith(
          user: adminUser,
          date: DateTime(2023, 11, 04, 8, 0),
          startTime: DateTime(2023, 11, 04, 8, 0),
          endTime: DateTime(2023, 11, 04, 8, 30),
          status: AppointmentFormStatus.initSuccess,
        ),
      ],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'successful when have input appointment',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      act: (bloc) => bloc.add(
        AppointmentFormInitialized(
            appointment: appointment, initDateTime: DateTime.now()),
      ),
      expect: () => <AppointmentFormState>[
        MockDataState.initialAppointmentFormState,
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

    // TODO: Fix error Type<Null> is not a subtype of Future<void>
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
    //       status: AppointmentFormStatus.addFailure,
    //       error: 'Exception: Something went wrong!',
    //     ),
    //   ],
    // );
  });
}
