import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/storage/user_storage.dart';
import '../model/user.dart';

class UserRepository {
  static Future<List<User>> load() async {
    final userStorage = UserStorage();
    final users = await userStorage.getUsers();
    return users;
  }

  static Future<void> removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
  }
}
