import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../core/utils/common.dart';
import '../../../../auth/repository/user_repository.dart';
import '../../../model/appointment.dart';
import '../../../repository/appointment_repository.dart';

part 'calendar_event.dart';
part 'calendar_state.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  CalendarBloc({
    required this.appointmentRepository,
    required this.userRepository,
  }) : super(CalendarState(
          focusedDay: today,
          selectedDay: today,
        )) {
    on<CalendarAppointmentLoaded>(_loadAppointment);
    on<CalendarDaySelected>(_selectDay);
    on<CalendarPageChanged>(_changePage);
  }

  final AppointmentRepository appointmentRepository;
  final UserRepository userRepository;

  Future<void> _loadAppointment(
    CalendarAppointmentLoaded event,
    Emitter<CalendarState> emit,
  ) async {
    try {
      final appointments = await appointmentRepository.loadAllAppointments();

      emit(
        state.copyWith(
          appointments: appointments,
          status: LoadStatus.loadSuccess,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: LoadStatus.loadFailure,
          error: e.toString(),
        ),
      );
    }
  }

  void _selectDay(
    CalendarDaySelected event,
    Emitter<CalendarState> emit,
  ) {
    if (!isSameDay(state.selectedDay, event.selectedDay)) {
      emit(
        state.copyWith(
          focusedDay: event.focusedDay,
          selectedDay: event.selectedDay,
        ),
      );
    }
  }

  void _changePage(
    CalendarPageChanged event,
    Emitter<CalendarState> emit,
  ) {
    emit(
      state.copyWith(
        focusedDay: event.focusedDay,
        selectedDay: event.focusedDay,
      ),
    );
  }
}
