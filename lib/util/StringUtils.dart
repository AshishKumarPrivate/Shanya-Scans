class StringUtils {
  /// Capitalizes the first letter of every word in a string.
  static String capitalizeEachWord(String text) {
    if (text.isEmpty) return "";

    return text.split(' ').map((word) {
      if (word.isEmpty) return ""; // Handle extra spaces
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  /// Capitalizes only the first letter of the string.
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return "";
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Converts a string to lowercase.
  static String toLowerCase(String text) {
    return text.toLowerCase();
  }

  /// Converts a string to uppercase.
  static String toUpperCase(String text) {
    return text.toUpperCase();
  }

  /// Trims leading and trailing spaces from a string.
  static String trimSpaces(String text) {
    return text.trim();
  }

  /// Checks if a string is empty or contains only whitespace.
  static bool isNullOrEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }
}
