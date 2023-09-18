import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/auth/api/user_api.dart';

import '../constants/constants.dart';

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
          (_) async => ApiError.notModifiedError,
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
          (_) async => ApiError.badRequestError,
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
          (_) async => ApiError.notFoundError,
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
          (_) async => ApiError.gatewayTimeoutError,
        );

        expect(
          await userApi.getUsers(client),
          ApiErrorMessage.gatewayTimeout,
        );
      },
    );
  });
}
