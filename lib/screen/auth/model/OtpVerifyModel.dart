class OtpVerifyModel {
  bool? success;
  String? message;
  Data? data;

  OtpVerifyModel({this.success, this.message, this.data});

  OtpVerifyModel.fromJson(Map<String, dynamic> json) {
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
  Null verificationCode;
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

/////////////////////////

// class OtpVerifyModel {
//   bool? success;
//   String? message;
//   Data? data;
//
//   OtpVerifyModel({this.success, this.message, this.data});
//
//   OtpVerifyModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     data = json['data'] != null ? Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['success'] = success;
//     data['message'] = message;
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
//   String? password;
//   dynamic verificationCode;
//   bool? isVerified;
//   List<dynamic>? orderDetails; // FIXED: Changed List<Null> to List<dynamic>
//   String? phoneNumber;
//   String? whatsappNumber;
//   String? age;
//   List<dynamic>? member; // FIXED: Changed List<Null> to List<dynamic>
//   int? iV;
//   String? token;
//
//   Data({
//     this.sId,
//     this.name,
//     this.email,
//     this.password,
//     this.verificationCode,
//     this.isVerified,
//     this.orderDetails,
//     this.phoneNumber,
//     this.whatsappNumber,
//     this.age,
//     this.member,
//     this.iV,
//     this.token,
//   });
//
//   Data.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     email = json['email'];
//     password = json['password'];
//     verificationCode = json['verificationCode'];
//     isVerified = json['isVerified'];
//     orderDetails = json['orderDetails'] ?? []; // FIXED: Handle null lists
//     phoneNumber = json['phoneNumber'];
//     whatsappNumber = json['whatsappNumber'];
//     age = json['age'];
//     member = json['member'] ?? []; // FIXED: Handle null lists
//     iV = json['__v'];
//     token = json['token'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = {};
//     data['_id'] = sId;
//     data['name'] = name;
//     data['email'] = email;
//     data['password'] = password;
//     data['verificationCode'] = verificationCode;
//     data['isVerified'] = isVerified;
//     data['orderDetails'] = orderDetails ?? []; // FIXED: Prevent null issue
//     data['phoneNumber'] = phoneNumber;
//     data['whatsappNumber'] = whatsappNumber;
//     data['age'] = age;
//     data['member'] = member ?? []; // FIXED: Prevent null issue
//     data['__v'] = iV;
//     data['token'] = token;
//     return data;
//   }
// }

