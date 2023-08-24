part of 'appointment_bloc.dart';

abstract class AppointmentEvent {
  const AppointmentEvent();
}

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

class AppointmentDateTimeChanged extends AppointmentEvent {
  const AppointmentDateTimeChanged({
    required this.dateTime,
    required this.startTime,
    required this.endTime,
  });

  final DateTime dateTime;

  final TimeOfDay startTime;

  final TimeOfDay endTime;
}
