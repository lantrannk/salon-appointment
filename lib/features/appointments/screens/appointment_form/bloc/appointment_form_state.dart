part of 'appointment_form_bloc.dart';

class AppointmentFormState extends Equatable {
  const AppointmentFormState({
    this.date,
    this.startTime,
    this.endTime,
    this.userId,
    this.services,
    this.description,
    this.isCompleted,
  });

  final DateTime? date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? userId;
  final String? services;
  final String? description;
  final bool? isCompleted;

  @override
  List<Object?> get props => [
        date,
        startTime,
        endTime,
        userId,
        services,
        description,
        isCompleted,
      ];

  AppointmentFormState copyWith({
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? userId,
    String? services,
    String? description,
    bool? isCompleted,
  }) {
    return AppointmentFormState(
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      userId: userId ?? this.userId,
      services: services ?? this.services,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

enum AppointmentFormStatus {
  addInProgress,
  addSuccess,
  addFailure,
  editInProgress,
  editSuccess,
  editFailure,
}
