part of 'appointment_bloc.dart';

abstract class AppointmentEvent {
  const AppointmentEvent();
}

class AppointmentInitialize extends AppointmentEvent {}

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
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  final DateTime date;

  final TimeOfDay startTime;

  final TimeOfDay endTime;
}
