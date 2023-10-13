import 'dart:io' as io;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/appointments/model/appointment.dart';
import 'package:salon_appointment/features/appointments/repository/appointment_repository.dart';
import 'package:salon_appointment/features/appointments/screens/calendar/bloc/calendar_bloc.dart';
import 'package:salon_appointment/features/auth/model/user.dart';
import 'package:salon_appointment/features/auth/repository/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class MockAppointmentRepo extends Mock implements AppointmentRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  io.HttpOverrides.global = null;

  late List<Appointment> appointments;
  late List<Appointment> appointmentsOfUser;

  late AppointmentRepository appointmentRepo;
  late UserRepository userRepo;
  late User adminUser;
  late User customerUser;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});

    appointmentRepo = MockAppointmentRepo();
    userRepo = MockUserRepository();

    appointments = MockDataAppointment.allAppointments;
    appointmentsOfUser = MockDataAppointment.appointmentsOfUser;

    adminUser = MockDataUser.adminUser;
    customerUser = MockDataUser.customerUser;
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

  group('test load appointments bloc -', () {
    blocTest<CalendarBloc, CalendarState>(
      'load appointments failure when can not get list of appointments',
      build: () {
        when(
          () => appointmentRepo.loadAllAppointments(),
        ).thenThrow(
          Exception('Not found any appointments.'),
        );

        return CalendarBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        const CalendarAppointmentLoaded(),
      ),
      expect: () => <CalendarState>[
        MockDataState.initialCalendarState.copyWith(
          error: 'Exception: Not found any appointments.',
          status: LoadStatus.loadFailure,
        ),
      ],
    );

    blocTest<CalendarBloc, CalendarState>(
      'load appointments successful by admin',
      build: () {
        when(
          () => appointmentRepo.loadAllAppointments(),
        ).thenAnswer(
          (_) async => appointments,
        );

        return CalendarBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        const CalendarAppointmentLoaded(),
      ),
      expect: () => <CalendarState>[
        MockDataState.initialCalendarState.copyWith(
          appointments: appointments,
          status: LoadStatus.loadSuccess,
        ),
      ],
    );

    blocTest<CalendarBloc, CalendarState>(
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

        return CalendarBloc(
          appointmentRepository: appointmentRepo,
          userRepository: userRepo,
        );
      },
      act: (bloc) => bloc.add(
        const CalendarAppointmentLoaded(),
      ),
      expect: () => <CalendarState>[
        MockDataState.initialCalendarState.copyWith(
          appointments: appointmentsOfUser,
          status: LoadStatus.loadSuccess,
        ),
      ],
    );
  });

  group('test select calendar day bloc -', () {
    blocTest<CalendarBloc, CalendarState>(
      'select calendar day successful',
      build: () => CalendarBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      act: (bloc) => bloc.add(
        CalendarDaySelected(
          focusedDay: DateTime(2023, 10, 3),
          selectedDay: DateTime(2023, 10, 3),
        ),
      ),
      expect: () => <CalendarState>[
        MockDataState.initialCalendarState.copyWith(
          focusedDay: DateTime(2023, 10, 3),
          selectedDay: DateTime(2023, 10, 3),
        ),
      ],
    );

    blocTest<CalendarBloc, CalendarState>(
      'select calendar day failure when '
      'the selected day input is the same as the selected day in state',
      build: () => CalendarBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      act: (bloc) => bloc.add(
        CalendarDaySelected(
          focusedDay: DateTime.now(),
          selectedDay: DateTime.now(),
        ),
      ),
      expect: () => <CalendarState>[],
    );
  });

  group('test change calendar page bloc -', () {
    blocTest<CalendarBloc, CalendarState>(
      'change calendar page successful',
      build: () => CalendarBloc(
        appointmentRepository: appointmentRepo,
        userRepository: userRepo,
      ),
      act: (bloc) => bloc.add(
        CalendarPageChanged(
          focusedDay: DateTime(2023, 10, 3),
        ),
      ),
      expect: () => <CalendarState>[
        MockDataState.initialCalendarState.copyWith(
          focusedDay: DateTime(2023, 10, 3),
          selectedDay: DateTime(2023, 10, 3),
        ),
      ],
    );
  });
}
