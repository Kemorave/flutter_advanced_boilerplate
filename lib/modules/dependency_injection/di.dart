import 'package:flutter_advanced_boilerplate/features/app/blocs/app_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/auth_model.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/env_model.dart';
import 'package:flutter_advanced_boilerplate/features/auth/login/blocs/auth_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/auth/login/networking/auth_repository.dart';
import 'package:flutter_advanced_boilerplate/features/home/networking/home_repository.dart';
import 'package:flutter_advanced_boilerplate/features/profile/networking/profile_repository.dart'; 
import 'package:flutter_advanced_boilerplate/modules/dio/dio_client.dart';
import 'package:flutter_advanced_boilerplate/modules/secure_storage/secure_auth_storage.dart';
import 'package:flutter_advanced_boilerplate/modules/token_refresh/dio_token_refresh.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/d_i_container.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/json_helper.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/permission_helper.dart';
import 'package:flutter_advanced_boilerplate/utils/router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fresh_dio/fresh_dio.dart';

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
  DIContainer.registerSingleton(SecureAuthStorage(const FlutterSecureStorage()) as TokenStorage<AuthModel>);
  DIContainer.registerSingleton(DioTokenRefresh(DIContainer.get()));
  DIContainer.registerSingleton(
     initDioClient(DIContainer.get(), DIContainer.get()),
  );
}


void _registerRepositories() {
  DIContainer.registerSingleton(AuthRepository(DIContainer.get()));
  DIContainer.registerSingleton(HomeRepository());
  DIContainer.registerSingleton(ProfileRepository()); 
  
}

void _registerCubits() {
  DIContainer.registerSingleton(AppCubit()); 
  DIContainer.registerSingleton(AuthCubit( DIContainer.get(), DIContainer.get()));
}
