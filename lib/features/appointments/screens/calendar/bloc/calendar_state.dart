part of 'calendar_bloc.dart';

class CalendarState extends Equatable {
  const CalendarState({
    required this.focusedDay,
    required this.selectedDay,
    this.appointments = const [],
    this.status = LoadStatus.loadInProgress,
    this.error,
  });

  final List<Appointment> appointments;
  final DateTime focusedDay;
  final DateTime selectedDay;
  final LoadStatus status;
  final String? error;

  @override
  List<Object?> get props => [
        appointments,
        dateFormat.format(focusedDay),
        dateFormat.format(selectedDay),
        status,
        error,
      ];

  CalendarState copyWith({
    List<Appointment>? appointments,
    DateTime? focusedDay,
    DateTime? selectedDay,
    LoadStatus? status,
    String? error,
  }) {
    return CalendarState(
      appointments: appointments ?? this.appointments,
      focusedDay: focusedDay ?? this.focusedDay,
      selectedDay: selectedDay ?? this.selectedDay,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

enum LoadStatus { loadInProgress, loadSuccess, loadFailure }
