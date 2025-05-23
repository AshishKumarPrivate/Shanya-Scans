class LoginModel {
  bool? success;
  String? message;
  Data? data;

  LoginModel({this.success, this.message, this.data});

  LoginModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  String? email;
  String? verificationCode;
  bool? isVerified;
  String? password;
  List<dynamic>? member;
  int? iV;
  String? age;
  List<OrderDetails>? orderDetails;
  String? phoneNumber;
  String? token;
  String? whatsappNumber;

  Data(
      {this.sId,
        this.name,
        this.email,
        this.verificationCode,
        this.isVerified,
        this.password,
        this.member,
        this.iV,
        this.age,
        this.orderDetails,
        this.phoneNumber,
        this.token,
        this.whatsappNumber});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    verificationCode = json['verificationCode'];
    isVerified = json['isVerified'];
    password = json['password'];
    member = json['member'] ?? []; // FIXED: Handle null lists
    iV = json['__v'];
    age = json['age'];
    if (json['orderDetails'] != null) {
      orderDetails = <OrderDetails>[];
      json['orderDetails'].forEach((v) {
        orderDetails!.add(new OrderDetails.fromJson(v));
      });
    }
    phoneNumber = json['phoneNumber'];
    token = json['token'];
    whatsappNumber = json['whatsappNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['verificationCode'] = this.verificationCode;
    data['isVerified'] = this.isVerified;
    data['password'] = this.password;
    if (this.member != null) {
      data['member'] = this.member!.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    data['age'] = this.age;
    if (this.orderDetails != null) {
      data['orderDetails'] = this.orderDetails!.map((v) => v.toJson()).toList();
    }
    data['phoneNumber'] = this.phoneNumber;
    data['token'] = this.token;
    data['whatsappNumber'] = this.whatsappNumber;
    return data;
  }
}

class OrderDetails {
  String? sId;
  String? orderName;
  String? phone;
  String? altPhone;
  String? address;
  String? name;
  String? category;
  String? price;
  String? bod;
  String? bot;
  String? createdAt;
  String? updatedAt;
  int? iV;

  OrderDetails(
      {this.sId,
        this.orderName,
        this.phone,
        this.altPhone,
        this.address,
        this.name,
        this.category,
        this.price,
        this.bod,
        this.bot,
        this.createdAt,
        this.updatedAt,
        this.iV});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    orderName = json['orderName'];
    phone = json['phone'];
    altPhone = json['altPhone'];
    address = json['address'];
    name = json['name'];
    category = json['category'];
    price = json['price'];
    bod = json['bod'];
    bot = json['bot'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['orderName'] = this.orderName;
    data['phone'] = this.phone;
    data['altPhone'] = this.altPhone;
    data['address'] = this.address;
    data['name'] = this.name;
    data['category'] = this.category;
    data['price'] = this.price;
    data['bod'] = this.bod;
    data['bot'] = this.bot;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}







// class LoginModel {
//   final bool success;
//   final String message;
//   final Data? data;
//
//   LoginModel({
//     required this.success,
//     required this.message,
//     this.data,
//   });
//
//   // ✅ Factory Constructor for Better Performance
//   factory LoginModel.fromJson(Map<String, dynamic> json) {
//     return LoginModel(
//       success: json['success'] ?? false,
//       message: json['message'] ?? '',
//       data: json['data'] != null ? Data.fromJson(json['data']) : null,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'success': success,
//       'message': message,
//       'data': data?.toJson(),
//     };
//   }
// }
//
// class Data {
//   final String sId;
//   final String name;
//   final String email;
//   final String? verificationCode;
//   final bool isVerified;
//   final int iV;
//
//   Data({
//     required this.sId,
//     required this.name,
//     required this.email,
//     this.verificationCode,
//     required this.isVerified,
//     required this.iV,
//   });
//
//   // ✅ Factory Constructor for Efficiency
//   factory Data.fromJson(Map<String, dynamic> json) {
//     return Data(
//       sId: json['_id'] ?? '',
//       name: json['name'] ?? '',
//       email: json['email'] ?? '',
//       verificationCode: json['verificationCode'],
//       isVerified: json['isVerified'] ?? false,
//       iV: json['__v'] ?? 0,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       '_id': sId,
//       'name': name,
//       'email': email,
//       'verificationCode': verificationCode,
//       'isVerified': isVerified,
//       '__v': iV,
//     };
//   }
// }
//
//
//
//
//
// // class LoginModel {
// //   bool? success;
// //   String? message;
// //   Data? data;
// //
// //   LoginModel({this.success, this.message, this.data});
// //
// //   LoginModel.fromJson(Map<String, dynamic> json) {
// //     success = json['success'];
// //     message = json['message'];
// //     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['success'] = this.success;
// //     data['message'] = this.message;
// //     if (this.data != null) {
// //       data['data'] = this.data!.toJson();
// //     }
// //     return data;
// //   }
// // }
// //
// // class Data {
// //   String? sId;
// //   String? name;
// //   String? email;
// //   Null? verificationCode;
// //   bool? isVerified;
// //   int? iV;
// //
// //   Data(
// //       {this.sId,
// //         this.name,
// //         this.email,
// //         this.verificationCode,
// //         this.isVerified,
// //         this.iV});
// //
// //   Data.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     name = json['name'];
// //     email = json['email'];
// //     verificationCode = json['verificationCode'];
// //     isVerified = json['isVerified'];
// //     iV = json['__v'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     data['name'] = this.name;
// //     data['email'] = this.email;
// //     data['verificationCode'] = this.verificationCode;
// //     data['isVerified'] = this.isVerified;
// //     data['__v'] = this.iV;
// //     return data;
// //   }
// // }
