import 'dart:convert';
import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/core/storage/user_storage.dart';
import 'package:salon_appointment/features/appointments/api/appointment_api.dart';
import 'package:salon_appointment/features/appointments/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/repository/appointment_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/api_error_message.dart';
import '../mock_data/mock_data.dart';

class MockAppointmentApi extends Mock implements AppointmentApi {}

class MockAppointmentRepo extends Mock implements AppointmentRepository {}

class MockUserStorage extends Mock implements UserStorage {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late String appointmentEncoded;
  late Appointment appointment;

  late AppointmentApi appointmentApi;
  late AppointmentRepository appointmentRepo;
  late UserStorage userStorage;
  late SharedPreferences prefs;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    prefs = await SharedPreferences.getInstance();
    appointmentApi = MockAppointmentApi();
    appointmentRepo = MockAppointmentRepo();
    userStorage = MockUserStorage();

    appointmentEncoded = json.encode(MockDataAppointment.appointment);
    appointment = MockDataAppointment.appointment;

    when(
      () => userStorage.getUsers(),
    ).thenAnswer(
      (_) async => MockDataUser.allUsers,
    );
  });

  group('test load appointments bloc -', () {
    tearDown(() async {
      await prefs.clear();
    });

    blocTest<AppointmentBloc, AppointmentState>(
      'load appointments successful by admin',
      setUp: () async {
        await prefs.setString(
          'user',
          MockDataUser.adminUserJson,
        );
      },
      build: () {
        when(
          () => appointmentRepo.load(),
        ).thenAnswer(
          (_) async => MockDataAppointment.allAppointments,
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentLoad(),
      ),
      expect: () => <AppointmentState>[
        AppointmentLoadInProgress(),
        AppointmentLoadSuccess(
          users: MockDataUser.allUsers,
          appointments: MockDataAppointment.allAppointments,
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'load appointments successful by customer',
      setUp: () async {
        await prefs.setString(
          'user',
          MockDataUser.customerUserJson,
        );
      },
      build: () {
        when(
          () => appointmentRepo.load(),
        ).thenAnswer(
          (_) async => MockDataAppointment.appointmentsOfUser,
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentLoad(),
      ),
      expect: () => <AppointmentState>[
        AppointmentLoadInProgress(),
        AppointmentLoadSuccess(
          users: MockDataUser.allUsers,
          appointments: MockDataAppointment.appointmentsOfUser,
        ),
      ],
    );
  });

  group('test add appointment bloc -', () {
    setUp(() async {
      await prefs.setString(
        'user',
        MockDataUser.adminUserJson,
      );
    });

    blocTest<AppointmentBloc, AppointmentState>(
      'add appointment successful',
      build: () {
        when(
          () => appointmentApi.addAppointment(appointment),
        ).thenAnswer(
          (_) async => appointmentEncoded,
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentAdded(appointment: MockDataAppointment.appointment),
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
          () => appointmentApi.addAppointment(appointment),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.notModified),
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentAdded(appointment: MockDataAppointment.appointment),
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
          () => appointmentApi.addAppointment(appointment),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.badRequest),
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentAdded(appointment: MockDataAppointment.appointment),
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
          () => appointmentApi.addAppointment(appointment),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.notFound),
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentAdded(appointment: MockDataAppointment.appointment),
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
    setUp(() async {
      await prefs.setString(
        'user',
        MockDataUser.adminUserJson,
      );
    });

    blocTest<AppointmentBloc, AppointmentState>(
      'update appointment successful',
      build: () {
        when(
          () => appointmentApi.updateAppointment(appointment),
        ).thenAnswer(
          (_) async => appointmentEncoded,
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentEdited(appointment: MockDataAppointment.appointment),
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
          () => appointmentApi.updateAppointment(appointment),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.notModified),
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentEdited(appointment: MockDataAppointment.appointment),
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
          () => appointmentApi.updateAppointment(appointment),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.badRequest),
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentEdited(appointment: MockDataAppointment.appointment),
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
          () => appointmentApi.updateAppointment(appointment),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.notFound),
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentEdited(appointment: MockDataAppointment.appointment),
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
    setUp(() async {
      await prefs.setString(
        'user',
        MockDataUser.adminUserJson,
      );
    });

    blocTest<AppointmentBloc, AppointmentState>(
      'remove appointment successful',
      build: () {
        when(
          () => appointmentApi.deleteAppointment(appointment.id!),
        ).thenAnswer(
          (_) async => appointmentEncoded,
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentRemoved(
          appointmentId: MockDataAppointment.appointment.id!,
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
          () => appointmentApi.deleteAppointment(appointment.id!),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.notModified),
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentRemoved(
          appointmentId: MockDataAppointment.appointment.id!,
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
          () => appointmentApi.deleteAppointment(appointment.id!),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.badRequest),
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentRemoved(
          appointmentId: MockDataAppointment.appointment.id!,
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
          () => appointmentApi.deleteAppointment(appointment.id!),
        ).thenThrow(
          http.ClientException(ApiErrorMessage.notFound),
        );
        return AppointmentBloc(
          appointmentApi,
          appointmentRepo,
          userStorage,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentRemoved(
          appointmentId: MockDataAppointment.appointment.id!,
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
