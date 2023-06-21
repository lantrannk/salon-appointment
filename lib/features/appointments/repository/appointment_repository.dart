import 'package:intl/intl.dart';

import '../../../core/storage/appointment_storage.dart';
import '../../../core/storage/user_storage.dart';
import '../model/appointment.dart';

class AppointmentRepository {
  static Future<List<Appointment>> load(DateTime date) async {
    final Map<String, dynamic> userJson = await UserStorage.getUser();

    final appointments = (userJson['isAdmin'])
        ? await AppointmentStorage.getAppointments()
        : await AppointmentStorage.getAppointmentsOfUser(userJson['id']);
    final dateStr = DateFormat.yMd().format(date);

    final List<Appointment> appointmentsOfDate = appointments
        .where((e) => DateFormat.yMd().format(e.date) == dateStr)
        .toList()
      ..sort((a, b) => a.startTime.compareTo(b.startTime));

    return appointmentsOfDate;
  }
}
