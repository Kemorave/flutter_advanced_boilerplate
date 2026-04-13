import 'package:flutter_advanced_boilerplate/features/app/blocs/app_cubit.dart';
import 'package:flutter_advanced_boilerplate/features/app/models/env_model.dart';
import 'package:flutter_advanced_boilerplate/features/auth/login/blocs/auth_cubit.dart';
import 'package:flutter_advanced_boilerplate/modules/error_report/error_report_service.dart';
import 'package:flutter_advanced_boilerplate/utils/d_i_container.dart';
import 'package:flutter_advanced_boilerplate/utils/helpers/logging_helper.dart';
import 'package:go_router/go_router.dart';

LoggingHelper logIt = LoggingHelper();
EnvModel get env => DIContainer.get<EnvModel>();
GoRouter get appRouter => DIContainer.get<GoRouter>();
AuthCubit get authCubit => DIContainer.get<AuthCubit>();
AppCubit get appCubit => DIContainer.get<AppCubit>();
ErrorReportService get errorReportService => DIContainer.get<ErrorReportService>();
