class StringUtils {

  static String type = "scan";
  static void setOrderType(String newType) {
    type = newType;
  }
  static String getOrderType() {
    return type;
  }

  /// Capitalizes the first letter of every word in a string.
  // -----------------------------
  // Text Manipulation Utilities
  // -----------------------------

  /// Capitalizes the first letter of every word in a string.
  static String capitalizeEachWord(String text) {
    if (text.trim().isEmpty) return "";
    return text
        .split(' ')
        .map((word) => word.isNotEmpty
        ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
        : '')
        .join(' ');
  }

  /// Capitalizes only the first letter of the string.
  static String capitalizeFirstLetter(String text) =>
      text.isNotEmpty ? '${text[0].toUpperCase()}${text.substring(1)}' : "";

  /// Converts a string to lowercase.
  static String toLowerCase(String text) => text.toLowerCase();

  /// Converts a string to uppercase.
  static String toUpperCase(String text) => text.toUpperCase();

  /// Trims leading and trailing spaces from a string.
  static String trimSpaces(String text) => text.trim();
  /// Checks if a string is null or empty (after trimming).
  static bool isNullOrEmpty(String? text) => text?.trim().isEmpty ?? true;



}
