import 'package:dio/dio.dart';

class ApiErrorHandler {
  /// Handles all DioException errors and extracts meaningful messages
  static String handleError(DioException error) {
    if (error.response != null) {
      return _handleHttpResponse(error.response!);
    } else {
      return _handleDioException(error);
    }
  }

  /// Extracts error message from HTTP response
  static String _handleHttpResponse(Response response) {
    final statusCode = response.statusCode ?? 500;
    final responseData = response.data;
    // ✅ If response is a String (e.g., "Bad Request"), return it directly
    if (responseData is String) {
      return responseData;
    }
    // Check if response contains a JSON error message
    if (responseData is Map<String, dynamic> && responseData.containsKey("message")) {
      return responseData["message"];
    } else if (responseData is String) {
      return responseData; // Plain text error response
    }

    // Handle common HTTP status codes
    switch (statusCode) {
      case 400:
        return "Invalid request. Please check your input.";
      case 401:
        return "Unauthorized access. Please login again.";
      case 403:
        return "Forbidden request. You don't have permission.";
      case 404:
        return "Requested resource not found.";
      case 409:
        return "Conflict: The request could not be completed due to a conflict.";
      case 422:
        return "Validation error: Some fields are incorrect.";
      case 429:
        return "Too many requests. Please try again later.";
      case 500:
        return "Internal Server Error. Please try again later.";
      case 503:
        return "Service unavailable. Please try again later.";
      default:
        return "Unexpected error occurred. Status Code: $statusCode";
    }
  }

  /// Handles DioException when there's no HTTP response
  static String _handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout. Please check your internet.";
      case DioExceptionType.sendTimeout:
        return "Request timed out while sending data.";
      case DioExceptionType.receiveTimeout:
        return "Server took too long to respond.";
      case DioExceptionType.badCertificate:
        return "Bad SSL certificate. Please check your connection.";
      case DioExceptionType.cancel:
        return "Request was cancelled.";
      case DioExceptionType.connectionError:
        return "No internet connection. Please check your network.";
      default:
        return "An unexpected error occurred. Please try again.";
    }
  }
}
