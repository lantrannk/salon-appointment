import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class UserStorage {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  /// Save a [List] of [String] user encode
  Future<void> setUsers(String users) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(StorageKey.allUsersKey, users);
  }

  /// Returns a [String] of users list from storage
  Future<String?> getUsers() async {
    final SharedPreferences prefs = await _prefs;
    final String? users = prefs.getString(StorageKey.allUsersKey);
    return users;
  }

  /// Save a [String] user encode
  Future<void> setUser(String user) async {
    final SharedPreferences prefs = await _prefs;
    await prefs.setString(StorageKey.userKey, user);
  }

  /// Returns a [String] of user from storage
  Future<String?> getUser() async {
    final SharedPreferences prefs = await _prefs;
    final String? user = prefs.getString(StorageKey.userKey);
    return user;
  }

  /// Remove all storage
  Future<void> clear() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.clear();
  }
}
