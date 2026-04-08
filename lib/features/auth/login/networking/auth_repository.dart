import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/auth_model.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/user_model.dart';
import 'package:flutter_advanced_boilerplate/utils/exceptions/custom_exception.dart';
import 'package:flutter_advanced_boilerplate/utils/methods/shortcuts.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepository {
  AuthRepository(this._dioClient);

  // ignore: unused_field
  final Dio _dioClient;

  Future<Either<AlertModel, AuthModel>> login({
    required String username,
    required String password,
  }) async {
    // Normally you should wrap the request with dioExceptionHandler.
    // Where error is catched and the returned error message is parsed to
    // create alert. But for the demo I will create alert without localization.
    return runAndReport(
      () async {
        final isIdPwCorrect = username == 'test' && password == 'test';

        if (isIdPwCorrect) {
          final user = UserModel.initial();
          final auth = AuthModel(
            tokenType: 'Bearer ',
            accessToken: '',
            refreshToken: '',
            user: user,
          );

          Timer(const Duration(seconds: 3), () {});

          return auth;
        } else {
          throw CustomException(
            message: 'API error NO AUTH',
            isIgnorable: true,
          );
        }
      },
      (e, s) => AlertModel.alert(
        message:
            'ID or PW is wrong. Please enter test for demo to both fields.',
        type: AlertType.destructive,
      ),
    );
  }

  Future<Either<AlertModel, void>> logout({required AuthModel auth}) async {
    try {
      // TODO(fikretsengul): Implement custom logout operation with auth model.

      return right(null);
    } catch (e) {
      return left(AlertModel.quiet());
    }
  }
}
