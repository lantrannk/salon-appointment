import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/storage/appointment_storage.dart';
import '../../auth/model/user.dart';
import '../api/appointment_api.dart';
import '../model/appointment.dart';

class AppointmentRepository {
  final AppointmentStorage appointmentStorage = AppointmentStorage();
  final AppointmentApi appointmentApi = AppointmentApi(http.Client());

  Future<List<Appointment>> loadAllAppointments(User user) async {
    final appointments = (user.isAdmin)
        ? await getAllAppointments()
        : await getAppointmentsByUserId(user.id);

    return appointments;
  }

  /// Save a [String] of appointments list encode
  Future<void> setAppointments() async {
    final String appointmentsStr = await appointmentApi.getAppointments();
    await appointmentStorage.setAppointments(appointmentsStr);
  }

  /// Returns a [List] of [Appointment] from storage
  Future<List<Appointment>> getAllAppointments() async {
    await setAppointments();
    final String? appointmentsStr =
        await appointmentStorage.getAllAppointments();
    final List<Appointment> appointments =
        (json.decode(appointmentsStr!) as List)
            .map((e) => Appointment.fromJson(e))
            .toList();

    return appointments;
  }

  /// Returns a [List] of [Appointment] by user id from storage
  Future<List<Appointment>> getAppointmentsByUserId(
    String userId,
  ) async {
    final List<Appointment> appointments = await getAllAppointments();
    final List<Appointment> appointmentsOfUser =
        appointments.where((e) => e.userId == userId).toList();
    return appointmentsOfUser;
  }
}
