import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

class DIContainer {
  DIContainer._(); // private constructor to prevent instantiation

  // ==========================
  // REGISTER METHODS
  // ==========================

 

  /// Register a singleton
  static void registerSingleton<T extends Object>(T instance) {
    if (!getIt.isRegistered<T>()) {
      getIt.registerSingleton<T>(instance);
    }
  }

  /// Register a lazy singleton
  static void registerLazySingleton<T extends Object>(T Function() factoryFunc) {
    if (!getIt.isRegistered<T>()) {
      getIt.registerLazySingleton<T>(factoryFunc);
    }
  }

  /// Register a factory (new instance every call)
  static void registerFactory<T extends Object>(T Function() factoryFunc) {
    if (!getIt.isRegistered<T>()) {
      getIt.registerFactory<T>(factoryFunc);
    }
  }

  // ==========================
  // GETTERS
  // ==========================

  /// Retrieve an instance
  static T get<T extends Object>() {
    return getIt<T>();
  }

  /// Check if a type is registered
  static bool isRegistered<T extends Object>() {
    return getIt.isRegistered<T>();
  }

  /// Reset all registrations (for testing or app restart)
  static Future<void> reset() async {
    await getIt.reset();
  }
}
