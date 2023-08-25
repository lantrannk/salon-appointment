import '../../../core/storage/appointment_storage.dart';
import '../../auth/model/user.dart';
import '../model/appointment.dart';

class AppointmentRepository {
  Future<List<Appointment>> loadAllAppointments(User user) async {
    final appointments = (user.isAdmin)
        ? await AppointmentStorage.getAppointments()
        : await AppointmentStorage.getAppointmentsOfUser(user.id);

    return appointments;
  }
}
