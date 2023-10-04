import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'app_exception.dart';

class ExceptionHandlers {
  dynamic getExceptionString(Object error) {
    if (error is SocketException) {
      return 'No internet connection.';
    } else if (error is HttpException) {
      return 'HTTP error occurred.';
    } else if (error is FormatException) {
      return 'Invalid data format.';
    } else if (error is TimeoutException) {
      return 'Request timed out.';
    } else if (error is BadRequestException) {
      return error.message.toString();
    } else if (error is UnAuthorizedException) {
      return error.message.toString();
    } else if (error is NotFoundException) {
      return error.message.toString();
    } else if (error is FetchDataException) {
      return error.message.toString();
    } else {
      return 'Unknown error occurred.';
    }
  }
}

dynamic processResponse(http.Response response) {
  switch (response.statusCode) {
    case 200:
      return response.body;
    case 400: //Bad request
      throw BadRequestException(jsonDecode(response.body)['message']);
    case 401: //Unauthorized
      throw UnAuthorizedException(jsonDecode(response.body)['message']);
    case 403: //Forbidden
      throw UnAuthorizedException(jsonDecode(response.body)['message']);
    case 404: //Resource Not Found
      throw NotFoundException(jsonDecode(response.body)['message']);
    case 500: //Internal Server Error
    default:
      throw FetchDataException('Something went wrong! ${response.statusCode}');
  }
}
