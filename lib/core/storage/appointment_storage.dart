import 'package:salon_appointment/core/constants/storage_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class AppointmentStorage {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  /// Save a [String] of appointments list encode
  Future<void> setAppointments(String appointments) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(StorageKey.allAppointmentsKey, appointments);
  }

  /// Returns a [String] of appointments list from storage
  Future<String?> getAllAppointments() async {
    final SharedPreferences prefs = await _prefs;
    final String? appointments = prefs.getString(
      StorageKey.allAppointmentsKey,
    );
    return appointments;
  }
}
