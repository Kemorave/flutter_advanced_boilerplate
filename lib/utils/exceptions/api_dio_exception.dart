import 'package:dio/dio.dart';

class ApiDioException extends DioException {
  ApiDioException(this.apiError, DioException error)
    : super(
        requestOptions: error.requestOptions,
        response: error.response,
        error: error.error,
        type: error.type,
        stackTrace: error.stackTrace,
      );
  final String apiError;
}
