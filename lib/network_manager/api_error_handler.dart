import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String handleError(DioException error) {
    if (error.response != null) {
      // Extract error response
      final responseData = error.response!.data;

      // Ensure responseData is a Map and contains "message"
      if (responseData is Map<String, dynamic> && responseData.containsKey("message")) {
        return responseData["message"];
      }

      // Fallback error messages based on status code
      switch (error.response!.statusCode) {
        case 400:
          return "Invalid request.";
        case 401:
          return "Unauthorized access. Please login again.";
        case 403:
          return "Forbidden request.";
        case 404:
          return "User not found.";
        case 500:
          return "Server error. Please try again later.";
        default:
          return "Something went wrong. Status Code: ${error.response!.statusCode}";
      }
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return "Connection timeout. Please check your internet.";
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return "Server is taking too long to respond.";
    } else if (error.type == DioExceptionType.badResponse) {
      return "Received an invalid response from the server.";
    } else {
      return "An unexpected error occurred. Please try again.";
    }
  }
}
