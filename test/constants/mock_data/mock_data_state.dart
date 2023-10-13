import 'package:salon_appointment/features/appointments/screens/appointment/bloc/appointment_bloc.dart';
import 'package:salon_appointment/features/appointments/screens/calendar/bloc/calendar_bloc.dart';

class MockDataState {
  static final initialAppointmentState = AppointmentState(
    users: const [],
    appointments: const [],
    focusedDay: DateTime.now(),
    selectedDay: DateTime.now(),
    error: null,
    status: Status.loadInProgress,
  );

  static final initialCalendarState = CalendarState(
    appointments: const [],
    focusedDay: DateTime.now(),
    selectedDay: DateTime.now(),
    error: null,
    status: LoadStatus.loadInProgress,
  );
}
