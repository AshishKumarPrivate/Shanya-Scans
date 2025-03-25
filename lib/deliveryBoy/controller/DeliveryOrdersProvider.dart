import 'dart:io';

import 'package:flutter/material.dart';
import 'package:healthians/deliveryBoy/model/ChangeOrderStatusModelResponse.dart';
import 'package:healthians/deliveryBoy/model/DeliveryBoyOrderDetailModel.dart';
import 'package:healthians/deliveryBoy/model/DeliveryBoyOrderSummaryModelResponse.dart';
import 'package:healthians/deliveryBoy/model/DeliveryBoyProfileSummaryModelResponse.dart';
import 'package:healthians/deliveryBoy/model/DeliveryOrderLIstModel.dart' as deliveryBoyOrder;
import 'package:healthians/ui_helper/storage_helper.dart';
import '../../network_manager/repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class DeliveryOrdersProvider extends ChangeNotifier {
  final Repository _repository = Repository();
  late IO.Socket _socket;

  DateTime? _selectedDate;

  bool _isLoading = false;
  String _errorMessage = "";
  deliveryBoyOrder.DeliveryBoyOrderListModel? _deliveryBoyOrderListModel;
  DeliveryBoyOrderDetailModel? _deliveryBoyOrderDetailModel;
  ChangeOrderStatusModelResponse? _changeOrderStatusModel;
  DeliveryBoyOrderSummaryModelResponse? _deliveryBoyOrderSummaryModel;
  DeliveryBoyProfileSummaryModelResponse? _deliveryBoyProfileSummaryModel;
  List<deliveryBoyOrder.OrderDetails> _orderList = [];
  bool _newOrderAssigned = false; // Flag to show shimmer notification

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<deliveryBoyOrder.OrderDetails> get orderList => _orderList;
  DeliveryBoyOrderDetailModel? get orderDetail => _deliveryBoyOrderDetailModel;
  ChangeOrderStatusModelResponse? get changeOrderStatusModel => _changeOrderStatusModel;
  DeliveryBoyOrderSummaryModelResponse? get deliveryBoyOrderSummaryModel => _deliveryBoyOrderSummaryModel;
  DeliveryBoyProfileSummaryModelResponse? get deliveryBoyProfileSummaryModel => _deliveryBoyProfileSummaryModel;
  bool get newOrderAssigned => _newOrderAssigned;
  DateTime? get selectedDate => _selectedDate;

  /// **Set Loading State for UI**
  void setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// **Set Error State for UI**
  void _setErrorState(String message) {
    _errorMessage = message;
    setLoadingState(false);
    notifyListeners(); // Ensure UI rebuilds
  }

  /// **Initialize Socket Connection**
  void initializeSocket() {
    String deliveryBoyId = StorageHelper().getDeliveryBoyId();

    _socket = IO.io(
      "${Repository.baseUrl}", // Replace with actual server URL
      IO.OptionBuilder()
          .setTransports(["websocket"])
          .setQuery({"deliveryBoyId": deliveryBoyId}) // Pass delivery boy ID to identify
          .setExtraHeaders({"autoConnect": "true"}) // This replaces `setAutoConnect`
          .build(),
    );

    _socket.onConnect((_) {
      print("✅ Connected to Socket.IO Server");
    });

    // _socket.on("orderPlaced", (data) {
    //   print("🔔 New Order Assigned: $data");
    //
    //   _newOrderAssigned = true;
    //   notifyListeners();
    //
    //   fetchDeliveryBoyOrderList("confirmed"); // Refresh orders list
    // });

    _socket.on("privateMessage", (data) {
      print("🔔 New Order Assigned: $data");

      _newOrderAssigned = true;
      notifyListeners();

      fetchDeliveryBoyOrderList("confirmed"); // Refresh orders list
    });

    _socket.emit("joinRoom",deliveryBoyId);

    _socket.onDisconnect((_) => print("❌ Disconnected from Socket.IO Server"));
  }

  void callEmit(){
    _socket.emit("don","Emit message triggered");

    _newOrderAssigned = true;
    notifyListeners();
  }

  /// **Reset New Order Notification**
  void resetNewOrderNotification() {
    _newOrderAssigned = false;
    notifyListeners();
  }
  /// **Disconnect Socket on Logout**
  void disconnectSocket() {
    _socket.disconnect();
  }


  /// **Fetch Delivery Boy Order List**
  Future<bool> fetchDeliveryBoyOrderList(String status) async {
    setLoadingState(true);
    _errorMessage = "";
    _deliveryBoyOrderListModel = null;
    _orderList.clear();

    try {
      String deliveryBoyId = StorageHelper().getDeliveryBoyId();
      var response = await _repository.getDeliveryBoyOrderList(deliveryBoyId);

      if (response != null && response.success == true && response.data != null) {
        print("✅ Order List Fetched Successfully");

        _deliveryBoyOrderListModel = response;
        _orderList = response.data!.orderDetails
            ?.where((order) => order.bookingStatus == status)
            .toList() ??
            [];
        setLoadingState(false);
        return true;
      } else {
        _setErrorState(response.message ?? "Failed to fetch order list");
      }
    } catch (error) {
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }
  /// **Filter Orders by Selected Date**
  void setFilterDate(DateTime? date) {
    _selectedDate = date;

    if (date == null) {
      _orderList = List.from(_orderList); // Reset filter
    } else {
      String selectedDateStr = "${date.year}-${date.month}-${date.day}";
      _orderList = _orderList
          .where((order) => order.bookingDate!.startsWith(selectedDateStr))
          .toList();
    }

    notifyListeners();
  }


  /// **Fetch Delivery Boy Order List**
  Future<bool> fetchDeliveryBoyOrderDetails(String orderId) async {
    setLoadingState(true);
    _errorMessage = "";
    _deliveryBoyOrderDetailModel = null;

    try {
      var response = await _repository.getDeliveryBoyOrderDetail(orderId);

      if (response != null && response.success == true && response.data != null) {
        print("✅ Order Details Fetched Successfully");

        _deliveryBoyOrderDetailModel = response;
        setLoadingState(false);
        return true;
      } else {
        _setErrorState(response.message ?? "Failed to fetch order details");
      }
    } catch (error) {
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }
  /// **Fetch Delivery Boy Order List**
  Future<bool> changeOrderStatus(String orderStatus , String orderId) async {
    // _setLoadingState(true);
    _errorMessage = "";
    _changeOrderStatusModel = null;

    try {

      Map<String, dynamic> requestBody = {"newStatus": orderStatus};

      var response = await _repository.changeOrderStatus(requestBody,orderId);
      if (response != null && response.success == true && response.order != null) {
        print("✅ Order Details Fetched Successfully");

        _changeOrderStatusModel = response;
        notifyListeners(); // Notify UI about the update
        // _setLoadingState(false);
        return true;
      } else {
        _setErrorState(response.message ?? "Failed to fetch order details");
      }
    } catch (error) {
      _setErrorState("⚠️ API Error: $error");
    }

    // _setLoadingState(false);
    return false;
  }


  /// **Fetch Delivery Boy Order List**
  Future<bool> fetchDeliveryBoyOrderSummary( ) async {
    setLoadingState(true);
    _errorMessage = "";
    _deliveryBoyOrderSummaryModel = null;

    try {
      String deliveryBoyId = StorageHelper().getDeliveryBoyId();
      print("deliveryBoyid=>${deliveryBoyId}");
      var response = await _repository.getDeliveryBoyOrderSummary(deliveryBoyId);

      if (response != null && response.success == true && response.data != null) {
        print("✅ Order Details Fetched Successfully");

        _deliveryBoyOrderSummaryModel = response;
        setLoadingState(false);
        return true;
      } else {
        _setErrorState("Failed to fetch order details");
      }
    } catch (error) {
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }


  Future<bool> fetchDeliveryBoyProfileSummary( ) async {
    setLoadingState(true);
    _errorMessage = "";
    _deliveryBoyProfileSummaryModel = null;

    try {
      String deliveryBoyId = StorageHelper().getDeliveryBoyId();
      var response = await _repository.getDeliveryBoyProfileSummary(deliveryBoyId);

      if (response != null && response.success == true && response.data != null) {
        print("✅ Order Details Fetched Successfully");

        _deliveryBoyProfileSummaryModel = response;
        setLoadingState(false);
        return true;
      } else {
        _setErrorState("Failed to fetch details");
      }
    } catch (error) {
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }

}
