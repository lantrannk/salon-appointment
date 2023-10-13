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

  late Appointment appointment;
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

    appointment = MockDataAppointment.addAppointment;
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
        () => appointmentRepo.addAppointment(appointment),
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
      seed: () => initSuccessAppointmentFormState,
      act: (bloc) => bloc.add(
        AppointmentFormAdded(
          date: appointment.date,
          startTime: appointment.startTime,
          endTime: appointment.endTime,
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.addFailure,
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
        AppointmentFormAdded(
          date: appointment.date,
          startTime: appointment.startTime,
          endTime: appointment.endTime,
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.addFailure,
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
        AppointmentFormAdded(
          date: fullAppointmentsDateTime,
          startTime: fullAppointmentsDateTime,
          endTime: autoAddHalfHour(fullAppointmentsDateTime),
          services: appointment.services,
          description: appointment.description,
        ),
      ),
      expect: () => <AppointmentFormState>[
        fullAppointmentsAppointmentFormState.copyWith(
          status: AppointmentFormStatus.addFailure,
          error: ErrorMessage.fullAppointments,
        ),
      ],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when have api error',
      build: () {
        when(
          () => appointmentRepo.addAppointment(appointment),
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
        AppointmentFormAdded(
          date: initSuccessDateTime,
          startTime: initSuccessDateTime,
          endTime: autoAddHalfHour(initSuccessDateTime),
          services: appointment.services,
          description: appointment.description,
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.addInProgress,
        ),
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.addFailure,
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
        AppointmentFormAdded(
          date: appointment.date,
          startTime: appointment.startTime,
          endTime: appointment.endTime,
          services: appointment.services,
          description: appointment.description,
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.addInProgress,
        ),
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.addSuccess,
        ),
      ],
    );
  });
}
