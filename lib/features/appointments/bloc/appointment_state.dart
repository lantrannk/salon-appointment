part of 'appointment_bloc.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  List<Appointment>? get appointments => [];

  List<User> get users => [];

  String? get error => '';
}

class UserLoaded extends AppointmentState {
  const UserLoaded(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

class UserLoadError extends AppointmentState {
  const UserLoadError({this.error});

  @override
  final String? error;

  @override
  List<Object?> get props => [error];
}

class AppointmentInitial extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentLoading extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentLoadSuccess extends AppointmentState {
  const AppointmentLoadSuccess({
    required this.users,
    required this.appointments,
  });

  @override
  final List<Appointment>? appointments;

  @override
  final List<User> users;

  @override
  List<Object?> get props => [users, appointments];
}

class AppointmentLoadError extends AppointmentState {
  const AppointmentLoadError({this.error});

  @override
  final String? error;

  @override
  List<Object?> get props => [error];
}

class AppointmentAdding extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentAdded extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentEdited extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentAddError extends AppointmentState {
  const AppointmentAddError({this.error});

  @override
  final String? error;

  @override
  List<Object?> get props => [error];
}

class AppointmentRemoving extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentRemoved extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentRemoveError extends AppointmentState {
  const AppointmentRemoveError({this.error});

  @override
  final String? error;

  @override
  List<Object?> get props => [error];
}
