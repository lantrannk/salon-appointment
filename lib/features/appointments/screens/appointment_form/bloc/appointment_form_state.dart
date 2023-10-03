part of 'appointment_form_bloc.dart';

class AppointmentFormState extends Equatable {
  const AppointmentFormState({
    this.user,
    this.date,
    this.startTime,
    this.endTime,
    this.services,
    this.description,
    this.isCompleted,
    this.status = AppointmentFormStatus.initInProgress,
    this.error,
  });

  final User? user;
  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? services;
  final String? description;
  final bool? isCompleted;
  final AppointmentFormStatus status;
  final String? error;

  @override
  List<Object?> get props => [
        date,
        startTime,
        endTime,
        user,
        services,
        description,
        isCompleted,
        status,
        error,
      ];

  AppointmentFormState copyWith({
    User? user,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? services,
    String? description,
    bool? isCompleted,
    AppointmentFormStatus? status,
    String? error,
  }) {
    return AppointmentFormState(
      user: user ?? this.user,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      services: services ?? this.services,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

enum AppointmentFormStatus {
  initInProgress,
  initSuccess,
  initFailure,
  addInProgress,
  addSuccess,
  addFailure,
  editInProgress,
  editSuccess,
  editFailure,
  beforeChange,
  changeDateFailure,
  changeDateSuccess,
  changeStartTimeFailure,
  changeStartTimeSuccess,
  changeEndTimeFailure,
  changeEndTimeSuccess,
  changeServicesSuccess,
}
