import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/constants/constants.dart';
import 'package:salon_appointment/core/utils/common.dart';
import 'package:salon_appointment/features/appointments/repository/appointment_repository.dart';
import 'package:salon_appointment/features/appointments/screens/appointment_form/bloc/appointment_form_bloc.dart';
import 'package:salon_appointment/features/auth/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/constants.dart';

class MockAppointmentRepo extends Mock implements AppointmentRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late AppointmentRepository appointmentRepo;
  late UserRepository userRepo;

  late DateTime initialDateTime;

  late DateTime initialDateTimeInBreak;
  late DateTime initialDateTimeInClosed;

  late AppointmentFormState initSuccessAppointmentFormState;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    appointmentRepo = MockAppointmentRepo();
    userRepo = MockUserRepository();

    initialDateTime = MockDataDateTime.initialDateTime;

    initialDateTimeInBreak = MockDataDateTime.initialDateTimeInBreak;
    initialDateTimeInClosed = MockDataDateTime.initialDateTimeInClosed;

    initSuccessAppointmentFormState =
        MockDataState.initSuccessAppointmentFormState;
  });

  group('test appointment form bloc - change start time', () {
    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when the start time is null',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      seed: () => initSuccessAppointmentFormState,
      act: (bloc) => bloc.add(
        const AppointmentFormStartTimeChanged(startTime: null),
      ),
      expect: () => <AppointmentFormState>[],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when the start time is the same as the start time in state',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      seed: () => initSuccessAppointmentFormState,
      act: (bloc) => bloc.add(
        AppointmentFormStartTimeChanged(
          startTime: getTime(MockDataDateTime.initSuccessDateTime),
        ),
      ),
      expect: () => <AppointmentFormState>[],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when the start time is before current time',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      seed: () => initSuccessAppointmentFormState.copyWith(
        date: DateTime.now(),
      ),
      act: (bloc) => bloc.add(
        const AppointmentFormStartTimeChanged(
          startTime: TimeOfDay(hour: 8, minute: 0),
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          date: DateTime.now(),
          status: AppointmentFormStatus.beforeChange,
        ),
        initSuccessAppointmentFormState.copyWith(
          date: DateTime.now(),
          status: AppointmentFormStatus.changeFailure,
          error: ErrorMessage.beforeNow,
        ),
      ],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when the start time is in break time',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      seed: () => initSuccessAppointmentFormState.copyWith(),
      act: (bloc) => bloc.add(
        AppointmentFormStartTimeChanged(
          startTime: getTime(initialDateTimeInBreak),
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.beforeChange,
        ),
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.changeFailure,
          error: ErrorMessage.breakConflict,
        ),
      ],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when the start time is in closed time',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      seed: () => initSuccessAppointmentFormState.copyWith(),
      act: (bloc) => bloc.add(
        AppointmentFormStartTimeChanged(
          startTime: getTime(initialDateTimeInClosed),
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.beforeChange,
        ),
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.changeFailure,
          error: ErrorMessage.closedConflict,
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
        AppointmentFormStartTimeChanged(
          startTime: getTime(initialDateTime),
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.beforeChange,
        ),
        initSuccessAppointmentFormState.copyWith(
          startTime: setDateTime(
            MockDataDateTime.initSuccessDateTime,
            getTime(initialDateTime),
          ),
          endTime: autoAddHalfHour(
            setDateTime(
              MockDataDateTime.initSuccessDateTime,
              getTime(initialDateTime),
            ),
          ),
          status: AppointmentFormStatus.changeSuccess,
        ),
      ],
    );
  });
}