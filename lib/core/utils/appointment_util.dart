import 'package:flutter/material.dart';

import '../../features/appointments/model/appointment.dart';
import '../constants/date_format.dart';
import '../constants/error_message.dart';
import '../generated/l10n.dart';

String dateTimeChangeFailure(BuildContext context, String error) {
  final l10n = S.of(context);

  switch (error) {
    case ErrorMessage.beforeNow:
      return l10n.invalidStartTimeError;
    case ErrorMessage.differentTime:
      return l10n.invalidEndTimeError;
    case ErrorMessage.breakConflict:
      return l10n.breakTimeConflictError;
    case ErrorMessage.closedConflict:
      return l10n.closedTimeError;
    default:
      return l10n.unknownError;
  }
}

/// Returns [bool] that [appointments] in period [startTime] to [endTime] is not full
bool isFullAppointments(
  List<Appointment> appointments,
  DateTime startTime,
  DateTime endTime,
) {
  final beforeTime = startTime.subtract(
    const Duration(minutes: 1),
  );

  final startTimeConflict = appointments.where(
    (e) => e.startTime.isAfter(beforeTime) && e.startTime.isBefore(endTime),
  );

  final endTimeConflict = appointments.where(
    (e) => e.endTime.isAfter(beforeTime) && e.endTime.isBefore(endTime),
  );

  return startTimeConflict.length >= 5 || endTimeConflict.length >= 5;
}

/// Returns a sorted [appointments] list of a [date]
List<Appointment> groupByDate(List<Appointment> appointments, DateTime date) {
  final dateStr = dateFormat.format(date);

  final List<Appointment> appointmentsOfDate = appointments
      .where((e) => dateFormat.format(e.date) == dateStr)
      .toList()
    ..sort((a, b) => a.startTime.compareTo(b.startTime));

  return appointmentsOfDate;
}
