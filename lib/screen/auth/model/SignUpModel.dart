// class SignUpModel {
//   bool? success;
//   String? message;
//
//   SignUpModel({
//     required this.success,
//     required this.message,
//   });
//
//   // Factory constructor to create an instance from JSON
//   factory SignUpModel.fromJson(Map<String, dynamic> json) {
//     return SignUpModel(
//       success: json["success"] ?? false,
//       message: json["message"] ?? "Something ",
//     );
//   }
//
//   // Convert instance to JSON (useful for debugging or saving data locally)
//   Map<String, dynamic> toJson() {
//     return {
//       "success": success,
//       "message": message,
//     };
//   }
// }

class SignUpModel {
  final bool success;
  final String message;

  SignUpModel({
    required this.success,
    required this.message,
  });

  // Factory constructor to create an instance from JSON
  factory SignUpModel.fromJson(Map<String, dynamic> json) {
    return SignUpModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "Something went wrong",
    );
  }

  // Convert instance to JSON (useful for debugging or saving data locally)
  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "message": message,
    };
  }
}
