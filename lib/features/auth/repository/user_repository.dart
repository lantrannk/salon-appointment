import '../../../core/storage/user_storage.dart';
import '../model/user.dart';

class UserRepository {
  final userStorage = UserStorage();

  Future<List<User>> getUsers() async {
    final users = await userStorage.getUsers();
    return users;
  }

  Future<void> setUser(User user) async {
    await userStorage.setUser(user);
  }

  Future<User?> getUser() async {
    final user = await userStorage.getUser();
    return user;
  }

  Future<void> removeUser() async {
    await userStorage.removeUser();
  }
}
