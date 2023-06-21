import 'package:http/http.dart' as http;

import '../../../core/constants/constants.dart';

class UserApi {
  static Future<String> getUsers() async {
    final url = Uri.parse('$apiUrl/users');

    final response = await http.get(url);

    return response.body;
  }
}
