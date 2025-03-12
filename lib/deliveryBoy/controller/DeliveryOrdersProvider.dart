import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:healthians/deliveryBoy/model/DeliveryOrderLIstModel.dart';

class DeliveryOrdersProvider extends ChangeNotifier {
  List<DeliveryBoyOrderListModel> _orders = [
    DeliveryBoyOrderListModel(id: "1", customerName: "Ashish Kumar", status: "Pending", address: "123 Sitapur Road, Lucknow", dateTime: "2025-03-08 10:00 AM"),
    DeliveryBoyOrderListModel(id: "2", customerName: "Rahul Sharma", status: "Ongoing", address: "456 Gomti Nagar, Lucknow", dateTime: "2025-03-08 11:30 AM"),
    DeliveryBoyOrderListModel(id: "3", customerName: "Vikram Singh", status: "Delivered", address: "789 Alambagh, Lucknow", dateTime: "2025-03-07 02:45 PM"),
    DeliveryBoyOrderListModel(id: "4", customerName: "Pooja Verma", status: "Pending", address: "321 Indira Nagar, Lucknow", dateTime: "2025-03-08 09:15 AM"),
    DeliveryBoyOrderListModel(id: "5", customerName: "Amit Tiwari", status: "Ongoing", address: "654 Hazratganj, Lucknow", dateTime: "2025-03-08 12:00 PM"),
    DeliveryBoyOrderListModel(id: "6", customerName: "Neha Agarwal", status: "Delivered", address: "987 Chowk, Lucknow", dateTime: "2025-03-07 04:00 PM"),
  ];

  // ✅ Ensure case-sensitive matching for status filters
  List<DeliveryBoyOrderListModel> get pendingOrders => _orders.where((o) => o.status == "Pending").toList();
  List<DeliveryBoyOrderListModel> get ongoingOrders => _orders.where((o) => o.status == "Ongoing").toList();
  List<DeliveryBoyOrderListModel> get deliveredOrders => _orders.where((o) => o.status == "Delivered").toList();

  Future<void> fetchOrders() async {
    try {
      final response = await Dio().get("https://your-api.com/orders");
      if (response.statusCode == 200) {
        _orders = (response.data as List).map((json) => DeliveryBoyOrderListModel.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {
      print("Error fetching orders: $e");
    }
  }
}
