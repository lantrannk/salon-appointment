import '../../../core/storage/appointment_storage.dart';
import '../../../core/storage/user_storage.dart';
import '../../auth/model/user.dart';
import '../model/appointment.dart';

class AppointmentRepository {
  static Future<List<Appointment>> load(DateTime date) async {
    final Map<String, dynamic> userJson = await UserStorage.getUser();
    final user = User.fromJson(userJson);

    final appointments = (user.isAdmin)
        ? await AppointmentStorage.getAppointments()
        : await AppointmentStorage.getAppointmentsOfUser(user.id);

    return appointments;
  }
}
