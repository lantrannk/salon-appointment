import 'dart:convert';

import 'package:example/data/models/user.dart';
import 'package:http/http.dart' as http;

class HttpUsers {
  static const String url = 'https://jsonplaceholder.typicode.com/users';

  Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final body = json.decode(response.body) as List;

      return body.map((dynamic json) {
        final map = json as Map<String, dynamic>;

        return User.fromJson(map);
      }).toList();
    }

    throw Exception('error fetching users');
  }
}
