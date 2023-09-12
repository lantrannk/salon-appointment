import 'package:http/http.dart' as http;
import 'package:salon_appointment/core/constants/constants.dart';

import 'api_error_message.dart';

class ApiError {
  static final notModifiedError = http.Response(
    ApiErrorMessage.notModified,
    304,
    headers: headers,
  );

  static final badRequestError = http.Response(
    ApiErrorMessage.badRequest,
    400,
    headers: headers,
  );

  static final notFoundError = http.Response(
    ApiErrorMessage.notFound,
    404,
    headers: headers,
  );

  static final gatewayTimeoutError = http.Response(
    ApiErrorMessage.gatewayTimeout,
    504,
    headers: headers,
  );
}
