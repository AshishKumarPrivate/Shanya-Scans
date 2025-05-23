// lib/core/exceptions/api_exception.dart

class ApiException implements Exception {
  final String message;
  final int statusCode;
  final ErrorType errorType;

  ApiException(this.message, {
    this.statusCode = 0,
    this.errorType = ErrorType.unknown,
  });

  @override
  String toString() => 'ApiException: $message (code: $statusCode)';
}
enum ErrorType {
  network,
  unauthorized,
  forbidden,
  notFound,
  validation,
  server,
  timeout,
  unknown,
}