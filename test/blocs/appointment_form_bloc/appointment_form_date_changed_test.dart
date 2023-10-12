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

class MockAppointmentRepo extends Mock implements AppointmentRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late Appointment appointment;

  late AppointmentRepository appointmentRepo;
  late UserRepository userRepo;

  late DateTime initialDateTime;

  late AppointmentFormState initSuccessAppointmentFormState;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    appointmentRepo = MockAppointmentRepo();
    userRepo = MockUserRepository();

    appointment = MockDataAppointment.appointment;

    initialDateTime = MockDataDateTime.initialDateTime;

    initSuccessAppointmentFormState =
        MockDataState.initSuccessAppointmentFormState;
  });

  group('test appointment form bloc - change date', () {
    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when the date is null',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      seed: () => initSuccessAppointmentFormState,
      act: (bloc) => bloc.add(
        const AppointmentFormDateChanged(date: null),
      ),
      expect: () => <AppointmentFormState>[],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when the date is the same as the date in state',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      seed: () => initSuccessAppointmentFormState,
      act: (bloc) => bloc.add(
        AppointmentFormDateChanged(
          date: MockDataDateTime.initSuccessDateTime,
        ),
      ),
      expect: () => <AppointmentFormState>[],
    );

    blocTest<AppointmentFormBloc, AppointmentFormState>(
      'failure when the date time is before current time',
      build: () => AppointmentFormBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      seed: () => initSuccessAppointmentFormState,
      act: (bloc) => bloc.add(
        AppointmentFormDateChanged(
          date: appointment.date,
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.beforeChange,
        ),
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.changeFailure,
          error: ErrorMessage.beforeNow,
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
        AppointmentFormDateChanged(
          date: initialDateTime,
        ),
      ),
      expect: () => <AppointmentFormState>[
        initSuccessAppointmentFormState.copyWith(
          status: AppointmentFormStatus.beforeChange,
        ),
        initSuccessAppointmentFormState.copyWith(
          date: initialDateTime,
          startTime: setDateTime(
            initialDateTime,
            getTime(MockDataDateTime.initSuccessDateTime),
          ),
          endTime: autoAddHalfHour(
            setDateTime(
              initialDateTime,
              getTime(MockDataDateTime.initSuccessDateTime),
            ),
          ),
          status: AppointmentFormStatus.changeSuccess,
        ),
      ],
    );
  });
}
