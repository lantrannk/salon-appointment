part of 'appointment_form_bloc.dart';

class AppointmentFormEvent extends Equatable {
  const AppointmentFormEvent();

  @override
  List<Object> get props => [];
}

class AppointmentAdded extends AppointmentFormEvent {
  const AppointmentAdded({
    required this.appointment,
  });

  final Appointment appointment;
}

class AppointmentEdited extends AppointmentFormEvent {
  const AppointmentEdited({
    required this.appointment,
  });

  final Appointment appointment;
}

class AppointmentDateTimeChanged extends AppointmentFormEvent {
  const AppointmentDateTimeChanged({
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  final DateTime date;

  final TimeOfDay startTime;

  final TimeOfDay endTime;
}

class AppointmentServicesChanged extends AppointmentFormEvent {
  const AppointmentServicesChanged({
    required this.services,
  });

  final String services;
}
