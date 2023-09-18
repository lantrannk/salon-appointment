import 'dart:convert';
import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/repository/appointment_repository.dart';
import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:salon_appointment/features/auth/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_error_message.dart';
import '../constants/mock_data/mock_data.dart';

class MockAppointmentRepo extends Mock implements AppointmentRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late String appointmentEncoded;
  late Appointment appointment;
  late List<Appointment> appointments;
  late List<Appointment> appointmentsOfUser;

  late AppointmentRepository appointmentRepo;
  late UserRepository userRepo;
  late SharedPreferences prefs;
  late User adminUser;
  late User customerUser;
  late List<User> users;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    prefs = await SharedPreferences.getInstance();
    appointmentRepo = MockAppointmentRepo();
    userRepo = MockUserRepository();

    appointment = MockDataAppointment.appointment;
    appointmentEncoded = json.encode(appointment);
    appointments = MockDataAppointment.allAppointments;
    appointmentsOfUser = MockDataAppointment.appointmentsOfUser;

    adminUser = MockDataUser.adminUser;
    customerUser = MockDataUser.customerUser;
    users = MockDataUser.allUsers;

    when(
      () => userRepo.getUsers(),
    ).thenAnswer(
      (_) async => users,
    );
  });

  setUp(
    () async {
      when(() => userRepo.setUser(adminUser)).thenAnswer(
        (_) async => Future.value(),
      );

      when(() => userRepo.getUser()).thenAnswer(
        (_) async => adminUser,
      );
    },
  );

  Future<void> addAppointment() {
    return appointmentRepo.addAppointment(appointment);
  }

  Future<void> editAppointment() {
    return appointmentRepo.editAppointment(appointment);
  }

  Future<void> removeAppointment() {
    return appointmentRepo.removeAppointment(appointment.id!);
  }

  group('test load appointments bloc -', () {
    tearDown(() async {
      await prefs.clear();
    });

    blocTest<AppointmentBloc, AppointmentState>(
      'load appointments failure',
      build: () {
        when(
          () => appointmentRepo.loadAllAppointments(adminUser),
        ).thenThrow(
          Exception('Not found any appointments.'),
        );

        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentLoad(),
      ),
      expect: () => <AppointmentState>[
        AppointmentLoadInProgress(),
        const AppointmentLoadFailure(
          error: 'Exception: Not found any appointments.',
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'load appointments successful by admin',
      build: () {
        when(
          () => appointmentRepo.loadAllAppointments(adminUser),
        ).thenAnswer(
          (_) async => appointments,
        );

        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentLoad(),
      ),
      expect: () => <AppointmentState>[
        AppointmentLoadInProgress(),
        AppointmentLoadSuccess(
          users: users,
          appointments: appointments,
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'load appointments successful by customer',
      build: () {
        when(
          () => appointmentRepo.loadAllAppointments(customerUser),
        ).thenAnswer(
          (_) async => appointmentsOfUser,
        );

        when(
          () => userRepo.getUser(),
        ).thenAnswer(
          (_) async => customerUser,
        );

        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentLoad(),
      ),
      expect: () => <AppointmentState>[
        AppointmentLoadInProgress(),
        AppointmentLoadSuccess(
          users: users,
          appointments: appointmentsOfUser,
        ),
      ],
    );
  });

  group('test add appointment bloc -', () {
    blocTest<AppointmentBloc, AppointmentState>(
      'add appointment successful',
      build: () {
        when(
          () => addAppointment(),
        ).thenAnswer(
          (_) async => appointmentEncoded,
        );
        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentAdded(appointment: appointment),
      ),
      expect: () => <AppointmentState>[
        AppointmentAddInProgress(),
        AppointmentAddSuccess(),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'add appointment with not modified error',
      build: () {
        when(
          () => addAppointment(),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.notModified),
        );
        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentAdded(appointment: appointment),
      ),
      expect: () => <AppointmentState>[
        AppointmentAddInProgress(),
        const AppointmentAddFailure(
          error: ApiErrorMessage.notModified,
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'add appointment with bad request error',
      build: () {
        when(
          () => addAppointment(),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.badRequest),
        );
        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentAdded(appointment: appointment),
      ),
      expect: () => <AppointmentState>[
        AppointmentAddInProgress(),
        const AppointmentAddFailure(
          error: ApiErrorMessage.badRequest,
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'add appointment with not found error',
      build: () {
        when(
          () => addAppointment(),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.notFound),
        );
        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentAdded(appointment: appointment),
      ),
      expect: () => <AppointmentState>[
        AppointmentAddInProgress(),
        const AppointmentAddFailure(
          error: ApiErrorMessage.notFound,
        ),
      ],
    );
  });

  group('test edit appointment bloc -', () {
    blocTest<AppointmentBloc, AppointmentState>(
      'update appointment successful',
      build: () {
        when(
          () => editAppointment(),
        ).thenAnswer(
          (_) async => appointmentEncoded,
        );
        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentEdited(appointment: appointment),
      ),
      expect: () => <AppointmentState>[
        AppointmentAddInProgress(),
        AppointmentEditSuccess(),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'update appointment with not modified error',
      build: () {
        when(
          () => editAppointment(),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.notModified),
        );
        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentEdited(appointment: appointment),
      ),
      expect: () => <AppointmentState>[
        AppointmentAddInProgress(),
        const AppointmentAddFailure(
          error: ApiErrorMessage.notModified,
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'update appointment with bad request error',
      build: () {
        when(
          () => editAppointment(),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.badRequest),
        );
        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentEdited(appointment: appointment),
      ),
      expect: () => <AppointmentState>[
        AppointmentAddInProgress(),
        const AppointmentAddFailure(
          error: ApiErrorMessage.badRequest,
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'update appointment with not found error',
      build: () {
        when(
          () => editAppointment(),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.notFound),
        );
        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentEdited(appointment: appointment),
      ),
      expect: () => <AppointmentState>[
        AppointmentAddInProgress(),
        const AppointmentAddFailure(
          error: ApiErrorMessage.notFound,
        ),
      ],
    );
  });

  group('test remove appointment bloc -', () {
    blocTest<AppointmentBloc, AppointmentState>(
      'remove appointment successful',
      build: () {
        when(
          () => removeAppointment(),
        ).thenAnswer(
          (_) async => appointmentEncoded,
        );
        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentRemoved(
          appointmentId: appointment.id!,
        ),
      ),
      expect: () => <AppointmentState>[
        AppointmentRemoveInProgress(),
        AppointmentRemoveSuccess(),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'remove appointment with not modified error',
      build: () {
        when(
          () => removeAppointment(),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.notModified),
        );
        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentRemoved(
          appointmentId: appointment.id!,
        ),
      ),
      expect: () => <AppointmentState>[
        AppointmentRemoveInProgress(),
        const AppointmentRemoveFailure(
          error: ApiErrorMessage.notModified,
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'remove appointment with bad request error',
      build: () {
        when(
          () => removeAppointment(),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.badRequest),
        );
        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentRemoved(
          appointmentId: appointment.id!,
        ),
      ),
      expect: () => <AppointmentState>[
        AppointmentRemoveInProgress(),
        const AppointmentRemoveFailure(
          error: ApiErrorMessage.badRequest,
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'remove appointment with not found error',
      build: () {
        when(
          () => removeAppointment(),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.notFound),
        );
        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentRemoved(
          appointmentId: appointment.id!,
        ),
      ),
      expect: () => <AppointmentState>[
        AppointmentRemoveInProgress(),
        const AppointmentRemoveFailure(
          error: ApiErrorMessage.notFound,
        ),
      ],
    );
  });
}
