import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shanya_scans/network_manager/repository.dart';
import 'package:shanya_scans/screen/order/model/MyOrderHistoryListModel.dart';
import 'package:shanya_scans/screen/order/model/OrderItem.dart';
import 'package:shanya_scans/screen/order/screen/OrderSuccessScreen.dart';
import 'package:shanya_scans/ui_helper/storage_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network_manager/api_error_handler.dart';
import '../../../ui_helper/snack_bar.dart';
import '../model/CreateOrder2ModelResponse.dart';

class OrderApiProvider with ChangeNotifier {
  final Repository _repository = Repository();
  bool _isLoading = false;
  String _errorMessage = "";
  CreateOrder2ModelResponse? _createOrderModelResponse;
  // CreateOrderModelResponse? _createOrderModelResponse;
  MyOrderHistoryListModel? _myOrderHistoryListModel;

  List<OrderItem> _orderItems = [];
  List<OrderItem> get testScanItem => _orderItems;

  bool get isOrderEmpty => _orderItems.isEmpty;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  CreateOrder2ModelResponse? get createOrderModelResponse =>
      _createOrderModelResponse;
  // CreateOrderModelResponse? get createOrderModelResponse => _createOrderModelResponse;
  MyOrderHistoryListModel? get myOrderHistoryListModel =>
      _myOrderHistoryListModel;

  void reset() {
    _isLoading = false;
    notifyListeners();
  }

  void notiFylistener() {
    notifyListeners();
  }

  void _setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setErrorState(String message) {
    _errorMessage = message;
    _setLoadingState(false);
    notifyListeners();
  }
  // add order item to list

  // 🟢 Increase Quantity of an Item
  void increaseQuantity(BuildContext context, String id) {
    int index = _orderItems.indexWhere((item) => item.id == id);

    if (index != -1) {
      if (_orderItems[index].quantity < 5) {
        _orderItems[index] = OrderItem(
          id: _orderItems[index].id,
          name: _orderItems[index].name,
          category: _orderItems[index].category,
          price: _orderItems[index].price,
          imageUrl: _orderItems[index].imageUrl,
          orderType: _orderItems[index].orderType,
          packageDetail: _orderItems[index].packageDetail,
          quantity: _orderItems[index].quantity + 1,
        );

        saveSingleTestScanItem(); // Save updated cart
        notifyListeners();
      } else {
        // Show Snackbar when quantity exceeds 5
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("You can't add more than 5 items."),
              duration: Duration(seconds: 2)),
        );
      }

