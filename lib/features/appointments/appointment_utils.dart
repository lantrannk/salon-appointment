import 'package:flutter/material.dart';

import '../../core/constants/error_message.dart';
import '../../core/generated/l10n.dart';
import 'model/appointment.dart';

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
      return ErrorMessage.unknown;
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
