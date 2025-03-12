class FrequentlyTagListModel {
  bool? success;
  String? message;
  List<Data>? data;

  FrequentlyTagListModel({this.success, this.message, this.data});

  FrequentlyTagListModel.fromJson(Map<String, dynamic> json) {
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
  String? labTagName;
  String? labSlugName;
  String? labId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.icon,
        this.sId,
        this.labTagName,
        this.labSlugName,
        this.labId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    icon = json['icon'] != null ? new Icon.fromJson(json['icon']) : null;
    sId = json['_id'];
    labTagName = json['labTagName'];
    labSlugName = json['labSlugName'];
    labId = json['labId'];
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
    data['labTagName'] = this.labTagName;
    data['labSlugName'] = this.labSlugName;
    data['labId'] = this.labId;
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
