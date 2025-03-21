import 'package:intl/intl.dart';

class DateUtil {
  /// ✅ Converts a date string from one format to another.
  static String formatDate({
    required String date,
    required String currentFormat,
    required String desiredFormat,
  }) {
    try {
      DateTime parsedDate = DateFormat(currentFormat).parse(date);
      return DateFormat(desiredFormat).format(parsedDate);
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// ✅ Formats a DateTime object into a desired format.
  static String formatDateTime({
    required DateTime dateTime,
    String desiredFormat = "dd-MM-yy",
  }) {
    return DateFormat(desiredFormat).format(dateTime);
  }

  /// ✅ Returns the current date formatted as a string.
  static String getCurrentDate({String format = "dd-MM-yy"}) {
    return DateFormat(format).format(DateTime.now());
  }

  /// ✅ Converts a timestamp (milliseconds) to a formatted date string.
  static String formatISODate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      return DateFormat("dd MMM yyyy").format(date);
    } catch (e) {
      return "Invalid Date";
    }
  }

  /// ✅ Formats ISO 8601 time string to 'hh:mm a' (12-hour format with AM/PM)
  static String formatISOTime(String timeString) {
    try {
      DateTime time = DateTime.parse(timeString);
      return DateFormat("hh:mm a").format(time); // Output: 05:05 PM
    } catch (e) {
      return "Invalid Time";
    }
  }
}
