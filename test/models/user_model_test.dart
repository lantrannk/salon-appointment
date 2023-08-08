import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/features/auth/model/user.dart';

void main() {
  late User user;
  late Map<String, dynamic> userJson;

  setUpAll(() {
    user = const User(
      id: '1',
      name: 'Lan Tran',
      phoneNumber: '0794542105',
      avatar:
          'https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg',
      password: '123456',
      isAdmin: true,
    );

    userJson = {
      'phoneNumber': '0794542105',
      'name': 'Lan Tran',
      'avatar':
          'https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg',
      'password': '123456',
      'isAdmin': true,
      'id': '1'
    };
  });

  test('test user model - from json', () {
    final userFromJson = User.fromJson(userJson);

    expect(userFromJson, user);
  });

  test('test user model - to json', () {
    final userToJson = user.toJson();

    expect(userToJson, userJson);
  });
}
