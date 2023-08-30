import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:salon_appointment/core/constants/storage_key.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/api/user_api.dart';
import '../../features/auth/model/user.dart';

class UserStorage {
  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  /// Save a [List] of [String] user encode
  Future<void> setUsers() async {
    final SharedPreferences prefs = await _prefs;

    final UserApi userApi = UserApi();
    final String users = await userApi.getUsers(http.Client());

    await prefs.setString(StorageKey.allUsersKey, users);
  }

  /// Returns a [List] of [User] from storage
  Future<List<User>> getUsers() async {
    await setUsers();
    final SharedPreferences prefs = await _prefs;
    final String usersStr = prefs.getString(StorageKey.allUsersKey)!;
    final List<User> users =
        (json.decode(usersStr) as List).map((e) => User.fromJson(e)).toList();

    return users;
  }

  /// Returns a [Map] of a user from storage
  Future<void> setUser(User user) async {
    final SharedPreferences prefs = await _prefs;
    final String userEncode = jsonEncode(user.toJson());
    await prefs.setString(StorageKey.userKey, userEncode);
  }

  /// Returns a [Map] of a user from storage
  Future<User?> getUser() async {
    final SharedPreferences prefs = await _prefs;
    final String? userStr = prefs.getString(StorageKey.userKey);
    return userStr != null ? User.fromJson(jsonDecode(userStr)) : null;
  }

  Future<void> removeUser() async {
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(StorageKey.userKey);
  }
}
