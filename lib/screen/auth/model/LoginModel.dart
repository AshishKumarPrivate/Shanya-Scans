class LoginModel {
  final bool success;
  final String message;
  final Data? data;

  LoginModel({
    required this.success,
    required this.message,
    this.data,
  });

  // ✅ Factory Constructor for Better Performance
  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class Data {
  final String sId;
  final String name;
  final String email;
  final String? verificationCode;
  final bool isVerified;
  final int iV;

  Data({
    required this.sId,
    required this.name,
    required this.email,
    this.verificationCode,
    required this.isVerified,
    required this.iV,
  });

  // ✅ Factory Constructor for Efficiency
  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      sId: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      verificationCode: json['verificationCode'],
      isVerified: json['isVerified'] ?? false,
      iV: json['__v'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': sId,
      'name': name,
      'email': email,
      'verificationCode': verificationCode,
      'isVerified': isVerified,
      '__v': iV,
    };
  }
}





// class LoginModel {
//   bool? success;
//   String? message;
//   Data? data;
//
//   LoginModel({this.success, this.message, this.data});
//
//   LoginModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String? sId;
//   String? name;
//   String? email;
//   Null? verificationCode;
//   bool? isVerified;
//   int? iV;
//
//   Data(
//       {this.sId,
//         this.name,
//         this.email,
//         this.verificationCode,
//         this.isVerified,
//         this.iV});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     email = json['email'];
//     verificationCode = json['verificationCode'];
//     isVerified = json['isVerified'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['verificationCode'] = this.verificationCode;
//     data['isVerified'] = this.isVerified;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
