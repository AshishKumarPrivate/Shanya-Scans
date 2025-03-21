import 'package:flutter/material.dart';
import 'package:healthians/deliveryBoy/model/ChangeOrderStatusModelResponse.dart';
import 'package:healthians/deliveryBoy/model/DeliveryBoyOrderDetailModel.dart';
import 'package:healthians/deliveryBoy/model/DeliveryOrderLIstModel.dart' as deliveryBoyOrder;
import 'package:healthians/ui_helper/storage_helper.dart';
import '../../network_manager/repository.dart';

class DeliveryOrdersProvider extends ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  deliveryBoyOrder.DeliveryBoyOrderListModel? _deliveryBoyOrderListModel;
  DeliveryBoyOrderDetailModel? _deliveryBoyOrderDetailModel;
  ChangeOrderStatusModelResponse? _changeOrderStatusModel;
  List<deliveryBoyOrder.OrderDetails> _orderList = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<deliveryBoyOrder.OrderDetails> get orderList => _orderList;
  DeliveryBoyOrderDetailModel? get orderDetail => _deliveryBoyOrderDetailModel;
  ChangeOrderStatusModelResponse? get changeOrderStatusModel => _changeOrderStatusModel;

  /// **Set Loading State for UI**
  void _setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// **Set Error State for UI**
  void _setErrorState(String message) {
    _errorMessage = message;
    _setLoadingState(false);
    notifyListeners(); // Ensure UI rebuilds
  }

  /// **Fetch Delivery Boy Order List**
  Future<bool> fetchDeliveryBoyOrderList(String status) async {
    _setLoadingState(true);
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
        _setLoadingState(false);
        return true;
      } else {
        _setErrorState(response.message ?? "Failed to fetch order list");
      }
    } catch (error) {
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }

   /// **Fetch Delivery Boy Order List**
  Future<bool> fetchDeliveryBoyOrderDetails(String orderId) async {
    _setLoadingState(true);
    _errorMessage = "";
    _deliveryBoyOrderDetailModel = null;

    try {
      var response = await _repository.getDeliveryBoyOrderDetail(orderId);

      if (response != null && response.success == true && response.data != null) {
        print("✅ Order Details Fetched Successfully");

        _deliveryBoyOrderDetailModel = response;
        _setLoadingState(false);
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

}
