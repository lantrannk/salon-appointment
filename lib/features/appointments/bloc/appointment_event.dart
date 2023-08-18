part of 'appointment_bloc.dart';

abstract class AppointmentEvent {
  const AppointmentEvent();
}

class UserLoad extends AppointmentEvent {}

class AppointmentLoad extends AppointmentEvent {}

class AppointmentAdded extends AppointmentEvent {
  const AppointmentAdded({
    required this.appointment,
  });

  final Appointment appointment;
}

class AppointmentEdited extends AppointmentEvent {
  const AppointmentEdited({
    required this.appointment,
  });

  final Appointment appointment;
}

class AppointmentRemoved extends AppointmentEvent {
  const AppointmentRemoved({
    required this.appointmentId,
  });

  final String appointmentId;
}
