class FrequentlyLabTestDetailModel {
  bool? success;
  String? message;
  Data? data;

  FrequentlyLabTestDetailModel({this.success, this.message, this.data});

  FrequentlyLabTestDetailModel.fromJson(Map<String, dynamic> json) {
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
  PackagePhoto? packagePhoto;
  String? sId;
  String? packageName;
  String? packageOverview;
  String? packageCategory;
  int? packageRate;
  int? packageDiscount;
  int? parameterInclude;
  int? report;
  List<PackagesParamter>? packagesParamter;
  String? packageParamterDetails;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? slug;
  String? age;
  String? fasting;
  String? instructionEnglish;
  String? instructionHindi;
  String? recommededfor;

  Data(
      {this.packagePhoto,
        this.sId,
        this.packageName,
        this.packageOverview,
        this.packageCategory,
        this.packageRate,
        this.packageDiscount,
        this.parameterInclude,
        this.report,
        this.packagesParamter,
        this.packageParamterDetails,
        this.createdAt,
        this.updatedAt,
        this.iV,
        this.slug,
        this.age,
        this.fasting,
        this.instructionEnglish,
        this.instructionHindi,
        this.recommededfor});

  Data.fromJson(Map<String, dynamic> json) {
    packagePhoto = json['packagePhoto'] != null
        ? new PackagePhoto.fromJson(json['packagePhoto'])
        : null;
    sId = json['_id'];
    packageName = json['packageName'];
    packageOverview = json['packageOverview'];
    packageCategory = json['packageCategory'];
    packageRate = json['packageRate'];
    packageDiscount = json['packageDiscount'];
    parameterInclude = json['parameterInclude'];
    report = json['report'];
    if (json['packagesParamter'] != null) {
      packagesParamter = <PackagesParamter>[];
      json['packagesParamter'].forEach((v) {
        packagesParamter!.add(new PackagesParamter.fromJson(v));
      });
    }
    packageParamterDetails = json['packageParamterDetails'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    slug = json['slug'];
    age = json['age'];
    fasting = json['fasting'];
    instructionEnglish = json['instructionEnglish'];
    instructionHindi = json['instructionHindi'];
    recommededfor = json['recommededfor'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.packagePhoto != null) {
      data['packagePhoto'] = this.packagePhoto!.toJson();
    }
    data['_id'] = this.sId;
    data['packageName'] = this.packageName;
    data['packageOverview'] = this.packageOverview;
    data['packageCategory'] = this.packageCategory;
    data['packageRate'] = this.packageRate;
    data['packageDiscount'] = this.packageDiscount;
    data['parameterInclude'] = this.parameterInclude;
    data['report'] = this.report;
    if (this.packagesParamter != null) {
      data['packagesParamter'] =
          this.packagesParamter!.map((v) => v.toJson()).toList();
    }
    data['packageParamterDetails'] = this.packageParamterDetails;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    data['slug'] = this.slug;
    data['age'] = this.age;
    data['fasting'] = this.fasting;
    data['instructionEnglish'] = this.instructionEnglish;
    data['instructionHindi'] = this.instructionHindi;
    data['recommededfor'] = this.recommededfor;
    return data;
  }
}

class PackagePhoto {
  String? publicId;
  String? secureUrl;

  PackagePhoto({this.publicId, this.secureUrl});

  PackagePhoto.fromJson(Map<String, dynamic> json) {
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

class PackagesParamter {
  String? parameterName;
  String? description;
  String? sId;

  PackagesParamter({this.parameterName, this.description, this.sId});

  PackagesParamter.fromJson(Map<String, dynamic> json) {
    parameterName = json['parameterName'];
    description = json['description'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['parameterName'] = this.parameterName;
    data['description'] = this.description;
    data['_id'] = this.sId;
    return data;
  }
}
