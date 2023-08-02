import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/appointments/api/appointment_api.dart';
import '../../features/appointments/model/appointment.dart';

class AppointmentStorage {
  /// Save a [List] of [String] appointment encode
  static Future<void> setAppointments() async {
    final AppointmentApi appointmentApi = AppointmentApi();
    final String appointments = await appointmentApi.getAppointments(
      http.Client(),
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('appointments', appointments);
  }

  /// Returns a [List] of [Appointment] from storage
  static Future<List<Appointment>> getAppointments() async {
    await setAppointments();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String appointmentsStr = prefs.getString('appointments')!;
    final List<Appointment> appointments =
        (json.decode(appointmentsStr) as List)
            .map((e) => Appointment.fromJson(e))
            .toList();

    return appointments;
  }

  static Future<List<Appointment>> getAppointmentsOfUser(String userId) async {
    final List<Appointment> appointments = await getAppointments();
    final List<Appointment> appointmentsOfUser =
        appointments.where((e) => e.userId == userId).toList();
    return appointmentsOfUser;
  }
}
