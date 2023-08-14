import 'package:http/http.dart' as http;

import '../../../core/constants/constants.dart';

class UserApi {
  Future<String> getUsers(http.Client client) async {
    final url = Uri.parse('$apiUrl/users');

    final response = await client.get(url);

    return response.body;
  }
}
