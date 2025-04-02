import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:healthians/screen/order/model/OrderItem.dart';
import 'package:healthians/ui_helper/snack_bar.dart';
import 'package:healthians/util/StringUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network_manager/api_error_handler.dart';
import '../../../network_manager/repository.dart';
import '../../order/model/CreateOrder2ModelResponse.dart';
import '../../order/screen/OrderSuccessScreen.dart';

class CheckoutProvider with ChangeNotifier {
  final Repository _repository = Repository();
  List<OrderItem> _checkoutItems = [];

  bool _isLoading = false;
  String _errorMessage = "";

  CreateOrder2ModelResponse? _createOrderModelResponse;
  // CreateOrderModelResponse? _createOrderModelResponse;

  CreateOrder2ModelResponse? get createOrderModelResponse =>
      _createOrderModelResponse;
  // CreateOrderModelResponse? get createOrderModelResponse => _createOrderModelResponse;
  List<OrderItem> get checkoutItems => _checkoutItems;
  bool get isCheckoutEmpty => _checkoutItems.isEmpty;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

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

  // 🟢 Increase Quantity of an Item
  void increaseQuantity(BuildContext context, String id) {
    int index = _checkoutItems.indexWhere((item) => item.id == id);

    if (index != -1) {
      if (_checkoutItems[index].quantity < 5) {
        _checkoutItems[index] = OrderItem(
          id: _checkoutItems[index].id,
          name: _checkoutItems[index].name,
          category: _checkoutItems[index].category,
          price: _checkoutItems[index].price,
          imageUrl: _checkoutItems[index].imageUrl,
          orderType: _checkoutItems[index].orderType,
          packageDetail: _checkoutItems[index].packageDetail,
          quantity: _checkoutItems[index].quantity + 1,
        );

        saveCheckoutItems(); // Save updated cart
        notifyListeners();
      } else {
        // Show Snackbar when quantity exceeds 5
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("You can't add more than 5 items."),
              duration: Duration(seconds: 2)),
        );
      }

