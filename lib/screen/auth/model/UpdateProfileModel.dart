class UpdateProfileModel {
  bool? success;
  String? message;
  Data? data;

  UpdateProfileModel({this.success, this.message, this.data});

  UpdateProfileModel.fromJson(Map<String, dynamic> json) {
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
  Null? verificationCode;
  bool? isVerified;
  String? password;
  List<dynamic>? member;
  int? iV;
  String? age;
  List<String>? orderDetails;
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

    // if (json['member'] != null) {
    //   member = <Null>[];
    //   json['member'].forEach((v) {
    //     member!.add(new Null.fromJson(v));
    //   });
    // }


    iV = json['__v'];
    age = json['age'];
    orderDetails = json['orderDetails'].cast<String>();
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
    data['orderDetails'] = this.orderDetails;
    data['phoneNumber'] = this.phoneNumber;
    data['token'] = this.token;
    data['whatsappNumber'] = this.whatsappNumber;
    return data;
  }
}
