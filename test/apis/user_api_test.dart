import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/auth/api/user_api.dart';

import '../expect_data/expect_data.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('test users api -', () {
    test(
      'get users then return a encoded string of users list',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        final client = MockClient();
        final userApi = UserApi();

        when(
          () => client.get(
            Uri.parse('https://63ab8e97fdc006ba60609b9b.mockapi.io/users'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            UserExpect.allUsersEncoded,
            200,
          ),
        );

        expect(await userApi.getUsers(client), UserExpect.allUsersEncoded);
      },
    );
  });
}
