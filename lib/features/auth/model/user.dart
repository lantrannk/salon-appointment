import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.name,
    required this.phoneNumber,
    required this.avatar,
    required this.password,
    required this.isAdmin,
  });

  factory User.fromJson(Map<String, dynamic> user) {
    return User(
      id: user['id'] as String,
      name: user['name'] as String,
      phoneNumber: user['phoneNumber'] as String,
      avatar: user['avatar'] as String,
      password: user['password'] as String,
      isAdmin: user['isAdmin'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'avatar': avatar,
        'password': password,
        'isAdmin': isAdmin,
      };

  final String id;
  final String name;
  final String phoneNumber;
  final String avatar;
  final String password;
  final bool isAdmin;

  @override
  List<Object?> get props => [id, name, phoneNumber, password, avatar, isAdmin];
}
