part of 'appointment_bloc.dart';

class AppointmentEvent extends Equatable {
  const AppointmentEvent();

  @override
  List<Object?> get props => [];
}

class AppointmentLoaded extends AppointmentEvent {
  const AppointmentLoaded({
    this.focusedDay,
  });

  final DateTime? focusedDay;
}

class AppointmentCalendarDaySelected extends AppointmentEvent {
  const AppointmentCalendarDaySelected({
    required this.focusedDay,
    required this.selectedDay,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
}

class AppointmentCalendarPageChanged extends AppointmentEvent {
  const AppointmentCalendarPageChanged({
    required this.focusedDay,
  });

  final DateTime focusedDay;
}

class AppointmentRemoved extends AppointmentEvent {
  const AppointmentRemoved({
    required this.appointmentId,
  });

  final String appointmentId;
}
