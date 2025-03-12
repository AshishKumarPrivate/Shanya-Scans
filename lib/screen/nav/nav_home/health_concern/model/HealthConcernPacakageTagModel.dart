class HealthConcernPackageTagModel {
  bool? success;
  String? message;
  List<Data>? data;

  HealthConcernPackageTagModel({this.success, this.message, this.data});

  HealthConcernPackageTagModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  Icon? icon;
  String? sId;
  String? packageTagName;
  String? packageSlugName;
  String? packageId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.icon,
        this.sId,
        this.packageTagName,
        this.packageSlugName,
        this.packageId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    icon = json['icon'] != null ? new Icon.fromJson(json['icon']) : null;
    sId = json['_id'];
    packageTagName = json['packageTagName'];
    packageSlugName = json['packageSlugName'];
    packageId = json['packageId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.icon != null) {
      data['icon'] = this.icon!.toJson();
    }
    data['_id'] = this.sId;
    data['packageTagName'] = this.packageTagName;
    data['packageSlugName'] = this.packageSlugName;
    data['packageId'] = this.packageId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Icon {
  String? publicId;
  String? secureUrl;

  Icon({this.publicId, this.secureUrl});

  Icon.fromJson(Map<String, dynamic> json) {
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
