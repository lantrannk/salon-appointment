part of 'appointment_bloc.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  List<Appointment>? get appointments => [];

  List<User> get users => [];

  String? get error => '';
}

class UserLoadSuccess extends AppointmentState {
  const UserLoadSuccess(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

class UserLoadFailure extends AppointmentState {
  const UserLoadFailure({this.error});

  @override
  final String? error;

  @override
  List<Object?> get props => [error];
}

class AppointmentInitial extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentLoadInProgress extends AppointmentState {
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

class AppointmentLoadFailure extends AppointmentState {
  const AppointmentLoadFailure({this.error});

  @override
  final String? error;

  @override
  List<Object?> get props => [error];
}

class AppointmentAddInProgress extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentAddSuccess extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentEditSuccess extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentAddFailure extends AppointmentState {
  const AppointmentAddFailure({this.error});

  @override
  final String? error;

  @override
  List<Object?> get props => [error];
}

class AppointmentRemoveInProgress extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentRemoveSuccess extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentRemoveFailure extends AppointmentState {
  const AppointmentRemoveFailure({this.error});

  @override
  final String? error;

  @override
  List<Object?> get props => [error];
}
