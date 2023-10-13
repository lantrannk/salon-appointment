import 'package:salon_appointment/features/appointments/screens/appointment/bloc/appointment_bloc.dart';

class MockDataState {
  static final initialAppointmentState = AppointmentState(
    users: const [],
    appointments: const [],
    focusedDay: DateTime.now(),
    selectedDay: DateTime.now(),
    error: null,
    status: Status.loadInProgress,
  );
}
