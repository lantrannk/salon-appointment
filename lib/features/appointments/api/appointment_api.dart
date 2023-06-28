import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/constants.dart';
import '../model/appointment.dart';

class AppointmentApi {
  static const String baseUrl = '$apiUrl/appointments';

  static Future<String> getAppointments() async {
    final url = Uri.parse(baseUrl);

    final response = await http.get(url);

    return response.body;
  }

  static Future<void> addAppointment(Appointment appointment) async {
    final url = Uri.parse(baseUrl);
    final headers = {'Content-Type': 'application/json'};
    final map = appointment.toJson();
    final body = json.encode(map);

    await http.post(url, body: body, headers: headers).then((response) {});
  }

  static Future<void> updateAppointment(Appointment appointment) async {
    final url = Uri.parse('$baseUrl/${appointment.id}');
    final headers = {'Content-Type': 'application/json'};
    final map = appointment.toJson();
    final body = json.encode(map);

    await http.put(url, body: body, headers: headers);
  }

  static Future<void> deleteAppointment(String appointmentId) async {
    final url = Uri.parse('$baseUrl/$appointmentId');

    await http.delete(url);
  }
}
