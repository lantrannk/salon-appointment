import 'dart:io';

import 'package:http/http.dart' as http;

import 'app_exception.dart';

class ExceptionHandlers {
  dynamic getExceptionString(Object error) {
    return (error is SocketException)
        ? ResponseMessage.noInternetConnection
        : (error is ApiException)
            ? error.message
            : ResponseMessage.unknown;
  }
}

dynamic processResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      return response.body;
    case 304: // Not Modified
      throw ApiException(
        code: response.statusCode.toString(),
        message: ResponseMessage.notModified,
      );
    case 400: // Bad request
      throw ApiException(
        code: response.statusCode.toString(),
        message: ResponseMessage.badRequest,
      );
    case 401: // Unauthorized
      throw ApiException(
        code: response.statusCode.toString(),
        message: ResponseMessage.unAuthorized,
      );
    case 403: // Forbidden
      throw ApiException(
        code: response.statusCode.toString(),
        message: ResponseMessage.forbidden,
      );
    case 404: // Not Found
      throw ApiException(
        code: response.statusCode.toString(),
        message: ResponseMessage.notFound,
      );
    case 500: // Internal Server Error
      throw ApiException(
        code: response.statusCode.toString(),
        message: ResponseMessage.internalServerError,
      );
    default:
      throw ApiException(
        code: response.statusCode.toString(),
        message: ResponseMessage.unknown,
      );
  }
}

class ResponseMessage {
  // Api messages
  static const String success = 'Success';
  static const String noContent = 'Success with no content.';
  static const String notModified = 'Not modified, try again later.';
  static const String badRequest = 'Bad request, try again later.';
  static const String forbidden = 'Forbidden request, try again later.';
  static const String unAuthorized = 'User is unauthorized, try again later.';
  static const String notFound = 'URL is not found, try again later';
  static const String internalServerError =
      'Something went wrong, try again later.';
  static const String noInternetConnection =
      'No internet connection.\nPlease check your internet connection.';
  static const String unknown = 'Something went wrong, try again later.';
}
