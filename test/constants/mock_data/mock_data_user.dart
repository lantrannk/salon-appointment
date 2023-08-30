import 'package:salon_appointment/features/auth/model/user.dart';

class MockDataUser {
  static const String allUsersJson =
      '[{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"},{"phoneNumber":"0905999222","name":"Carol Williams","avatar":"https://assets.vogue.in/photos/611cf20c8733032148fe1b06/2:3/w_2560%2Cc_limit/Slide%25201.jpg","password":"123456","isAdmin":false,"id":"2"},{"phoneNumber":"0934125689","name":"Hailee Steinfeld","avatar":"https://glints.com/vn/blog/wp-content/uploads/2022/08/co%CC%82ng-vie%CC%A3%CC%82c-beauty-blogger-819x1024.jpg","password":"123456","isAdmin":false,"id":"3"},{"phoneNumber":"0902335577","name":"Ruby Nguyen","avatar":"https://studiochupanhdep.com//Upload/Images/Album/anh-beauty-11.jpg","password":"123456","isAdmin":false,"id":"4"},{"phoneNumber":"070456123","name":"Elizabeth Taylor","avatar":"https://www.m1-beauty.de/assets/images/f/Ronja_VorherNachher_45Grad_2-c7cc48ca.jpg","password":"123456","isAdmin":false,"id":"5"}]';

  static const String adminUserJson =
      '{"phoneNumber":"0794542105","name":"Lan Tran","avatar":"https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg","password":"123456","isAdmin":true,"id":"1"}';

  static const String customerUserJson =
      '{"phoneNumber":"0905999222","name":"Carol Williams","avatar":"https://assets.vogue.in/photos/611cf20c8733032148fe1b06/2:3/w_2560%2Cc_limit/Slide%25201.jpg","password":"123456","isAdmin":false,"id":"2"}';

  static final User adminUser = User.fromJson(const {
    'phoneNumber': '0794542105',
    'name': 'Lan Tran',
    'avatar':
        'https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg',
    'password': '123456',
    'isAdmin': true,
    'id': '1'
  });

  static final User customerUser = User.fromJson(const {
    'phoneNumber': '0905999222',
    'name': 'Carol Williams',
    'avatar':
        'https://assets.vogue.in/photos/611cf20c8733032148fe1b06/2:3/w_2560%2Cc_limit/Slide%25201.jpg',
    'password': '123456',
    'isAdmin': false,
    'id': '2',
  });

  static final List<User> allUsers = [
    {
      'phoneNumber': '0794542105',
      'name': 'Lan Tran',
      'avatar':
          'https://bazaarvietnam.vn/wp-content/uploads/2020/02/selena-gomez-rare-beauty-launch-03-09-2020-00-thumb.jpg',
      'password': '123456',
      'isAdmin': true,
      'id': '1'
    },
    {
      'phoneNumber': '0905999222',
      'name': 'Carol Williams',
      'avatar':
          'https://assets.vogue.in/photos/611cf20c8733032148fe1b06/2:3/w_2560%2Cc_limit/Slide%25201.jpg',
      'password': '123456',
      'isAdmin': false,
      'id': '2'
    },
    {
      'phoneNumber': '0934125689',
      'name': 'Hailee Steinfeld',
      'avatar':
          'https://glints.com/vn/blog/wp-content/uploads/2022/08/co%CC%82ng-vie%CC%A3%CC%82c-beauty-blogger-819x1024.jpg',
      'password': '123456',
      'isAdmin': false,
      'id': '3'
    },
    {
      'phoneNumber': '0902335577',
      'name': 'Ruby Nguyen',
      'avatar':
          'https://studiochupanhdep.com//Upload/Images/Album/anh-beauty-11.jpg',
      'password': '123456',
      'isAdmin': false,
      'id': '4'
    },
    {
      'phoneNumber': '070456123',
      'name': 'Elizabeth Taylor',
      'avatar':
          'https://www.m1-beauty.de/assets/images/f/Ronja_VorherNachher_45Grad_2-c7cc48ca.jpg',
      'password': '123456',
      'isAdmin': false,
      'id': '5'
    },
  ].map((e) => User.fromJson(e)).toList();
}
