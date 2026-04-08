import 'dart:async';

import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/user_model.dart';
import 'package:flutter_advanced_boilerplate/features/auth/login/networking/auth_repository.dart';
import 'package:flutter_advanced_boilerplate/modules/dio/interceptors/auth_token_interceptor.dart';
import 'package:flutter_advanced_boilerplate/modules/token_refresh/dio_token_refresh.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository, this._authTokenInterceptor)
    : super(const AuthState.loading());

  final AuthRepository _authRepository;
  final AuthTokenInterceptor _authTokenInterceptor;

  Future<bool> isAuthenticated() async {
    final token = await _authTokenInterceptor.getToken();
    return token != null;
  }

  Future<void> login({
    required String username,
    required String password,
  }) async {
    emit(const AuthState.loading());

    final response = await _authRepository.login(
      username: username,
      password: password,
    );

    await Future.delayed(const Duration(seconds: 2), () {});

    await response.match(
      (alert) async => emit(AuthState.failed(alert: alert)),
      (auth) async => _authTokenInterceptor.setToken(auth),
    );
  }

  Future<void> logOut() async {
    if (state is _AuthAuthenticatedState) {
      final previousState = state;
      emit(const AuthState.loading());

      final tokens = await _authTokenInterceptor.getToken();
      final response = await _authRepository.logout(auth: tokens!);

      await response.match(
        (alert) async {
          emit(AuthState.failed(alert: alert));
          emit(previousState);
        },
        (_) async {
          await _authTokenInterceptor.clearToken();
          Sentry.configureScope((scope) {
            scope.setUser(null);
          });
        },
      );
    }
  }
}
