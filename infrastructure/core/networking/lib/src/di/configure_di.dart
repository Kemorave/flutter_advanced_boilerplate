// Copyright 2024 Fikret Şengül. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import 'package:deps/packages/dio.dart';
import 'package:deps/packages/get_it.dart';
import 'package:deps/packages/injectable.dart';
import 'package:deps/packages/internet_connection_checker_plus.dart';

import './configure_di.config.dart';

/// Initializes and configures the dependency injection system for the application.
///
/// Sets up the `GetIt` locator instance with configurations generated by the `injectable` package.
/// This function should be called early in the app's lifecycle to ensure all dependencies
/// are properly registered and available.
///
/// [di]: The `GetIt` instance used for dependency injection.
/// [env]: A string representing the current environment (e.g., 'dev', 'prod').
@InjectableInit(initializerName: 'init')
void configureDependencies(GetIt di, String env) {
  di.init(environment: env);
}

/// A module for providing an instance of `Dio` for HTTP requests.
///
/// This module is used by the `injectable` package to generate code for
/// dependency injection. It defines how an instance of `Dio` should be
/// created and provided for making network requests.
@module
abstract class DioModule {
  /// Provides a configured instance of `Dio`.
  Dio get dio => Dio();
}

/// A module for providing an instance of `InternetConnection`.
///
/// This module uses `internet_connection_checker_plus` package to check
/// the internet connectivity status. It's used for generating code for
/// dependency injection, providing an instance of `InternetConnection`.
@module
abstract class InternetConnectionModule {
  /// Provides an instance of `InternetConnection`.
  InternetConnection get internetConnection => InternetConnection();
}
