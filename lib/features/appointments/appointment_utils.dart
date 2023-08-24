import 'package:flutter/material.dart';

import '../../core/generated/l10n.dart';
import 'model/appointment.dart';

String dateTimeChangeFailure(BuildContext context, String error) {
  final l10n = S.of(context);

  switch (error) {
    case 'before-now':
      return l10n.invalidStartTimeError;
    case 'different-time':
      return l10n.invalidEndTimeError;
    case 'break-conflict':
      return l10n.breakTimeConflictError;
    case 'closed-conflict':
      return l10n.closedTimeError;
    default:
      return 'Unknown error';
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
