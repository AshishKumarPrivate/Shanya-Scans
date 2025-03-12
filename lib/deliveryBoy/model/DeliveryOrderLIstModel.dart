class DeliveryBoyOrderListModel {
  final String id;
  final String customerName;
  final String status;
  final String address;
  final String dateTime;

  DeliveryBoyOrderListModel({
    required this.id,
    required this.customerName,
    required this.status,
    required this.address,
    required this.dateTime,
  });

  factory DeliveryBoyOrderListModel.fromJson(Map<String, dynamic> json) {
    return DeliveryBoyOrderListModel(
      id: json['id'],
      customerName: json['customer_name'],
      status: json['status'],
      address: json['address'],
      dateTime: json['date_time'],
    );
  }
}
