import 'package:flutter_advanced_boilerplate/i18n/strings.g.dart';
import 'package:flutter_advanced_boilerplate/modules/dio/dio_exception_handler.dart';
import 'package:flutter_advanced_boilerplate/modules/error_report/exceptions_util.dart';
import 'package:flutter_advanced_boilerplate/utils/methods/aliases.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'alert_model.freezed.dart';

enum AlertType {
  constructive,
  destructive,
  error,
  notification,
  exception,
  quiet
}

@freezed
abstract class  AlertModel with _$AlertModel {
  const factory AlertModel({
    required String message,
    required AlertType type,
     dynamic exception,
     StackTrace? stackTrace,
    @Default(false) bool translatable,
    int? code,
  }) = _AlertModel;

  factory AlertModel.alert({
    required String message,
    required AlertType type,
    bool translatable = false,
    int? code,
  }) {
    if (type == AlertType.error) {
      logIt.error(message);
    }

    return AlertModel(
      message: message,
      type: type,
      translatable: translatable,
      code: code,
    );
  }

  factory AlertModel.exception({
    required dynamic exception,
    required StackTrace? stackTrace,
  }) { 

   final message = getExceptionMessage(exception);

    return AlertModel(
      message: message?? t.core.errors.others.an_unknown_error,
      type: AlertType.exception, 
      exception: exception,
      stackTrace: stackTrace,
    );
  }

  factory AlertModel.initial() =>
      AlertModel.alert(message: '', type: AlertType.quiet);

  factory AlertModel.quiet() {
    return const AlertModel(
      message: '',
      type: AlertType.quiet,
    );
  }
}
