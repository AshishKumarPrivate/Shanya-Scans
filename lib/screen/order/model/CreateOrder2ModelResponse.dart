class CreateOrder2ModelResponse {
  bool? success;
  String? message;
  Data? data;

  CreateOrder2ModelResponse({this.success, this.message, this.data});

  CreateOrder2ModelResponse.fromJson(Map<String, dynamic> json) {
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
  String? userDetails;
  List<String>? orderDetails;
  String? address;
  int? phoneNumber;
  int? altPhoneNumber;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.userDetails,
      this.orderDetails,
      this.address,
      this.phoneNumber,
      this.altPhoneNumber,
      this.sId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    userDetails = json['userDetails'];
    orderDetails = json['orderDetails'].cast<String>();
    address = json['address'];
    phoneNumber = json['phoneNumber'];
    altPhoneNumber = json['altPhoneNumber'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userDetails'] = this.userDetails;
    data['orderDetails'] = this.orderDetails;
    data['address'] = this.address;
    data['phoneNumber'] = this.phoneNumber;
    data['altPhoneNumber'] = this.altPhoneNumber;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
