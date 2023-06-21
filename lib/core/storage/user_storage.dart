import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/auth/api/user_api.dart';
import '../../features/auth/model/user.dart';

class UserStorage {
  /// Save a [List] of [String] user encode
  static Future<void> setUsers() async {
    final String users = await UserApi.getUsers();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('users', users);
  }

  /// Returns a [List] of [User] from storage
  static Future<List<User>> getUsers() async {
    await setUsers();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String usersStr = prefs.getString('users')!;
    final List<User> users =
        (json.decode(usersStr) as List).map((e) => User.fromJson(e)).toList();

    return users;
  }

  /// Returns a [Map] of a user from storage
  static Future<void> setUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userEncode = jsonEncode(user.toJson());
    await prefs.setString('user', userEncode);
  }

  /// Returns a [Map] of a user from storage
  static Future<Map<String, dynamic>> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userStr = prefs.getString('user') ?? '{}';
    return jsonDecode(userStr);
  }
}
