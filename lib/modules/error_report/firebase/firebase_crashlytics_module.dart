// import 'dart:async';

// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter_advanced_boilerplate/modules/error_report/error_report_service.dart';
// import 'package:flutter_advanced_boilerplate/utils/methods/aliases.dart';

// class FirebaseCrashlyticsErrorReportService implements ErrorReportService {
//   @override
//   Future<void> initService() async { 
//     await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
 
//     await FirebaseCrashlytics.instance.setCustomKey('environment', env.env);
//   }

//   @override
//   Future<void> reportException(
//     exception,
//     stackTrace, {
//     String? tag,
//     String? hint,
//   }) async { 
//     if (tag != null) {
//       await FirebaseCrashlytics.instance.setCustomKey('tag', tag);
//     }
//     if (hint != null) {
//       await FirebaseCrashlytics.instance.setCustomKey('hint', hint);
//     }
 
//     await FirebaseCrashlytics.instance.recordError(
//       exception,
//       stackTrace is StackTrace ? stackTrace : null,
//       reason: hint,
//     );
//   }
// }
