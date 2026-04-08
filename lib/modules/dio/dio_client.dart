import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/env_model.dart';
import 'package:flutter_advanced_boilerplate/modules/dio/interceptors/api_error_interceptor.dart';
import 'package:flutter_advanced_boilerplate/modules/dio/interceptors/auth_token_interceptor.dart';
import 'package:sentry_dio/sentry_dio.dart';

Dio initDioClient(EnvModel env, AuthTokenInterceptor authTokenInterceptor) {
  final dio = Dio();

  dio.options.baseUrl = env.restApiUrl;
  dio.options.headers['Accept-Language'] = Platform.localeName.substring(0, 2);
  dio.options.connectTimeout = const Duration(seconds: 10);
  dio.options.receiveTimeout = const Duration(seconds: 10);
  dio.interceptors.add(authTokenInterceptor); 
  dio.interceptors.add(ApiErrorInterceptor()); 

  // Sentrie's performance tracing, http breadcrumbs and
  // automatic recording of bad http requests for dio.
  dio.addSentry();

  if (env.debugApiClient) {
    // dio.interceptors.add(
    //   PrettyDioLogger(
    //     requestHeader: true,
    //     requestBody: true,
    //     responseHeader: true,
    //   ),
    // );
  }

  return dio;
}
