class EnquiryNeedHelpModel {
  String? status;
  String? message;
  Data? data;

  EnquiryNeedHelpModel({this.status, this.message, this.data});

  EnquiryNeedHelpModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? firstName;
  String? lastName;
  String? subject;
  String? email;
  String? message;
  String? sId;
  int? iV;

  Data(
      {this.firstName,
        this.lastName,
        this.subject,
        this.email,
        this.message,
        this.sId,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    subject = json['subject'];
    email = json['email'];
    message = json['message'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['subject'] = this.subject;
    data['email'] = this.email;
    data['message'] = this.message;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}
