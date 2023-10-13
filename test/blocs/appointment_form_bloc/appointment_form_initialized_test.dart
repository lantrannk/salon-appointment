import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/utils/common.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/repository/appointment_repository.dart';
import 'package:salon_appointment/features/appointments/screens/appointment_form/bloc/appointment_form_bloc.dart';
import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:salon_appointment/features/auth/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';

class MockAppointmentRepo extends Mock implements AppointmentRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Appointment appointment;

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

    adminUser = MockDataUser.adminUser;
    users = MockDataUser.allUsers;

    initialDateTime = MockDataDateTime.initialDateTime;
    initialDateTimeInBreak = MockDataDateTime.initialDateTimeInBreak;
    initialDateTimeInClosed = MockDataDateTime.initialDateTimeInClosed;
  });

  setUp(
    () async {
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
          appointment: appointment,
          initDateTime: DateTime.now(),
        ),
      ),
      expect: () => <AppointmentFormState>[
        MockDataState.initialAppointmentFormState,
        MockDataState.editInitialAppointmentFormState,
        MockDataState.editInitialAppointmentFormState.copyWith(
          status: AppointmentFormStatus.initSuccess,
        ),
      ],
    );
  });
}
