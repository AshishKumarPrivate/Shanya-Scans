class PathalogyTestListModel {
  bool? success;
  String? message;
  Data? data;

  PathalogyTestListModel({this.success, this.message, this.data});

  PathalogyTestListModel.fromJson(Map<String, dynamic> json) {
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
  List<Allpathology>? allpathology;
  int? total;

  Data({this.allpathology, this.total});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['allpathology'] != null) {
      allpathology = <Allpathology>[];
      json['allpathology'].forEach((v) {
        allpathology!.add(new Allpathology.fromJson(v));
      });
    }
    total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.allpathology != null) {
      data['allpathology'] = this.allpathology!.map((v) => v.toJson()).toList();
    }
    data['total'] = this.total;
    return data;
  }
}

class Allpathology {
  String? sId;
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
  String? slug;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Allpathology(
      {this.sId,
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
        this.slug,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Allpathology.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
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
    slug = json['slug'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
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
    data['slug'] = this.slug;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}







//
// class PathalogyTestListModel {
//   bool? success;
//   String? message;
//   List<Data>? data;
//
//   PathalogyTestListModel({this.success, this.message, this.data});
//
//   PathalogyTestListModel.fromJson(Map<String, dynamic> json) {
//     success = json['success'];
//     message = json['message'];
//     if (json['data'] != null) {
//       data = <Data>[];
//       json['data'].forEach((v) {
//         data!.add(new Data.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['success'] = this.success;
//     data['message'] = this.message;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Data {
//   String? sId;
//   String? testDetailName;
//   String? category;
//   int? testPrice;
//   String? testDetails1;
//   String? testDetails2;
//   int? testDiscount;
//   String? testRequirement1;
//   String? testRequirement2;
//   String? testDeliver1;
//   String? testDeliver2;
//   String? paramterInclude;
//   String? sampleCollection;
//   String? reportConsuling;
//   String? reportTime;
//   String? fasting;
//   String? recommedFor;
//   String? age;
//   String? slug;
//   String? createdAt;
//   String? updatedAt;
//   int? iV;
//
//   Data(
//       {this.sId,
//         this.testDetailName,
//         this.category,
//         this.testPrice,
//         this.testDetails1,
//         this.testDetails2,
//         this.testDiscount,
//         this.testRequirement1,
//         this.testRequirement2,
//         this.testDeliver1,
//         this.testDeliver2,
//         this.paramterInclude,
//         this.sampleCollection,
//         this.reportConsuling,
//         this.reportTime,
//         this.fasting,
//         this.recommedFor,
//         this.age,
//         this.slug,
//         this.createdAt,
//         this.updatedAt,
//         this.iV});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//     testDetailName = json['testDetailName'];
//     category = json['category'];
//     testPrice = json['testPrice'];
//     testDetails1 = json['testDetails1'];
//     testDetails2 = json['testDetails2'];
//     testDiscount = json['testDiscount'];
//     testRequirement1 = json['testRequirement1'];
//     testRequirement2 = json['testRequirement2'];
//     testDeliver1 = json['testDeliver1'];
//     testDeliver2 = json['testDeliver2'];
//     paramterInclude = json['paramterInclude'];
//     sampleCollection = json['sampleCollection'];
//     reportConsuling = json['reportConsuling'];
//     reportTime = json['reportTime'];
//     fasting = json['fasting'];
//     recommedFor = json['recommedFor'];
//     age = json['age'];
//     slug = json['slug'];
//     createdAt = json['createdAt'];
//     updatedAt = json['updatedAt'];
//     iV = json['__v'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['_id'] = this.sId;
//     data['testDetailName'] = this.testDetailName;
//     data['category'] = this.category;
//     data['testPrice'] = this.testPrice;
//     data['testDetails1'] = this.testDetails1;
//     data['testDetails2'] = this.testDetails2;
//     data['testDiscount'] = this.testDiscount;
//     data['testRequirement1'] = this.testRequirement1;
//     data['testRequirement2'] = this.testRequirement2;
//     data['testDeliver1'] = this.testDeliver1;
//     data['testDeliver2'] = this.testDeliver2;
//     data['paramterInclude'] = this.paramterInclude;
//     data['sampleCollection'] = this.sampleCollection;
//     data['reportConsuling'] = this.reportConsuling;
//     data['reportTime'] = this.reportTime;
//     data['fasting'] = this.fasting;
//     data['recommedFor'] = this.recommedFor;
//     data['age'] = this.age;
//     data['slug'] = this.slug;
//     data['createdAt'] = this.createdAt;
//     data['updatedAt'] = this.updatedAt;
//     data['__v'] = this.iV;
//     return data;
//   }
// }
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
// // class PathalogyTestListModel {
// //   bool? success;
// //   String? message;
// //   List<Data>? data;
// //
// //   PathalogyTestListModel({this.success, this.message, this.data});
// //
// //   PathalogyTestListModel.fromJson(Map<String, dynamic> json) {
// //     success = json['success'];
// //     message = json['message'];
// //     if (json['data'] != null) {
// //       data = <Data>[];
// //       json['data'].forEach((v) {
// //         data!.add(new Data.fromJson(v));
// //       });
// //     }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['success'] = this.success;
// //     data['message'] = this.message;
// //     if (this.data != null) {
// //       data['data'] = this.data!.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }
// //
// // class Data {
// //   String? sId;
// //   String? testDetailName;
// //   int? testPrice;
// //   String? slug;
// //
// //   Data({this.sId, this.testDetailName, this.testPrice, this.slug});
// //
// //   Data.fromJson(Map<String, dynamic> json) {
// //     sId = json['_id'];
// //     testDetailName = json['testDetailName'];
// //     testPrice = json['testPrice'];
// //     slug = json['slug'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['_id'] = this.sId;
// //     data['testDetailName'] = this.testDetailName;
// //     data['testPrice'] = this.testPrice;
// //     data['slug'] = this.slug;
// //     return data;
// //   }
// // }
