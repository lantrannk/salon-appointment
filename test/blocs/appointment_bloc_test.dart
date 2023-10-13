import 'dart:convert';
import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/repository/appointment_repository.dart';
import 'package:salon_appointment/features/appointments/screens/appointment/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:salon_appointment/features/auth/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

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

  late AppointmentState removeInProgressAppointmentState = MockDataState
      .initialAppointmentState
      .copyWith(status: Status.removeInProgress);

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

  Future<void> removeAppointment() {
    return appointmentRepo.removeAppointment(appointment.id!);
  }

  group('test load appointments bloc -', () {
    tearDown(() async {
      await prefs.clear();
    });

    blocTest<AppointmentBloc, AppointmentState>(
      'load appointments failure when can not get list of appointments',
      build: () {
        when(
          () => appointmentRepo.loadAllAppointments(),
        ).thenThrow(
          Exception('Not found any appointments.'),
        );

        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        const AppointmentLoaded(),
      ),
      expect: () => <AppointmentState>[
        MockDataState.initialAppointmentState,
        MockDataState.initialAppointmentState.copyWith(
          error: 'Exception: Not found any appointments.',
          status: Status.loadFailure,
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'load appointments failure when can not get list of users from storage',
      build: () {
        when(
          () => userRepo.getUsers(),
        ).thenThrow(
          Exception('Not found any users.'),
        );

        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        const AppointmentLoaded(),
      ),
      expect: () => <AppointmentState>[
        MockDataState.initialAppointmentState,
        MockDataState.initialAppointmentState.copyWith(
          error: 'Exception: Not found any users.',
          status: Status.loadFailure,
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'load appointments successful by admin',
      build: () {
        when(
          () => appointmentRepo.loadAllAppointments(),
        ).thenAnswer(
          (_) async => appointments,
        );

        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        const AppointmentLoaded(),
      ),
      expect: () => <AppointmentState>[
        MockDataState.initialAppointmentState,
        MockDataState.initialAppointmentState.copyWith(
          users: users,
          appointments: appointments,
          status: Status.loadSuccess,
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'load appointments successful when have input date time',
      build: () {
        when(
          () => appointmentRepo.loadAllAppointments(),
        ).thenAnswer(
          (_) async => appointments,
        );

        return AppointmentBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        AppointmentLoaded(focusedDay: DateTime(2023, 10, 3)),
      ),
      expect: () => <AppointmentState>[
        MockDataState.initialAppointmentState.copyWith(
          focusedDay: DateTime(2023, 10, 3),
          selectedDay: DateTime(2023, 10, 3),
        ),
        MockDataState.initialAppointmentState.copyWith(
          users: users,
          appointments: appointments,
          focusedDay: DateTime(2023, 10, 3),
          selectedDay: DateTime(2023, 10, 3),
          status: Status.loadSuccess,
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'load appointments successful by customer',
      build: () {
        when(
          () => appointmentRepo.loadAllAppointments(),
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
        const AppointmentLoaded(),
      ),
      expect: () => <AppointmentState>[
        MockDataState.initialAppointmentState,
        MockDataState.initialAppointmentState.copyWith(
          users: users,
          appointments: appointmentsOfUser,
          status: Status.loadSuccess,
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
        removeInProgressAppointmentState,
        removeInProgressAppointmentState.copyWith(
          status: Status.removeSuccess,
        ),
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
        removeInProgressAppointmentState,
        removeInProgressAppointmentState.copyWith(
          error: ApiErrorMessage.notModified,
          status: Status.removeFailure,
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
        removeInProgressAppointmentState,
        removeInProgressAppointmentState.copyWith(
          error: ApiErrorMessage.badRequest,
          status: Status.removeFailure,
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
        removeInProgressAppointmentState,
        removeInProgressAppointmentState.copyWith(
          error: ApiErrorMessage.notFound,
          status: Status.removeFailure,
        ),
      ],
    );
  });

  group('test select calendar day bloc -', () {
    blocTest<AppointmentBloc, AppointmentState>(
      'select calendar day successful',
      build: () => AppointmentBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      act: (bloc) => bloc.add(
        AppointmentCalendarDaySelected(
          focusedDay: DateTime(2023, 10, 3),
          selectedDay: DateTime(2023, 10, 3),
        ),
      ),
      expect: () => <AppointmentState>[
        MockDataState.initialAppointmentState.copyWith(
          focusedDay: DateTime(2023, 10, 3),
          selectedDay: DateTime(2023, 10, 3),
        ),
      ],
    );

    blocTest<AppointmentBloc, AppointmentState>(
      'select calendar day failure when'
      'the selected day input is the same as the selected day in state',
      build: () => AppointmentBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      act: (bloc) => bloc.add(
        AppointmentCalendarDaySelected(
          focusedDay: DateTime.now(),
          selectedDay: DateTime.now(),
        ),
      ),
      expect: () => <AppointmentState>[],
    );
  });

  group('test change calendar page bloc -', () {
    blocTest<AppointmentBloc, AppointmentState>(
      'change calendar page successful',
      build: () => AppointmentBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      act: (bloc) => bloc.add(
        AppointmentCalendarPageChanged(
          focusedDay: DateTime(2023, 10, 3),
        ),
      ),
      expect: () => <AppointmentState>[
        MockDataState.initialAppointmentState.copyWith(
          focusedDay: DateTime(2023, 10, 3),
          selectedDay: DateTime(2023, 10, 3),
        ),
      ],
    );
  });
}
