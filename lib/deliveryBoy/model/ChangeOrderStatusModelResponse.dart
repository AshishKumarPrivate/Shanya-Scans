class ChangeOrderStatusModelResponse {
  bool? success;
  String? message;
  Order? order;

  ChangeOrderStatusModelResponse({this.success, this.message, this.order});

  ChangeOrderStatusModelResponse.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class Order {
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
  String? userId;
  String? assignedTo;
  String? orderDateTime;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Order(
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
        this.orderDateTime,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Order.fromJson(Map<String, dynamic> json) {
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
    userId = json['userId'];
    assignedTo = json['assignedTo'];
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
    data['userId'] = this.userId;
    data['assignedTo'] = this.assignedTo;
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
