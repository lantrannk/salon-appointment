import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/constants/constants.dart';
import 'package:salon_appointment/core/utils/common.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/repository/appointment_repository.dart';
import 'package:salon_appointment/features/appointments/screens/appointment_form/bloc/appointment_form_bloc.dart';
import 'package:salon_appointment/features/auth/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Appointment editAppointment;
  late List<Appointment> appointments;

  late AppointmentRepository appointmentRepo;
  late UserRepository userRepo;

  late AppointmentFormState initSuccessAppointmentFormState;
  late AppointmentFormState fullAppointmentsAppointmentFormState;

  late DateTime initSuccessDateTime;
  late DateTime fullAppointmentsDateTime;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    appointmentRepo = MockAppointmentRepo();
    userRepo = MockUserRepository();

    editAppointment = MockDataAppointment.editAppointment;
    appointments = MockDataAppointment.allAppointments;

    initSuccessAppointmentFormState =
        MockDataState.initSuccessAppointmentFormState;
    fullAppointmentsAppointmentFormState =
        MockDataState.fullAppointmentsAppointmentFormState;

    initSuccessDateTime = MockDataDateTime.initSuccessDateTime;
    fullAppointmentsDateTime = MockDataDateTime.fullAppointmentsDateTime;
  });

  setUp(
    () async {
      when(
        () => appointmentRepo.getAllAppointments(),
      ).thenAnswer(
        (_) async => appointments,
      );

      when(
        () => appointmentRepo.editAppointment(editAppointment),
      ).thenAnswer(
        (_) async => Future.value(),
      );
    },
  );

  group('test appointment form bloc - edit', () {
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
      seed: () => initSuccessAppointmentFormState,
      act: (bloc) => bloc.add(
        AppointmentFormEdited(
          date: editAppointment.date,
          startTime: editAppointment.startTime,
          endTime: editAppointment.endTime,
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.editFailure,
          error: 'Exception: Not found any appointments.',
        ),
      ],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when services is empty',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      seed: () => initSuccessAppointmentFormState,
      act: (bloc) => bloc.add(
        AppointmentFormEdited(
          date: editAppointment.date,
          startTime: editAppointment.startTime,
          endTime: editAppointment.endTime,
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.editFailure,
          error: ErrorMessage.emptyServices,
        ),
      ],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when services is full of appointments',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      seed: () => fullAppointmentsAppointmentFormState,
      act: (bloc) => bloc.add(
        AppointmentFormEdited(
          date: fullAppointmentsDateTime,
          startTime: fullAppointmentsDateTime,
          endTime: autoAddHalfHour(fullAppointmentsDateTime),
          services: editAppointment.services,
          description: editAppointment.description,
        ),
      ),
      expect: () => <AppointmentFormState>[
        fullAppointmentsAppointmentFormState.copyWith(
          status: AppointmentFormStatus.editFailure,
          error: ErrorMessage.fullAppointments,
        ),
      ],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when have api error',
      build: () {
        when(
          () => appointmentRepo.editAppointment(editAppointment),
        ).thenThrow(
          Exception('Something went wrong!'),
        );

        return AppointmentFormBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      seed: () => initSuccessAppointmentFormState,
      act: (bloc) => bloc.add(
        AppointmentFormEdited(
          date: initSuccessDateTime,
          startTime: initSuccessDateTime,
          endTime: autoAddHalfHour(initSuccessDateTime),
          services: editAppointment.services,
          description: editAppointment.description,
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.editInProgress,
        ),
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.editFailure,
          error: 'Exception: Something went wrong!',
        ),
      ],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'success',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      seed: () => initSuccessAppointmentFormState,
      act: (bloc) => bloc.add(
        AppointmentFormEdited(
          date: editAppointment.date,
          startTime: editAppointment.startTime,
          endTime: editAppointment.endTime,
          services: editAppointment.services,
          description: editAppointment.description,
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.editInProgress,
        ),
        initSuccessAppointmentFormState.copyWith(
          services: editAppointment.services,
          status: AppointmentFormStatus.editSuccess,
        ),
      ],
    );
  });
}