      saveCheckoutItems(); // Save updated cart
      notifyListeners();
    }
  }

  // 🟢 Decrease Quantity of an Item
  void decreaseQuantity(BuildContext context, String id) {
    int index = _checkoutItems.indexWhere((item) => item.id == id);
    if (index != -1 && _checkoutItems[index].quantity > 1) {
      _checkoutItems[index] = OrderItem(
        id: _checkoutItems[index].id,
        name: _checkoutItems[index].name,
        category: _checkoutItems[index].category,
        price: _checkoutItems[index].price,
        imageUrl: _checkoutItems[index].imageUrl,
        orderType: _checkoutItems[index].orderType,
        packageDetail: _checkoutItems[index].packageDetail,
        quantity: _checkoutItems[index].quantity - 1,
      );

      saveCheckoutItems(); // Save updated cart
      notifyListeners();
    } else if (index != -1 && _checkoutItems[index].quantity == 1) {
      // Remove item if quantity reaches 0
      // removeFromCart(null, id);
      OrderItem? removedItem = _checkoutItems
          .firstWhere((item) => item.id == id, orElse: () => OrderItem.empty());
      _checkoutItems.removeWhere((item) => item.id == id);
      saveCheckoutItems(); // Save updated cart
      notifyListeners();
    }
  }

  // 🟢 Save Cart to SharedPreferences
  Future<void> saveCheckoutItems() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData =
        jsonEncode(_checkoutItems.map((item) => item.toJson()).toList());
    await prefs.setString('checkout_items', encodedData);
  }

  // 🟢 Load Cart from SharedPreferences
  Future<void> loadCheckoutItems() async {
    final prefs = await SharedPreferences.getInstance();
    final cartData = prefs.getString('checkout_items');

    if (cartData != null) {
      final List<dynamic> decodedData = jsonDecode(cartData);
      _checkoutItems = decodedData.map((item) => OrderItem.fromJson(item)).toList();
      notifyListeners();
    }
  }

  // 🟢 Add Item to Cart
  void addToCheckout(BuildContext context, OrderItem item) {
    int index = _checkoutItems.indexWhere((element) => element.id == item.id);

    if (index != -1) {
      _checkoutItems[index] = OrderItem(
        id: item.id,
        name: item.name,
        category: item.category,
        price: item.price,
        imageUrl: item.imageUrl,
        orderType: item.orderType,
        packageDetail: item.packageDetail,
        quantity: _checkoutItems[index].quantity + 1,
      );
    } else {
      _checkoutItems.clear(); // Clear previous checkout items
      _checkoutItems.add(item);
    }

    saveCheckoutItems(); // Save updated cart
    notifyListeners();
    // ✅ Show Snackbar from Helper
    // showCustomSnackbarHelper.showSnackbar(
    //   context: context,
    //   message: "${item.name} added to your cart!",
    //   duration: Duration(seconds: 2),
    // );
  }

  // 🟢 Add Multiple Items to Cart in CheckoutProvider
  void addMultipleToCheckout(BuildContext context, List<OrderItem> items) {
    for (var item in items) {
      int index = _checkoutItems.indexWhere((element) => element.id == item.id);

      if (index != -1) {
        _checkoutItems[index] = OrderItem(
          id: item.id,
          name: item.name,
          category: item.category,
          price: item.price,
          imageUrl: item.imageUrl,
          orderType: item.orderType,
          packageDetail: item.packageDetail,
          quantity: _checkoutItems[index].quantity + item.quantity,
        );
      } else {
        _checkoutItems.add(item);
      }
    }

    saveCheckoutItems(); // Save updated cart
    notifyListeners();

    // ✅ Show Snackbar
    showCustomSnackbarHelper.showSnackbar(
      context: context,
      message: "Items added to checkout!",
      duration: Duration(seconds: 2),
    );
  }

  // 🟢 Remove Item from Cart
  void removeFromCart(BuildContext context, String id) {
    OrderItem? removedItem = _checkoutItems.firstWhere((item) => item.id == id,
        orElse: () => OrderItem.empty());
    _checkoutItems.removeWhere((item) => item.id == id);
    saveCheckoutItems(); // Save updated cart
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

  Future<bool> createOrder(
      BuildContext context,
      String bookingDate,
      String bookingTime,
      String email,
      String name,
      String age,
      String phone,
      String altPhone,
      String gender,
      String cityState,
      String addressType

      ) async {
    _setLoadingState(true);
    _errorMessage = "";
    _createOrderModelResponse = null;

    try {
      // Convert order details list to JSON format
      // List<Map<String, dynamic>> orderDetailsJson = _checkoutItems.map((orderDetail) {
      //   return {
      //     "patientName": name,
      //     "patientAge": age,
      //     "patientGender": gender,
      //     "tests": _checkoutItems.map((test) {
      //       return {
      //         // "id": test.id,
      //         "name": test.name,
      //         "price": test.price,
      //         "category": test.category,
      //         "orderType": test.orderType,
      //         "quantity": test.quantity,
      //         "bookingDate": bookingDate,
      //         "bookingTime": bookingTime,
      //       };
      //     }).toList(),
      //   };
      // }).toList();

      // Convert checkout items into structured order details
      // Collect all tests for the single patient
      List<Map<String, dynamic>> tests = _checkoutItems.map((test) {
        return {
          "orderName": test.name, // Test Name
          "quantity": test.quantity,
          "category": test.category,
          "orderType": test.orderType,
          "orderPrice": test.price,
          "bookingDate": bookingDate,
          "bookingTime": bookingTime,
        };
      }).toList();

      // Construct order details with patient info only once
      List<Map<String, dynamic>> orderDetailsJson = [
        {
          "patientName": name,
          "patientAge": age,
          "patientGender": StringUtils.toLowerCase(gender),
          "tests": tests, // All tests for the patient
        }
      ];

      // Construct request body
      Map<String, dynamic> requestBody = {
        "email": email,
        "address": cityState,
        "addressType": addressType,
        "phoneNumber": phone,
        "altPhoneNumber": altPhone,
        "orderDetails": orderDetailsJson,
      };

      // Debugging log
      print("bodyRequest => ${requestBody.toString()}");

      // Map<String, dynamic> requestBody = {
      //   "testName": testName,
      //   "bookingDate": bookingDate,
      //   "bookingTime": bookingTime,
      //   "category": category,
      //   "rate": rate,
      //   "email": email,
      //   "name": name,
      //   "age": age,
      //   "phone": phone,
      //   "altPhone": altPhone,
      //   "gender": gender,
      //   "cityState": cityState
      // };

      var response = await _repository.createOrderResponse(requestBody);

      print("bodyRequest=>${requestBody.toString()}");
      if (response.success == true && response.data != null) {
        print("✅ Order created successfully!");
        _createOrderModelResponse = response;
        _setLoadingState(false);

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

    _setLoadingState(false);
    return false;
  }

  // 🟢 Clear Cart
  void clearCheckout(BuildContext context) {
    _checkoutItems.clear();
    // saveCheckoutItems(); // Save updated cart
    notifyListeners();
    showCustomSnackbarHelper.showSnackbar(
      context: context,
      message: "Order has  cleared",
      duration: Duration(seconds: 2),
    );
  }

  // 🟢 Get Total Amount
  double get totalAmount {
    return _checkoutItems.fold(
        0.0, (sum, item) => sum + ((item.price) * item.quantity));
  }
}
