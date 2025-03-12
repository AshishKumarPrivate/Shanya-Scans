class CreateOrderModelResponse {
  bool? success;
  String? message;
  Data? data;

  CreateOrderModelResponse({this.success, this.message, this.data});

  CreateOrderModelResponse.fromJson(Map<String, dynamic> json) {
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
  String? orderName;
  String? phone;
  String? altPhone;
  String? address;
  String? name;
  String? category;
  String? price;
  String? bod;
  String? bot;
  String? sId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data(
      {this.orderName,
        this.phone,
        this.altPhone,
        this.address,
        this.name,
        this.category,
        this.price,
        this.bod,
        this.bot,
        this.sId,
        this.createdAt,
        this.updatedAt,
        this.iV});

  Data.fromJson(Map<String, dynamic> json) {
    orderName = json['orderName'];
    phone = json['phone'];
    altPhone = json['altPhone'];
    address = json['address'];
    name = json['name'];
    category = json['category'];
    price = json['price'];
    bod = json['bod'];
    bot = json['bot'];
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderName'] = this.orderName;
    data['phone'] = this.phone;
    data['altPhone'] = this.altPhone;
    data['address'] = this.address;
    data['name'] = this.name;
    data['category'] = this.category;
    data['price'] = this.price;
    data['bod'] = this.bod;
    data['bot'] = this.bot;
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}
