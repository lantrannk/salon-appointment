part of 'appointment_form_bloc.dart';

class AppointmentFormEvent extends Equatable {
  const AppointmentFormEvent();

  @override
  List<Object> get props => [];
}

class AppointmentFormInitialized extends AppointmentFormEvent {
  const AppointmentFormInitialized({
    required this.initDateTime,
    this.appointment,
  });

  final Appointment? appointment;
  final DateTime initDateTime;
}

class AppointmentFormAdded extends AppointmentFormEvent {
  const AppointmentFormAdded({
    this.date,
    this.startTime,
    this.endTime,
    this.services,
    this.description,
  });

  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? services;
  final String? description;
}

class AppointmentFormEdited extends AppointmentFormEvent {
  const AppointmentFormEdited({
    this.date,
    this.startTime,
    this.endTime,
    this.services,
    this.description,
  });

  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? services;
  final String? description;
}

class AppointmentFormDateChanged extends AppointmentFormEvent {
  const AppointmentFormDateChanged({
    required this.date,
  });

  final DateTime? date;
}

class AppointmentFormStartTimeChanged extends AppointmentFormEvent {
  const AppointmentFormStartTimeChanged({
    required this.startTime,
  });

  final TimeOfDay? startTime;
}

class AppointmentFormEndTimeChanged extends AppointmentFormEvent {
  const AppointmentFormEndTimeChanged({
    required this.endTime,
  });

  final TimeOfDay? endTime;
}

class AppointmentFormServicesChanged extends AppointmentFormEvent {
  const AppointmentFormServicesChanged({
    required this.services,
  });

  final String services;
}
