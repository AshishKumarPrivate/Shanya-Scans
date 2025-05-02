class PaymentCheckoutModel {
  bool? success;
  Order? order;

  PaymentCheckoutModel({this.success, this.order});

  PaymentCheckoutModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    order = json['order'] != null ? new Order.fromJson(json['order']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    if (this.order != null) {
      data['order'] = this.order!.toJson();
    }
    return data;
  }
}

class Order {
  int? amount;
  int? amountDue;
  int? amountPaid;
  int? attempts;
  int? createdAt;
  String? currency;
  String? entity;
  String? id;
  Notes? notes;
  Null? offerId;
  Null? receipt;
  String? status;

  Order(
      {this.amount,
        this.amountDue,
        this.amountPaid,
        this.attempts,
        this.createdAt,
        this.currency,
        this.entity,
        this.id,
        this.notes,
        this.offerId,
        this.receipt,
        this.status});

  Order.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    amountDue = json['amount_due'];
    amountPaid = json['amount_paid'];
    attempts = json['attempts'];
    createdAt = json['created_at'];
    currency = json['currency'];
    entity = json['entity'];
    id = json['id'];
    notes = json['notes'] != null ? new Notes.fromJson(json['notes']) : null;
    offerId = json['offer_id'];
    receipt = json['receipt'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['amount'] = this.amount;
    data['amount_due'] = this.amountDue;
    data['amount_paid'] = this.amountPaid;
    data['attempts'] = this.attempts;
    data['created_at'] = this.createdAt;
    data['currency'] = this.currency;
    data['entity'] = this.entity;
    data['id'] = this.id;
    if (this.notes != null) {
      data['notes'] = this.notes!.toJson();
    }
    data['offer_id'] = this.offerId;
    data['receipt'] = this.receipt;
    data['status'] = this.status;
    return data;
  }
}

class Notes {
  String? purpose;

  Notes({this.purpose});

  Notes.fromJson(Map<String, dynamic> json) {
    purpose = json['purpose'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['purpose'] = this.purpose;
    return data;
  }
}
