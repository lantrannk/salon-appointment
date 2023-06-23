part of 'appointment_bloc.dart';

abstract class AppointmentState {
  const AppointmentState();

  List<Appointment>? get appointments => [];

  List<User> get users => [];

  String? get error => '';
}

class UserLoaded extends AppointmentState {
  const UserLoaded(this.user);

  final User user;
}

class UserLoadError extends AppointmentState {
  const UserLoadError({this.error});

  @override
  final String? error;
}

class AppointmentInitial extends AppointmentState {}

class AppointmentLoading extends AppointmentState {}

class AppointmentLoadSuccess extends AppointmentState {
  const AppointmentLoadSuccess({
    required this.users,
    required this.appointments,
  });

  @override
  final List<Appointment>? appointments;

  @override
  final List<User> users;
}

class AppointmentLoadError extends AppointmentState {
  const AppointmentLoadError({this.error});

  @override
  final String? error;
}

class AppointmentAdding extends AppointmentState {}

class AppointmentAdded extends AppointmentState {}

class AppointmentAddError extends AppointmentState {
  const AppointmentAddError({this.error});

  @override
  final String? error;
}

class AppointmentEditing extends AppointmentState {}

class AppointmentEdited extends AppointmentState {}

class AppointmentEditError extends AppointmentState {
  const AppointmentEditError({this.error});

  @override
  final String? error;
}

class AppointmentRemoving extends AppointmentState {}

class AppointmentRemoved extends AppointmentState {}

class AppointmentRemoveError extends AppointmentState {
  const AppointmentRemoveError({this.error});

  @override
  final String? error;
}
