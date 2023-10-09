import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:salon_appointment/core/utils/common.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../auth/model/user.dart';
import '../../../../auth/repository/user_repository.dart';
import '../../../model/appointment.dart';
import '../../../repository/appointment_repository.dart';

part 'appointment_event.dart';
part 'appointment_state.dart';

class AppointmentBloc extends Bloc<AppointmentEvent, AppointmentState> {
  AppointmentBloc({
    required this.appointmentRepository,
    required this.userRepository,
  }) : super(AppointmentState(
          focusedDay: today,
          selectedDay: today,
        )) {
    on<AppointmentLoaded>(_loadAppointments);
    on<AppointmentRemoved>(_removeAppointment);
    on<AppointmentCalendarDaySelected>(_selectDay);
    on<AppointmentCalendarPageChanged>(_changePage);
  }

  final AppointmentRepository appointmentRepository;
  final UserRepository userRepository;

  Future<void> _loadAppointments(
    AppointmentLoaded event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          focusedDay: event.focusedDay ?? state.focusedDay,
          selectedDay: event.focusedDay ?? state.selectedDay,
          status: Status.loadInProgress,
        ),
      );

      late List<User> users;
      late List<Appointment> appointments;

      await Future.wait([
        userRepository.getUsers().then((value) => users = value),
        appointmentRepository
            .loadAllAppointments()
            .then((value) => appointments = value),
      ]);

      emit(
        state.copyWith(
          users: users,
          appointments: appointments,
          status: Status.loadSuccess,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString(),
          status: Status.loadFailure,
        ),
      );
    }
  }

  Future<void> _removeAppointment(
    AppointmentRemoved event,
    Emitter<AppointmentState> emit,
  ) async {
    try {
      emit(
        state.copyWith(
          status: Status.removeInProgress,
        ),
      );

      await appointmentRepository.removeAppointment(event.appointmentId);

      emit(
        state.copyWith(
          status: Status.removeSuccess,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          error: e.toString(),
          status: Status.removeFailure,
        ),
      );
    }
  }

  void _selectDay(
    AppointmentCalendarDaySelected event,
    Emitter<AppointmentState> emit,
  ) {
    if (!isSameDay(state.selectedDay, event.selectedDay)) {
      emit(
        state.copyWith(
          focusedDay: event.focusedDay,
          selectedDay: event.focusedDay,
        ),
      );
    }
  }

  void _changePage(
    AppointmentCalendarPageChanged event,
    Emitter<AppointmentState> emit,
  ) {
    emit(
      state.copyWith(
        focusedDay: event.focusedDay,
        selectedDay: event.focusedDay,
      ),
    );
  }
}
