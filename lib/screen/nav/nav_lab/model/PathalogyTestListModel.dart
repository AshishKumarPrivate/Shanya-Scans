class PathalogyTestListModel {
  bool? success;
  String? message;
  List<Data>? data;

  PathalogyTestListModel({this.success, this.message, this.data});

  PathalogyTestListModel.fromJson(Map<String, dynamic> json) {
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
  String? sId;
  String? testDetailName;
  int? testPrice;
  String? slug;

  Data({this.sId, this.testDetailName, this.testPrice, this.slug});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    testDetailName = json['testDetailName'];
    testPrice = json['testPrice'];
    slug = json['slug'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['testDetailName'] = this.testDetailName;
    data['testPrice'] = this.testPrice;
    data['slug'] = this.slug;
    return data;
  }
}
