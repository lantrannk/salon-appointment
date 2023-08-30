import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_key.dart';

class AppointmentStorage {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  /// Save a [String] of appointments list encode
  Future<void> setAppointments(String appointmentsStr) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(StorageKey.allAppointmentsKey, appointmentsStr);
  }

  /// Returns a [String] of appointments list from storage
  Future<String?> getAllAppointments() async {
    final SharedPreferences prefs = await _prefs;
    final String? appointmentsStr = prefs.getString(
      StorageKey.allAppointmentsKey,
    );
    return appointmentsStr;
  }
}
