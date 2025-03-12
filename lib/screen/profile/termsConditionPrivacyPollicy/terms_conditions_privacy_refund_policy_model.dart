class TermsConditionsPrivacyRefundPolicyModel {
  bool? success;
  String? message;
  Data? data;

  TermsConditionsPrivacyRefundPolicyModel({this.success, this.message, this.data});

  TermsConditionsPrivacyRefundPolicyModel.fromJson(Map<String, dynamic> json) {
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
  String? title;
  String? description;
  String? url;
  int? iV;

  Data({this.sId, this.title, this.description, this.url, this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['url'] = this.url;
    data['__v'] = this.iV;
    return data;
  }
}
