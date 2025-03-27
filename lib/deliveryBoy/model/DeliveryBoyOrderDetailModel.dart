class DeliveryBoyOrderDetailModel {
  bool? success;
  String? message;
  Data? data;

  DeliveryBoyOrderDetailModel({this.success, this.message, this.data});

  DeliveryBoyOrderDetailModel.fromJson(Map<String, dynamic> json) {
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
  Report? report;
  String? sId;
  String? patientName;
  int? patientAge;
  String? patientGender;
  int? quantity;
  String? category;
  String? orderName;
  String? orderType;
  int? orderPrice;
  String? bookingStatus;
  String? bookingDate;
  String? bookingTime;
  String? reportStatus;
  UserId? userId;
  AssignedTo? assignedTo;
  String? lat;
  String? lng;
  String? orderDateTime;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.report,
        this.sId,
        this.patientName,
        this.patientAge,
        this.patientGender,
        this.quantity,
        this.category,
        this.orderName,
        this.orderType,
        this.orderPrice,
        this.bookingStatus,
        this.bookingDate,
        this.bookingTime,
        this.reportStatus,
        this.userId,
        this.assignedTo,
        this.lat,
        this.lng,
        this.orderDateTime,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    report =
    json['report'] != null ? new Report.fromJson(json['report']) : null;
    sId = json['_id'];
    patientName = json['patientName'];
    patientAge = json['patientAge'];
    patientGender = json['patientGender'];
    quantity = json['quantity'];
    category = json['category'];
    orderName = json['orderName'];
    orderType = json['orderType'];
    orderPrice = json['orderPrice'];
    bookingStatus = json['bookingStatus'];
    bookingDate = json['bookingDate'];
    bookingTime = json['bookingTime'];
    reportStatus = json['reportStatus'];
    userId =
    json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
    assignedTo = json['assignedTo'] != null
        ? new AssignedTo.fromJson(json['assignedTo'])
        : null;
    lat = json['lat'];
    lng = json['lng'];
    orderDateTime = json['orderDateTime'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.report != null) {
      data['report'] = this.report!.toJson();
    }
    data['_id'] = this.sId;
    data['patientName'] = this.patientName;
    data['patientAge'] = this.patientAge;
    data['patientGender'] = this.patientGender;
    data['quantity'] = this.quantity;
    data['category'] = this.category;
    data['orderName'] = this.orderName;
    data['orderType'] = this.orderType;
    data['orderPrice'] = this.orderPrice;
    data['bookingStatus'] = this.bookingStatus;
    data['bookingDate'] = this.bookingDate;
    data['bookingTime'] = this.bookingTime;
    data['reportStatus'] = this.reportStatus;
    if (this.userId != null) {
      data['userId'] = this.userId!.toJson();
    }
    if (this.assignedTo != null) {
      data['assignedTo'] = this.assignedTo!.toJson();
    }
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['orderDateTime'] = this.orderDateTime;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Report {
  String? publicId;
  String? secureUrl;

  Report({this.publicId, this.secureUrl});

  Report.fromJson(Map<String, dynamic> json) {
    publicId = json['public_id'];
    secureUrl = json['secure_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['public_id'] = this.publicId;
    data['secure_url'] = this.secureUrl;
    return data;
  }
}

class UserId {
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

  UserId(
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

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    verificationCode = json['verificationCode'];
    isVerified = json['isVerified'];
    password = json['password'];
    member = json['member'] ?? []; // FIXED: Handle null lists
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

class AssignedTo {
  String? sId;
  String? name;
  String? email;
  String? password;
  List<String>? orderDetails;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? address;
  String? lat;
  String? lng;

  AssignedTo(
      {this.sId,
        this.name,
        this.email,
        this.password,
        this.orderDetails,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.address,
        this.lat,
        this.lng});

  AssignedTo.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    orderDetails = json['orderDetails'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    address = json['address'];
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['password'] = this.password;
    data['orderDetails'] = this.orderDetails;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['address'] = this.address;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}














// class DeliveryBoyOrderDetailModel {
//   bool? success;
//   String? message;
//   Data? data;
//
//   DeliveryBoyOrderDetailModel({this.success, this.message, this.data});
//
//   DeliveryBoyOrderDetailModel.fromJson(Map<String, dynamic> json) {
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
//   Report? report;
//   String? sId;
//   String? patientName;
//   int? patientAge;
//   String? patientGender;
//   int? quantity;
//   String? category;
//   String? orderName;
//   String? orderType;
//   int? orderPrice;
//   String? bookingStatus;
//   String? bookingDate;
//   String? bookingTime;
//   String? reportStatus;
//   UserId? userId;
//   String? orderDateTime;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;
//   AssignedTo? assignedTo;
//
//   Data(
//       {this.report,
//         this.sId,
//         this.patientName,
//         this.patientAge,
//         this.patientGender,
//         this.quantity,
//         this.category,
//         this.orderName,
//         this.orderType,
//         this.orderPrice,
//         this.bookingStatus,
//         this.bookingDate,
//         this.bookingTime,
//         this.reportStatus,
//         this.userId,
//         this.orderDateTime,
//         this.createdAt,
//         this.updatedAt,
//         this.iV,
//         this.assignedTo});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     report =
//     json['report'] != null ? new Report.fromJson(json['report']) : null;
//     sId = json['_id'];
//     patientName = json['patientName'];
//     patientAge = json['patientAge'];
//     patientGender = json['patientGender'];
//     quantity = json['quantity'];
//     category = json['category'];
//     orderName = json['orderName'];
//     orderType = json['orderType'];
//     orderPrice = json['orderPrice'];
//     bookingStatus = json['bookingStatus'];
//     bookingDate = json['bookingDate'];
//     bookingTime = json['bookingTime'];
//     reportStatus = json['reportStatus'];
//     userId =
//     json['userId'] != null ? new UserId.fromJson(json['userId']) : null;
//     orderDateTime = json['orderDateTime'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//     assignedTo = json['assignedTo'] != null
//         ? new AssignedTo.fromJson(json['assignedTo'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.report != null) {
//       data['report'] = this.report!.toJson();
//     }
//     data['_id'] = this.sId;
//     data['patientName'] = this.patientName;
//     data['patientAge'] = this.patientAge;
//     data['patientGender'] = this.patientGender;
//     data['quantity'] = this.quantity;
//     data['category'] = this.category;
//     data['orderName'] = this.orderName;
//     data['orderType'] = this.orderType;
//     data['orderPrice'] = this.orderPrice;
//     data['bookingStatus'] = this.bookingStatus;
//     data['bookingDate'] = this.bookingDate;
//     data['bookingTime'] = this.bookingTime;
//     data['reportStatus'] = this.reportStatus;
//     if (this.userId != null) {
//       data['userId'] = this.userId!.toJson();
//     }
//     data['orderDateTime'] = this.orderDateTime;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     if (this.assignedTo != null) {
//       data['assignedTo'] = this.assignedTo!.toJson();
//     }
//     return data;
//   }
// }
//
// class Report {
//   String? publicId;
//   String? secureUrl;
//
//   Report({this.publicId, this.secureUrl});
//
//   Report.fromJson(Map<String, dynamic> json) {
//     publicId = json['public_id'];
//     secureUrl = json['secure_url'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['public_id'] = this.publicId;
//     data['secure_url'] = this.secureUrl;
//     return data;
//   }
// }
//
// class UserId {
//   String? sId;
//   String? name;
//   String? email;
//   bool? isVerified;
//   List<String>? orderDetails;
//   String? phoneNumber;
//   String? whatsappNumber;
//   String? age;
//   List<dynamic>? member;
//   int? iV;
//   String? verificationCode;
//   String? token;
//
//   UserId(
//       {this.sId,
//         this.name,
//         this.email,
//         this.isVerified,
//         this.orderDetails,
//         this.phoneNumber,
//         this.whatsappNumber,
//         this.age,
//         this.member,
//         this.iV,
//         this.verificationCode,
//         this.token});
//
//   UserId.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     email = json['email'];
//     isVerified = json['isVerified'];
//     orderDetails = json['orderDetails'].cast<String>();
//     phoneNumber = json['phoneNumber'];
//     whatsappNumber = json['whatsappNumber'];
//     age = json['age'];
//     member = json['member'] ?? []; // FIXED: Handle null lists
//     iV = json['__v'];
//     verificationCode = json['verificationCode'];
//     token = json['token'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['isVerified'] = this.isVerified;
//     data['orderDetails'] = this.orderDetails;
//     data['phoneNumber'] = this.phoneNumber;
//     data['whatsappNumber'] = this.whatsappNumber;
//     data['age'] = this.age;
//     if (this.member != null) {
//       data['member'] = this.member!.map((v) => v.toJson()).toList();
//     }
//     data['__v'] = this.iV;
//     data['verificationCode'] = this.verificationCode;
//     data['token'] = this.token;
//     return data;
//   }
// }
//
// class AssignedTo {
//   String? sId;
//   String? name;
//   String? email;
//   String? password;
//   List<String>? orderDetails;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;
//
//   AssignedTo(
//       {this.sId,
//         this.name,
//         this.email,
//         this.password,
//         this.orderDetails,
//         this.createdAt,
//         this.updatedAt,
//         this.iV});
//
//   AssignedTo.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     name = json['name'];
//     email = json['email'];
//     password = json['password'];
//     orderDetails = json['orderDetails'].cast<String>();
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['name'] = this.name;
//     data['email'] = this.email;
//     data['password'] = this.password;
//     data['orderDetails'] = this.orderDetails;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
