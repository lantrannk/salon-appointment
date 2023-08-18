import '../../../core/storage/appointment_storage.dart';
import '../../../core/storage/user_storage.dart';
import '../model/appointment.dart';

class AppointmentRepository {
  Future<List<Appointment>> load() async {
    final userStorage = UserStorage();
    final user = await userStorage.getUser();

    final appointments = (user!.isAdmin)
        ? await AppointmentStorage.getAppointments()
        : await AppointmentStorage.getAppointmentsOfUser(user.id);

    return appointments;
  }
}
