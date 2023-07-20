import 'package:flutter/material.dart';

import '../features/appointments/model/appointment.dart';
import 'constants/date_format.dart';

/// Returns a list of [DateTime] objects from [first] to [last], inclusive.
List<DateTime> daysInRange(DateTime first, DateTime last) {
  final dayCount = last.difference(first).inDays + 1;
  return List.generate(
    dayCount,
    (index) => DateTime.utc(first.year, first.month, first.day + index),
  );
}

/// Returns a [DateTime] added 30 minutes from [time]
DateTime autoAddHalfHour(DateTime time) =>
    time.add(const Duration(minutes: 30));

/// returns a [DateTime] with date of [date] and time of [time]
DateTime setDateTime(DateTime date, TimeOfDay time) => DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );

/// Returns a [String] of [DateTime] formatted from [time]
String formatTime(DateTime time) => timeFormat.format(time).toString();

/// Returns [bool] that [time] conflict the break time or not
bool isBreakTime(DateTime time) {
  final DateTime beforeTime = DateTime(time.year, time.month, time.day, 11, 59);
  final DateTime afterTime = DateTime(time.year, time.month, time.day, 15, 20);

  return time.isAfter(beforeTime) && time.isBefore(afterTime);
}

/// Returns [bool] that [time] conflict the close time or not
bool isClosedTime(DateTime time) {
  final DateTime closedTime = DateTime(time.year, time.month, time.day, 22, 0);
  final DateTime openedTime = DateTime(time.year, time.month, time.day, 8, 0);

  return time.isAfter(closedTime) || time.isBefore(openedTime);
}

/// Returns [bool] that [time] is before now or not
bool isBeforeNow(DateTime time) => time.isBefore(DateTime.now());

/// Returns [bool] that date of [appointment] is less than 24 hours from now
bool isLessThan24HoursFromNow(Appointment appointment) =>
    appointment.startTime.difference(DateTime.now()).inHours < 24;

/// Returns [bool] that [end] is after [start] 30 minutes
bool isAfterStartTime(DateTime start, DateTime end) => end.isAfter(
      start.add(
        const Duration(
          minutes: 29,
        ),
      ),
    );

/// Returns [bool] that [appointments] at [dateTime] is not full
bool isFullAppointments(List<Appointment> appointments, DateTime dateTime) {
  final appointmentsOfDateTime =
      appointments.where((e) => e.startTime == dateTime);
  return appointmentsOfDateTime.length >= 5;
}

List<Appointment> groupByDate(List<Appointment> appointments, DateTime date) {
  final dateStr = dateFormat.format(date);

  final List<Appointment> appointmentsOfDate = appointments
      .where((e) => dateFormat.format(e.date) == dateStr)
      .toList()
    ..sort((a, b) => a.startTime.compareTo(b.startTime));

  return appointmentsOfDate;
}

DateTime rangeStartDay(DateTime dateTime) => dateTime.subtract(
      Duration(
        days: dateTime.weekday - 1,
      ),
    );

DateTime rangeEndDay(DateTime dateTime) => dateTime.add(
      Duration(
        days: DateTime.daysPerWeek - dateTime.weekday,
      ),
    );

final today = DateTime.now();
final firstDay = DateTime(today.year - 10, today.month, today.day);
final lastDay = DateTime(today.year + 10, today.month, today.day);
