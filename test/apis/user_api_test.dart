import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/auth/api/user_api.dart';

import '../mock_data/mock_data.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late http.Client client;
  late UserApi userApi;

  setUpAll(() {
    client = MockClient();
    userApi = UserApi();
  });

  group('test users api -', () {
    test(
      'get users then return a encoded string of users list',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(
            Uri.parse('https://63ab8e97fdc006ba60609b9b.mockapi.io/users'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            MockDataUser.allUsersJson,
            200,
          ),
        );

        expect(await userApi.getUsers(client), MockDataUser.allUsersJson);
      },
    );

    test(
      'get users with error code 304',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(
            Uri.parse('https://63ab8e97fdc006ba60609b9b.mockapi.io/users'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            'Not Modified',
            304,
          ),
        );

        expect(
          await userApi.getUsers(client),
          'Not Modified',
        );
      },
    );

    test(
      'get users with error code 400',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(
            Uri.parse('https://63ab8e97fdc006ba60609b9b.mockapi.io/users'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            'Bad Request',
            400,
          ),
        );

        expect(
          await userApi.getUsers(client),
          'Bad Request',
        );
      },
    );

    test(
      'get users with error code 404',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(
            Uri.parse('https://63ab8e97fdc006ba60609b9b.mockapi.io/users'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            'Not Found',
            404,
          ),
        );

        expect(
          await userApi.getUsers(client),
          'Not Found',
        );
      },
    );

    test(
      'get users with error code 504',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(
            Uri.parse('https://63ab8e97fdc006ba60609b9b.mockapi.io/users'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            'Gateway Timeout',
            504,
          ),
        );

        expect(
          await userApi.getUsers(client),
          'Gateway Timeout',
        );
      },
    );
  });
}
