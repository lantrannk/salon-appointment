import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:salon_appointment/features/auth/repository/user_repository.dart';

import '../../../core/storage/appointment_storage.dart';
import '../../auth/model/user.dart';
import '../api/appointment_api.dart';
import '../model/appointment.dart';

class AppointmentRepository {
  final AppointmentStorage appointmentStorage = AppointmentStorage();
  final AppointmentApi appointmentApi = AppointmentApi(http.Client());
  final UserRepository userRepository = UserRepository();

  /// Get a list of appointments
  Future<List<Appointment>> loadAllAppointments() async {
    late List<Appointment> appointments;
    late User user;

    /// Wait concurrently to get a list of appointments and get a user
    await Future.wait([
      getAllAppointments().then((value) => appointments = value),
      userRepository.getUser().then((value) => user = value!)
    ]);

    return (user.isAdmin)
        // If [user] is admin, returns a list of all appointments
        ? appointments
        // If [user] is not admin, returns a list of user's appointments
        : appointments.where((e) => e.userId == user.id).toList();
  }

  /// Get a list of all appointments from API
  Future<List<Appointment>> getAllAppointments() async {
    final String appointmentsStr = await appointmentApi.getAppointments();
    final List<Appointment> appointments =
        (json.decode(appointmentsStr) as List)
            .map((e) => Appointment.fromJson(e))
            .toList();

    return appointments;
  }

  /// Add an appointment
  Future<void> addAppointment(Appointment appointment) async {
    await appointmentApi.addAppointment(appointment);
  }

  /// Edit an appointment
  Future<void> editAppointment(Appointment appointment) async {
    await appointmentApi.updateAppointment(appointment);
  }

  /// Remove an appointment by Appointment ID
  Future<void> removeAppointment(String appointmentId) async {
    await appointmentApi.deleteAppointment(appointmentId);
  }
}
