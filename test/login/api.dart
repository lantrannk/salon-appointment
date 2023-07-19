import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:salon_appointment/features/auth/api/user_api.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  group('test users api -', () {
    test(
      'get users then return a encoded string of users list',
      timeout: const Timeout(Duration(seconds: 5)),
      () async {
        final client = MockClient();
        final userApi = UserApi();
        const expectedData =
            '[{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"},{"phoneNumber":"0905999222","name":"Carol Williams","avatar":"https://assets.vogue.in/photos/611cf20c8733032148fe1b06/2:3/w_2560%2Cc_limit/Slide%25201.jpg","password":"123456","isAdmin":false,"id":"2"},{"phoneNumber":"0934125689","name":"Hailee Steinfeld","avatar":"https://glints.com/vn/blog/wp-content/uploads/2022/08/co%CC%82ng-vie%CC%A3%CC%82c-beauty-blogger-819x1024.jpg","password":"123456","isAdmin":false,"id":"3"},{"phoneNumber":"0902335577","name":"Ruby Nguyen","avatar":"https://studiochupanhdep.com//Upload/Images/Album/anh-beauty-11.jpg","password":"123456","isAdmin":false,"id":"4"},{"phoneNumber":"070456123","name":"Elizabeth Taylor","avatar":"https://www.m1-beauty.de/assets/images/f/Ronja_VorherNachher_45Grad_2-c7cc48ca.jpg","password":"123456","isAdmin":false,"id":"5"}]';

        when(
          () => client.get(
            Uri.parse('https://63ab8e97fdc006ba60609b9b.mockapi.io/users'),
          ),
        ).thenAnswer(
          (_) async => http.Response(
            expectedData,
            200,
          ),
        );

        expect(await userApi.getUsers(client), expectedData);
      },
    );
  });
}
