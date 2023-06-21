import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:salon_appointment/features/appointments/model/appointment.dart';

import '../../../core/constants/constants.dart';

class AppointmentApi {
  static Future<String> getAppointments() async {
    final url = Uri.parse('$apiUrl/appointments');

    final response = await http.get(url);

    return response.body;
  }

  static Future<void> addAppointment(Appointment appointment) async {
    final url = Uri.parse('$apiUrl/appointments');
    final headers = {'Content-Type': 'application/json'};
    final map = appointment.toJson();
    final body = json.encode(map);

    await http.post(url, body: body, headers: headers).then((response) {});
  }

  static Future<void> updateAppointment(Appointment appointment) async {
    final url = Uri.parse('$apiUrl/appointments/${appointment.id}');
    final headers = {'Content-Type': 'application/json'};
    final map = appointment.toJson();
    final body = json.encode(map);

    await http.put(url, body: body, headers: headers);
  }

  static Future<void> deleteAppointment(String appointmentId) async {
    final url = Uri.parse('$apiUrl/appointments/$appointmentId');

    await http.delete(url);
  }
}
