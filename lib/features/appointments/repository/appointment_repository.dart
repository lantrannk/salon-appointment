import '../../../core/storage/appointment_storage.dart';
import '../../../core/storage/user_storage.dart';
import '../model/appointment.dart';

class AppointmentRepository {
  static Future<List<Appointment>> load() async {
    final user = await UserStorage.getUser();

    final appointments = (user!.isAdmin)
        ? await AppointmentStorage.getAppointments()
        : await AppointmentStorage.getAppointmentsOfUser(user.id);

    return appointments;
  }
}
