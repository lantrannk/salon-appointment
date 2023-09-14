import 'package:flutter_test/flutter_test.dart';
import 'package:salon_appointment/features/auth/model/user.dart';

import '../constants/mock_data/mock_data.dart';

void main() {
  late User user;
  late Map<String, dynamic> userJson;

  setUpAll(() {
    user = MockDataUser.adminUser;
    userJson = MockDataUser.adminUserToJson;
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
