import 'package:intl/intl.dart';

class DateUtil {
  /// Converts a date string from one format to another.
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

  /// Formats a DateTime object into a desired format.
  static String formatDateTime({
    required DateTime dateTime,
    required String desiredFormat,
  }) {
    return DateFormat(desiredFormat).format(dateTime);
  }

  /// Returns the current date in a specified format.
  static String getCurrentDate({String format = "yyyy-MM-dd"}) {
    return DateFormat(format).format(DateTime.now());
  }

  /// Converts a timestamp (milliseconds) to a formatted date string.
  static String formatTimestamp({required int timestamp, String format = "yyyy-MM-dd"}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    return DateFormat(format).format(dateTime);
  }
}
