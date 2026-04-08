import 'dart:convert';

import 'package:dio/dio.dart'; 
import 'package:flutter_advanced_boilerplate/utils/exceptions/api_dio_exception.dart';
import 'package:fpdart/fpdart.dart';

class ApiErrorInterceptor extends Interceptor {
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    Either.tryCatch(() {
      if (err.response != null &&
          err.response!.statusCode != null &&
          (err.response!.statusCode! == 400 ||
              err.response!.statusCode! == 404)) {
        final message =
            json.decode(err.response.toString()) as Map<String, dynamic>;
        final errors = json.decode(message['detail'] as String) as List<String>;
        final error = errors.first;

        return handler.reject(
          ApiDioException(
             error,err
          ),
        );
      }
    }, (e, s) => handler.reject(err));
  }
}
