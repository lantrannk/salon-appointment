import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/constants.dart';
import '../model/appointment.dart';

class AppointmentApi {
  const AppointmentApi(this.client);

  final http.Client client;

  Future<String> getAppointments() async {
    final url = Uri.parse(appointmentUrl);

    final response = await client.get(url);

    return response.body;
  }

  Future<String> addAppointment(Appointment appointment) async {
    final url = Uri.parse(appointmentUrl);
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
    final url = Uri.parse('$appointmentUrl/${appointment.id}');
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
    final url = Uri.parse('$appointmentUrl/$appointmentId');

    final response = await client.delete(url);

    return response.body;
  }
}
