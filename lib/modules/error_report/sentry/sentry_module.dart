import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_advanced_boilerplate/modules/error_report/error_report_service.dart';
import 'package:flutter_advanced_boilerplate/utils/exceptions/api_dio_exception.dart';
import 'package:flutter_advanced_boilerplate/utils/exceptions/custom_exception.dart'; 
import 'package:flutter_advanced_boilerplate/utils/methods/aliases.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryErrorReportService implements ErrorReportService {
  @override
  Future<void> initService() {
    return initializeSentry();
  }

  bool isIgnorableException(dynamic exception) {
    if (exception is DioException) {
      if (exception.type == DioExceptionType.connectionTimeout ||
          exception.type == DioExceptionType.sendTimeout ||
          exception.type == DioExceptionType.receiveTimeout) {
        // ignore network errors
        return true;
      }
    }
    if (exception is CustomException && exception.isIgnorable) {
      return true;
    }
    if (exception is TimeoutException || exception is SocketException) {
      return true;
    }
    return false;
  }

  @override
  Future<void> reportException(
    dynamic exception,
    dynamic stackTrace, {
    String? tag,
    String? hint,
  }) async {
    if (isIgnorableException(exception)) {
      logIt.warn("Ignoring exception", error: exception, stackTrace: stackTrace as StackTrace?);
      return;
    }

    Hint? hintObj;
    String? hint;
    String? tag;

    if (exception is DioException) {
      tag = exception.type.toString();
    }
    if (exception is ApiDioException) {
      hint = exception.apiError;
    }

    if (tag != null || hint != null) {
      hintObj = Hint.withMap({'tag': tag, 'hint': hint});
    }
    logIt.error("Exception", error: exception, stackTrace: stackTrace as StackTrace?);
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      hint: hintObj,
    );
  }

  Future<void> initializeSentry() async {
    final dsn = env.env == 'dev'
        ? 'WRONG_DSN_DISABLES_SENTRY_INITILIZATION'
        : 'ENTER_YOUR_SENTRY_URL';

    await SentryFlutter.init((options) {
      options
        ..dsn = dsn
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        ..tracesSampleRate = 1.0
        ..environment = env.env;
    });
  }
}
