import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
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

  late AppointmentFormState initSuccessAppointmentFormState;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    appointmentRepo = MockAppointmentRepo();
    userRepo = MockUserRepository();

    initSuccessAppointmentFormState =
        MockDataState.initSuccessAppointmentFormState;
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