      saveSingleTestScanItem(); // Save updated cart
      notifyListeners();
    }
  }

  // 🟢 Decrease Quantity of an Item
  void decreaseQuantity(BuildContext context, String id) {
    int index = _orderItems.indexWhere((item) => item.id == id);
    if (index != -1 && _orderItems[index].quantity > 1) {
      _orderItems[index] = OrderItem(
        id: _orderItems[index].id,
        name: _orderItems[index].name,
        category: _orderItems[index].category,
        price: _orderItems[index].price,
        imageUrl: _orderItems[index].imageUrl,
        orderType: _orderItems[index].orderType,
        packageDetail: _orderItems[index].packageDetail,
        quantity: _orderItems[index].quantity - 1,
      );

      saveSingleTestScanItem(); // Save updated cart
      notifyListeners();
    } else if (index != -1 && _orderItems[index].quantity == 1) {
      // Remove item if quantity reaches 0
      // removeFromCart(null, id);
      OrderItem? removedItem = _orderItems.firstWhere((item) => item.id == id,
          orElse: () => OrderItem.empty());
      _orderItems.removeWhere((item) => item.id == id);
      saveSingleTestScanItem(); // Save updated cart
      notifyListeners();
    }
  }

  // 🟢 Remove Item from Cart
  void removeFromCart(BuildContext context, String id) {
    OrderItem? removedItem = _orderItems.firstWhere((item) => item.id == id,
        orElse: () => OrderItem.empty());
    _orderItems.removeWhere((item) => item.id == id);
    saveSingleTestScanItem(); // Save updated cart
    notifyListeners();

    if (removedItem.id.isNotEmpty) {
      showCustomSnackbarHelper.showSnackbar(
        context: context,
        backgroundColor: Colors.red,
        message: "${removedItem.name} removed from cart ",
        duration: Duration(seconds: 2),
      );
    }
  }

  Future<void> saveSingleTestScanItem() async {
    final prefs = await SharedPreferences.getInstance();
    // final String encodedItem = jsonEncode(item.toJson());
    final String encodedList =
        jsonEncode(_orderItems.map((item) => item.toJson()).toList());
    await prefs.setString('single_test_scan_item', encodedList);
  }

  Future<OrderItem?> loadSingleTestScanItem() async {
    final prefs = await SharedPreferences.getInstance();
    final String? encodedItem = prefs.getString('single_test_scan_item');

    if (encodedItem != null) {
      return OrderItem.fromJson(jsonDecode(encodedItem));
    }
    return null;
  }

  // 🟢 Add Item to Cart
  void addToOrderReview(BuildContext context, OrderItem item) {
    int index = _orderItems.indexWhere((element) => element.id == item.id);

    if (index != -1) {
      _orderItems[index] = OrderItem(
        id: item.id,
        name: item.name,
        category: item.category,
        price: item.price,
        imageUrl:
            item.imageUrl ?? OrderItem.defaultImage, // ✅ Ensure default image
        // imageUrl: item.imageUrl,
        packageDetail: item.packageDetail,
        orderType: _orderItems[index].orderType,
        quantity: _orderItems[index].quantity + 1,
      );
    } else {
      _orderItems.add(item);
    }

    saveSingleTestScanItem(); // Save updated cart
    notifyListeners();
    // ✅ Show Snackbar from Helper
    // showCustomSnackbarHelper.showSnackbar(
    //   context: context,
    //   message: "${item.name} added to your cart!",
    //   duration: Duration(seconds: 2),
    // );
  }

  Future<bool> createOrder(
      BuildContext context,
      String testName,
      String bookingDate,
      String bookingTime,
      String category,
      String rate,
      String email,
      String name,
      String age,
      String phone,
      String altPhone,
      String gender,
      String cityState) async {
    _setLoadingState(true);
    _errorMessage = "";
    _createOrderModelResponse = null;

    try {
      Map<String, dynamic> requestBody = {
        "testName": testName,
        "bookingDate": bookingDate,
        "bookingTime": bookingTime,
        "category": category,
        "rate": rate,
        "email": email,
        "name": name,
        "age": age,
        "phone": phone,
        "altPhone": altPhone,
        "gender": gender,
        "cityState": cityState
      };

      var response = await _repository.createOrderResponse(requestBody);

      if (response.success == true && response.data != null) {
        print("✅ Order created successfully!");
        _createOrderModelResponse = response;
        _setLoadingState(false);

        // OrderItem orderItem = OrderItem(
        //   id: response.data!.sId ?? "",
        //   name: testName,
        //   price: rate,
        //   imageUrl: "",
        //   packageDetail: "",
        // );
        //
        // saveSingleTestScanItem(orderItem);
        // notifyListeners();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => OrderSuccessScreen()),
        );
        return true;
      } else {
        _setErrorState(response.message ?? "Failed to create order");
      }
    } on DioException catch (e) {
      String errorMessage = ApiErrorHandler.handleError(e);
      _setErrorState(errorMessage);
      print("⚠️ Order API Error: $errorMessage");
      showCustomSnackbarHelper.showSnackbar(
        context: context,
        message: errorMessage,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      );
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }



  // &&&&&&&&&&& order history &&&&&&&&&&&&&&&&&
  /// **Fetch Home Service List API**
  Future<bool> getOrderHistory(BuildContext context) async {
    _setLoadingState(true);
    _errorMessage = "";
    _myOrderHistoryListModel = null;

    try {
      var userId = StorageHelper().getUserId();
      print("UserId=> ${userId}");

      // Map<String, dynamic> requestBody = {"id": userId};
      var response = await _repository.getOrderHistoryResponse(userId);

      if (response.success == true &&
          response.data != null) {
        print("✅ User Order History  Fetched Successfully");
        _myOrderHistoryListModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _myOrderHistoryListModel = null;
        _setErrorState(response.message ?? "Failed to fetch  User Order History  list");
      }
    } catch (error) {
      _myOrderHistoryListModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }
}
