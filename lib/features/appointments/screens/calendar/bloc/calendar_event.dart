part of 'calendar_bloc.dart';

class CalendarEvent extends Equatable {
  const CalendarEvent();

  @override
  List<Object> get props => [];
}

class CalendarAppointmentLoaded extends CalendarEvent {
  const CalendarAppointmentLoaded();
}

class CalendarDaySelected extends CalendarEvent {
  const CalendarDaySelected({
    required this.focusedDay,
    required this.selectedDay,
  });

  final DateTime focusedDay;
  final DateTime selectedDay;
}

class CalendarPageChanged extends CalendarEvent {
  const CalendarPageChanged({
    required this.focusedDay,
  });

  final DateTime focusedDay;
}
