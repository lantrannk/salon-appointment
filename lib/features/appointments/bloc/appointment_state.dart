part of 'appointment_bloc.dart';

abstract class AppointmentState extends Equatable {
  const AppointmentState();

  List<Appointment>? get appointments => [];

  List<User> get users => [];

  String? get error => '';

  User get user => const User(
        id: '',
        name: '',
        phoneNumber: '',
        avatar: '',
        password: '',
        isAdmin: false,
      );

  String get userId => '';

  String get userName => '';

  String get userAvatar => '';

  DateTime get date => DateTime.now();

  DateTime get startTime => DateTime.now();

  DateTime get endTime => DateTime.now();
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

class AppointmentDateTimeChangeSuccess extends AppointmentState {
  const AppointmentDateTimeChangeSuccess({
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  @override
  final DateTime date;

  @override
  final DateTime startTime;

  @override
  final DateTime endTime;

  @override
  List<Object?> get props => [date, startTime, endTime];
}

class AppointmentDateTimeChangeFailure extends AppointmentState {
  const AppointmentDateTimeChangeFailure({this.error});

  @override
  final String? error;

  @override
  List<Object?> get props => [error];
}

class AppointmentDateTimeBeforeChange extends AppointmentState {
  const AppointmentDateTimeBeforeChange({this.error});

  @override
  final String? error;

  @override
  List<Object?> get props => [error];
}

class AppointmentInitializeInProgress extends AppointmentState {
  @override
  List<Object?> get props => [];
}

class AppointmentInitializeSuccess extends AppointmentState {
  const AppointmentInitializeSuccess({
    required this.user,
  });

  @override
  final User user;

  @override
  List<Object?> get props => [userId, userName];
}

class AppointmentInitializeFailure extends AppointmentState {
  const AppointmentInitializeFailure({this.error});

  @override
  final String? error;

  @override
  List<Object?> get props => [error];
}
