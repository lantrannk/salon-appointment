import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/constants.dart';
import '../model/appointment.dart';

class AppointmentApi {
  final String baseUrl = '$apiUrl/appointments';

  Future<String> getAppointments(http.Client client) async {
    final url = Uri.parse(baseUrl);

    final response = await client.get(url);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      return '';
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    final url = Uri.parse(baseUrl);
    final headers = {'Content-Type': 'application/json'};
    final map = appointment.toJson();
    final body = json.encode(map);

    await http.post(url, body: body, headers: headers).then((response) {});
  }

  Future<void> updateAppointment(Appointment appointment) async {
    final url = Uri.parse('$baseUrl/${appointment.id}');
    final headers = {'Content-Type': 'application/json'};
    final map = appointment.toJson();
    final body = json.encode(map);

    await http.put(url, body: body, headers: headers);
  }

  Future<void> deleteAppointment(String appointmentId) async {
    final url = Uri.parse('$baseUrl/$appointmentId');

    await http.delete(url);
  }
}
