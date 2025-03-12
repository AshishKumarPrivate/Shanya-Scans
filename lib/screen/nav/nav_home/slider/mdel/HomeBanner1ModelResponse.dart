class HomeBanner1ModelResponse {
  bool? success;
  String? message;
  List<Data>? data;

  HomeBanner1ModelResponse({this.success, this.message, this.data});

  HomeBanner1ModelResponse.fromJson(Map<String, dynamic> json) {
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
  Photo? photo;
  String? sId;
  String? name;
  String? types;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.photo,
        this.sId,
        this.name,
        this.types,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    photo = json['photo'] != null ? new Photo.fromJson(json['photo']) : null;
    sId = json['_id'];
    name = json['name'];
    types = json['types'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.photo != null) {
      data['photo'] = this.photo!.toJson();
    }
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['types'] = this.types;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Photo {
  String? publicId;
  String? secureUrl;

  Photo({this.publicId, this.secureUrl});

  Photo.fromJson(Map<String, dynamic> json) {
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
