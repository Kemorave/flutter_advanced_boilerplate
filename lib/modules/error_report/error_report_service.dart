  
abstract class ErrorReportService {
  Future<void> reportException(dynamic exception, dynamic stackTrace,{ String? tag, String? hint});
  Future<void> initService();
}
