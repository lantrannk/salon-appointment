import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/auth/api/user_api.dart';

import '../constants/api_error_message.dart';
import '../constants/api_url.dart';
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
          () => client.get(allUsersUrl),
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
          () => client.get(allUsersUrl),
        ).thenAnswer(
          (_) async => http.Response(
            ApiErrorMessage.notModified,
            304,
          ),
        );

        expect(
          await userApi.getUsers(client),
          ApiErrorMessage.notModified,
        );
      },
    );

    test(
      'get users with error code 400',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(allUsersUrl),
        ).thenAnswer(
          (_) async => http.Response(
            ApiErrorMessage.badRequest,
            400,
          ),
        );

        expect(
          await userApi.getUsers(client),
          ApiErrorMessage.badRequest,
        );
      },
    );

    test(
      'get users with error code 404',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(allUsersUrl),
        ).thenAnswer(
          (_) async => http.Response(
            ApiErrorMessage.notFound,
            404,
          ),
        );

        expect(
          await userApi.getUsers(client),
          ApiErrorMessage.notFound,
        );
      },
    );

    test(
      'get users with error code 504',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        when(
          () => client.get(allUsersUrl),
        ).thenAnswer(
          (_) async => http.Response(
            ApiErrorMessage.gatewayTimeout,
            504,
          ),
        );

        expect(
          await userApi.getUsers(client),
          ApiErrorMessage.gatewayTimeout,
        );
      },
    );
  });
}
