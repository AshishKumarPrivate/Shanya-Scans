class ServiceDetailRateListModel {
  bool? success;
  String? message;
  List<Data>? data;
  int? total;
  int? page;
  int? totalPages;

  ServiceDetailRateListModel(
      {this.success,
        this.message,
        this.data,
        this.total,
        this.page,
        this.totalPages});

  ServiceDetailRateListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
    total = json['total'];
    page = json['page'];
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    data['page'] = this.page;
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class Data {
  String? sId;
  String? departement;
  String? subDepartment;
  String? testDetailName;
  String? category;
  int? testPrice;
  String? testDetails1;
  String? testDetails2;
  int? testDiscount;
  String? testRequirement1;
  String? testRequirement2;
  String? testDeliver1;
  String? testDeliver2;
  String? paramterInclude;
  String? sampleCollection;
  String? reportConsuling;
  String? reportTime;
  String? fasting;
  String? recommedFor;
  String? age;
  String? testId;
  String? slug;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.sId,
        this.departement,
        this.subDepartment,
        this.testDetailName,
        this.category,
        this.testPrice,
        this.testDetails1,
        this.testDetails2,
        this.testDiscount,
        this.testRequirement1,
        this.testRequirement2,
        this.testDeliver1,
        this.testDeliver2,
        this.paramterInclude,
        this.sampleCollection,
        this.reportConsuling,
        this.reportTime,
        this.fasting,
        this.recommedFor,
        this.age,
        this.testId,
        this.slug,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    departement = json['departement'];
    subDepartment = json['Sub_Department'];
    testDetailName = json['testDetailName'];
    category = json['category'];
    testPrice = json['testPrice'];
    testDetails1 = json['testDetails1'];
    testDetails2 = json['testDetails2'];
    testDiscount = json['testDiscount'];
    testRequirement1 = json['testRequirement1'];
    testRequirement2 = json['testRequirement2'];
    testDeliver1 = json['testDeliver1'];
    testDeliver2 = json['testDeliver2'];
    paramterInclude = json['paramterInclude'];
    sampleCollection = json['sampleCollection'];
    reportConsuling = json['reportConsuling'];
    reportTime = json['reportTime'];
    fasting = json['fasting'];
    recommedFor = json['recommedFor'];
    age = json['age'];
    testId = json['testId'];
    slug = json['slug'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['departement'] = this.departement;
    data['Sub_Department'] = this.subDepartment;
    data['testDetailName'] = this.testDetailName;
    data['category'] = this.category;
    data['testPrice'] = this.testPrice;
    data['testDetails1'] = this.testDetails1;
    data['testDetails2'] = this.testDetails2;
    data['testDiscount'] = this.testDiscount;
    data['testRequirement1'] = this.testRequirement1;
    data['testRequirement2'] = this.testRequirement2;
    data['testDeliver1'] = this.testDeliver1;
    data['testDeliver2'] = this.testDeliver2;
    data['paramterInclude'] = this.paramterInclude;
    data['sampleCollection'] = this.sampleCollection;
    data['reportConsuling'] = this.reportConsuling;
    data['reportTime'] = this.reportTime;
    data['fasting'] = this.fasting;
    data['recommedFor'] = this.recommedFor;
    data['age'] = this.age;
    data['testId'] = this.testId;
    data['slug'] = this.slug;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
