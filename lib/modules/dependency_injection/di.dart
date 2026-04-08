import 'package:flutter_advanced_boilerplate/features/app/blocs/app_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/env_model.dart';
import 'package:flutter_advanced_boilerplate/features/auth/login/blocs/auth_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/auth/login/networking/auth_repository.dart';
import 'package:flutter_advanced_boilerplate/features/home/blocs/home_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/home/networking/home_repository.dart';
import 'package:flutter_advanced_boilerplate/features/profile/blocs/profile_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/profile/networking/profile_repository.dart';
import 'package:flutter_advanced_boilerplate/modules/dio/dio_client.dart';
import 'package:flutter_advanced_boilerplate/modules/dio/interceptors/auth_token_interceptor.dart';
import 'package:flutter_advanced_boilerplate/modules/error_report/error_report_service.dart';
import 'package:flutter_advanced_boilerplate/modules/error_report/sentry/sentry_module.dart';
import 'package:flutter_advanced_boilerplate/modules/secure_storage/secure_auth_storage.dart';
import 'package:flutter_advanced_boilerplate/modules/token_refresh/dio_token_refresh.dart';
import 'package:flutter_advanced_boilerplate/utils/d_i_container.dart';
import 'package:flutter_advanced_boilerplate/utils/router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future<void> injectContainer({bool backgroundOnly = false}) async {
  await _registerCore();
  _registerRepositories();
  if (!backgroundOnly) {
    DIContainer.registerSingleton(initGoRouter());
    _registerCubits();
  }
}

Future<void> _registerCore() async {
  DIContainer.registerSingleton(await EnvModel.create());
  DIContainer.registerSingleton<ErrorReportService>(
    SentryErrorReportService() as ErrorReportService,
  );

  final secureStorage = SecureAuthStorage(const FlutterSecureStorage());
  DIContainer.registerSingleton(secureStorage);

  final authTokenInterceptor = AuthTokenInterceptor(
    const FlutterSecureStorage(),
  );
  DIContainer.registerSingleton(authTokenInterceptor);

  DIContainer.registerSingleton(
    initDioClient(DIContainer.get(), authTokenInterceptor),
  );
}

void _registerRepositories() {
  DIContainer.registerSingleton(AuthRepository(DIContainer.get()));
  DIContainer.registerSingleton(HomeRepository());
  DIContainer.registerSingleton(ProfileRepository());
}

void _registerCubits() {
  DIContainer.registerSingleton(AppCubit());
  DIContainer.registerSingleton(
    AuthCubit(DIContainer.get(), DIContainer.get()),
  );
  DIContainer.registerFactory(() => HomeCubit(DIContainer.get()));
  DIContainer.registerFactory(() => ProfileCubit(DIContainer.get()));
}
