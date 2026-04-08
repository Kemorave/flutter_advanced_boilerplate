import 'package:flutter_advanced_boilerplate/features/app/models/alert_model.dart';
import 'package:fpdart/fpdart.dart';

abstract class ErrorReportService {
  Future<void> reportException(dynamic exception, dynamic stackTrace,{ String? tag, String? hint});
  Future<void> initService();
}
