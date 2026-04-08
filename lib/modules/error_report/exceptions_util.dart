import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart'; 
import 'package:flutter_advanced_boilerplate/i18n/strings.g.dart';
import 'package:flutter_advanced_boilerplate/utils/exceptions/api_dio_exception.dart'; 

String? getExceptionMessage(dynamic exception)  {
  if (exception == null) {
    return t.core.errors.others.an_unknown_error;
  }

  if (exception is DioException) {
    return _getDioExceptionMessage(exception);
  }

  return exception?.toString();
}

String? _getDioExceptionMessage(DioException exception)  {
  var message = '';
  String getMessage(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
        return t.core.errors.others.communication_error;
      case DioExceptionType.sendTimeout:
        return t.core.errors.others.communication_error;
      case DioExceptionType.receiveTimeout:
        return t.core.errors.others.communication_error;
      case DioExceptionType.badCertificate:
        return t.core.errors.others.communication_error;
      case DioExceptionType.badResponse:
        return t.core.errors.others.server_failure;
      case DioExceptionType.cancel:
        return t.core.errors.others.something_went_wrong;
      case DioExceptionType.connectionError:
        return t.core.errors.others.no_internet_connection;
      case DioExceptionType.unknown:
        return t.core.errors.others.an_unknown_error;
      default:
        return t.core.errors.others.an_unknown_error;
    }
  }
  message = getMessage(exception);
  if (exception is ApiDioException && kDebugMode) {
    message += '\n${exception.apiError}';
  }
  return message;
}


