// lib/core/exceptions/dio_error_handler.dart

import 'package:dio/dio.dart';
import 'api_exception.dart';

class DioErrorHandler {
  static ApiException handle(DioException error) {
    final statusCode = error.response?.statusCode ?? 0;
    final data = error.response?.data;
    final message = _getMessageFromStatusCode(statusCode, data);
    final errorType = _getErrorType(statusCode);

    print('❌ API Error [$statusCode]: $message');
    return ApiException(message, statusCode: statusCode, errorType: errorType);
  }

  static String _getMessageFromStatusCode(int code, dynamic data) {
    final apiMessage = (data is Map<String, dynamic>) ? (data['message'] ?? data['error']) : null;

    switch (code) {
      case 400:
        return apiMessage ?? 'Bad Request';
      case 401:
        return apiMessage ?? 'Unauthorized';
      case 403:
        return apiMessage ?? 'Forbidden';
      case 404:
        return apiMessage ?? 'Not Found';
      case 408:
        return apiMessage ?? 'Request Timeout';
      case 409:
        return apiMessage ?? 'Conflict';
      case 422:
        return apiMessage ?? 'Validation Error';
      case 429:
        return apiMessage ?? 'Too Many Requests';
      case 500:
        return apiMessage ?? 'Internal Server Error';
      case 502:
        return apiMessage ?? 'Bad Gateway';
      case 503:
        return apiMessage ?? 'Service Unavailable';
      case 504:
        return apiMessage ?? 'Gateway Timeout';
      default:
        return apiMessage ?? 'Something went wrong (code $code)';
    }
  }

  static ErrorType _getErrorType(int statusCode) {
    if (statusCode >= 400 && statusCode < 500) {
      if (statusCode == 401) return ErrorType.unauthorized;
      if (statusCode == 403) return ErrorType.forbidden;
      if (statusCode == 404) return ErrorType.notFound;
      if (statusCode == 422) return ErrorType.validation;
      return ErrorType.network;
    }
    if (statusCode >= 500) return ErrorType.server;
    return ErrorType.unknown;
  }
}
