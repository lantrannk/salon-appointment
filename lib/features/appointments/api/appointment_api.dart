import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/constants.dart';
import '../model/appointment.dart';

class AppointmentApi {
  const AppointmentApi(this.client);

  final http.Client client;

  static const String baseUrl = '$apiUrl/appointments';

  Future<String> getAppointments() async {
    final url = Uri.parse(baseUrl);

    final response = await client.get(url);

    return response.body;
  }

  Future<String> addAppointment(Appointment appointment) async {
    final url = Uri.parse(baseUrl);
    final headers = {'Content-Type': 'application/json'};
    final map = appointment.toJson();
    final body = json.encode(map);

    final response = await client.post(
      url,
      body: body,
      headers: headers,
    );

    return response.body;
  }

  Future<String> updateAppointment(Appointment appointment) async {
    final url = Uri.parse('$baseUrl/${appointment.id}');
    final headers = {'Content-Type': 'application/json'};
    final map = appointment.toJson();
    final body = json.encode(map);

    final response = await client.put(
      url,
      body: body,
      headers: headers,
    );

    return response.body;
  }

  Future<String> deleteAppointment(String appointmentId) async {
    final url = Uri.parse('$baseUrl/$appointmentId');

    final response = await client.delete(url);

    return response.body;
  }
}
