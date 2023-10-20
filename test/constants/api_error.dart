import 'package:http/http.dart' as http;
import 'package:salon_appointment/core/constants/constants.dart';
import 'package:salon_appointment/core/error_handle/exception_handler.dart';

class ApiError {
  static final notModifiedError = http.Response(
    ResponseMessage.notModified,
    304,
    headers: headers,
  );

  static final badRequestError = http.Response(
    ResponseMessage.badRequest,
    400,
    headers: headers,
  );

  static final notFoundError = http.Response(
    ResponseMessage.notFound,
    404,
    headers: headers,
  );

  static final internalServerError = http.Response(
    ResponseMessage.internalServerError,
    500,
    headers: headers,
  );
}
