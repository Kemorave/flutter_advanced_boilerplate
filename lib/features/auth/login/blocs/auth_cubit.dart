import 'dart:async';

import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/user_model.dart';
import 'package:flutter_advanced_boilerplate/features/auth/login/networking/auth_repository.dart';
import 'package:flutter_advanced_boilerplate/modules/token_refresh/dio_token_refresh.dart';
import 'package:flutter_advanced_boilerplate/utils/methods/aliases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:fresh_dio/fresh_dio.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

part 'auth_cubit.freezed.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository, this._dioTokenRefresh)
    : super(const AuthState.loading()) {
    _dioTokenRefresh.fresh.authenticationStatus.listen((event) async {
      if (event == AuthenticationStatus.authenticated) {
        final auth = await _dioTokenRefresh.fresh.token;
        emit(AuthState.authenticated(user: auth!.user));
      } else if (event == AuthenticationStatus.unauthenticated) {
        emit(const AuthState.unauthenticated());
      }
      appRouter.refresh();
    });
  }

  final AuthRepository _authRepository;
  final DioTokenRefresh _dioTokenRefresh;

  Future<bool> isAuthenticated() async {
    final token = await _dioTokenRefresh.fresh.token;
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
      (auth) async => _dioTokenRefresh.fresh.setToken(auth),
    );
  }

  Future<void> logOut() async {
    if (state is _AuthAuthenticatedState) {
      final previousState = state;
      emit(const AuthState.loading());

      final tokens = await _dioTokenRefresh.fresh.token;
      final response = await _authRepository.logout(auth: tokens!);

      await response.match(
        (alert) async {
          emit(AuthState.failed(alert: alert));
          emit(previousState);
        },
        (_) async {
          await _dioTokenRefresh.fresh.clearToken();
          Sentry.configureScope((scope) {
            scope.setUser(null);
          });
        },
      );
    }
  }
}
