part of 'appointment_bloc.dart';

abstract class AppointmentEvent {
  const AppointmentEvent();
}

class UserLoad extends AppointmentEvent {}

class AppointmentLoad extends AppointmentEvent {
  const AppointmentLoad(this.date);

  final DateTime date;
}

class AppointmentAdd extends AppointmentEvent {
  const AppointmentAdd({
    required this.appointment,
  });

  final Appointment appointment;
}

class AppointmentEdit extends AppointmentEvent {
  const AppointmentEdit({
    required this.appointment,
  });

  final Appointment appointment;
}

class AppointmentRemovePressed extends AppointmentEvent {
  const AppointmentRemovePressed({
    required this.appointmentId,
  });

  final String appointmentId;
}
