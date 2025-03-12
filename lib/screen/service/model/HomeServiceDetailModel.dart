class HomeServiceDetailModel {
  bool? success;
  String? message;
  Data? data;

  HomeServiceDetailModel({this.success, this.message, this.data});

  HomeServiceDetailModel.fromJson(Map<String, dynamic> json) {
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
  ServicePhoto? servicePhoto;
  String? sId;
  String? serviceDetailName;
  String? serviceDetail;
  String? serviceId;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? slug;

  Data(
      {this.servicePhoto,
        this.sId,
        this.serviceDetailName,
        this.serviceDetail,
        this.serviceId,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.slug});

  Data.fromJson(Map<String, dynamic> json) {
    servicePhoto = json['servicePhoto'] != null
        ? new ServicePhoto.fromJson(json['servicePhoto'])
        : null;
    sId = json['_id'];
    serviceDetailName = json['serviceDetailName'];
    serviceDetail = json['serviceDetail'];
    serviceId = json['serviceId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.servicePhoto != null) {
      data['servicePhoto'] = this.servicePhoto!.toJson();
    }
    data['_id'] = this.sId;
    data['serviceDetailName'] = this.serviceDetailName;
    data['serviceDetail'] = this.serviceDetail;
    data['serviceId'] = this.serviceId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['slug'] = this.slug;
    return data;
  }
}

class ServicePhoto {
  String? publicId;
  String? secureUrl;

  ServicePhoto({this.publicId, this.secureUrl});

  ServicePhoto.fromJson(Map<String, dynamic> json) {
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
