import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/storage/user_storage.dart';
import '../api/user_api.dart';
import '../model/user.dart';

class UserRepository {
  final UserStorage userStorage = UserStorage();
  final UserApi userApi = UserApi();

  /// Save a [List] of [String] user encode to storage
  Future<void> setUsers() async {
    final String users = await userApi.getUsers(http.Client());
    await userStorage.setUsers(users);
  }

  /// Returns a [List] of [User] from storage
  Future<List<User>> getUsers() async {
    await setUsers();
    final String? usersStr = await userStorage.getUsers();
    final List<User> users =
        (json.decode(usersStr!) as List).map((e) => User.fromJson(e)).toList();

    return users;
  }

  /// Returns a [Map] of a user from storage
  Future<void> setUser(User user) async {
    final String userStr = jsonEncode(user.toJson());
    await userStorage.setUser(userStr);
  }

  /// Returns a [Map] of a user from storage
  Future<User?> getUser() async {
    final user = await userStorage.getUser();
    return user != null ? User.fromJson(jsonDecode(user)) : null;
  }

  Future<void> clearStorage() async {
    await userStorage.clear();
  }
}
