part of 'appointment_bloc.dart';

class AppointmentState extends Equatable {
  const AppointmentState({
    this.focusedDay,
    this.selectedDay,
    this.users = const [],
    this.appointments = const [],
    this.error,
    this.status = Status.loadInProgress,
  });

  final List<User> users;
  final List<Appointment> appointments;
  final DateTime? focusedDay;
  final DateTime? selectedDay;
  final String? error;
  final Status status;

  @override
  List<Object?> get props => [
        users,
        appointments,
        dateFormat.format(focusedDay!),
        dateFormat.format(selectedDay!),
        error,
        status,
      ];

  AppointmentState copyWith({
    List<User>? users,
    List<Appointment>? appointments,
    DateTime? focusedDay,
    DateTime? selectedDay,
    String? error,
    Status? status,
  }) {
    return AppointmentState(
      users: users ?? this.users,
      appointments: appointments ?? this.appointments,
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      error: error ?? this.error,
      status: status ?? this.status,
    );
  }
}

enum Status {
  loadInProgress,
  loadSuccess,
  loadFailure,
  removeInProgress,
  removeSuccess,
  removeFailure
}
