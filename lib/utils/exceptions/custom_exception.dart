class CustomException implements Exception {

  CustomException({this.message, this.isIgnorable = false});
  final String? message;
  final bool isIgnorable;
}
