import 'package:http/http.dart' as http;

import '../../../core/constants/constants.dart';
import '../../../core/error_handle/exception_handler.dart';

class UserApi {
  Future<String> getUsers(http.Client client) async {
    final url = Uri.parse(userUrl);

    try {
      final response = await client.get(url);

      return processResponse(response);
    } catch (e) {
      throw ExceptionHandlers().getExceptionString(e);
    }
  }
}
