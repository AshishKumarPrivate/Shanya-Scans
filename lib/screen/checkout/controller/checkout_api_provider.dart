import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shanya_scans/screen/checkout/model/store_checkout_form_data_model.dart';
import 'package:shanya_scans/screen/order/model/OrderItem.dart';
import 'package:shanya_scans/ui_helper/snack_bar.dart';
import 'package:shanya_scans/ui_helper/storage_helper.dart';
import 'package:shanya_scans/util/StringUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../network_manager/api_error_handler.dart';
import '../../../network_manager/repository.dart';
import '../../order/model/CreateOrder2ModelResponse.dart';
import '../../order/screen/OrderSuccessScreen.dart';
import '../../order/screen/order_failed_screen.dart';
import '../model/payment_checkout_model.dart';

class CheckoutProvider with ChangeNotifier {
  final Repository _repository = Repository();
  List<OrderItem> _checkoutItems = [];
  StoreCheckoutFormDataModel? _formData;

  StoreCheckoutFormDataModel? get formData => _formData;

  bool _isLoading = false;
  String _errorMessage = "";
  String? _razorpayKey;

  late Razorpay _razorpay;

  PaymentCheckoutModel? _checkoutModel;
  PaymentCheckoutModel? get checkoutModel => _checkoutModel;
  CreateOrder2ModelResponse? _createOrderModelResponse;
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  String paymentStatus = '';

  CreateOrder2ModelResponse? get createOrderModelResponse =>  _createOrderModelResponse;
  List<OrderItem> get checkoutItems => _checkoutItems;
  bool get isCheckoutEmpty => _checkoutItems.isEmpty;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String? get razorpayKey => _razorpayKey;


  void reset() {
    _isLoading = false;
    notifyListeners();
  }

  void notiFylistener() {
    notifyListeners();
  }

  void setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setErrorState(String message) {
    _errorMessage = message;
    setLoadingState(false);
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
      _checkoutItems =
          decodedData.map((item) => OrderItem.fromJson(item)).toList();
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

  void saveFormData({
    required String selectedDate,
    required String selectedTime,
    required String email,
    required String fullName,
    required String age,
    required String phone,
    required String altPhone,
    required String gender,
    required String cityAddress,
    required String place,
    required String addressType,
  }) {
    _formData = StoreCheckoutFormDataModel(
      selectedDate: selectedDate,
      selectedTime: selectedTime,
      email: email,
      fullName: fullName,
      age: age,
      phone: phone,
      altPhone: altPhone,
      gender: gender,
      cityAddress: cityAddress,
      place: place,
      addressType: addressType,
    );
    notifyListeners();
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
      String selectedPlace,
      String addressType) async {
    setLoadingState(true);
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
          "bookingDate": _formData!.selectedDate.toString(),
          "bookingTime":  _formData!.selectedTime.toString(),
        };
      }).toList();

      // Construct order details with patient info only once
      List<Map<String, dynamic>> orderDetailsJson = [
        {
          "patientName":  _formData!.fullName.toString(),
          "patientAge":  _formData!.age.toString(),
          "patientGender": StringUtils.toLowerCase( _formData!.gender.toString()),
          "tests": tests, // All tests for the patient
        }
      ];

      // Construct request body
      Map<String, dynamic> requestBody = {
        "email":  _formData!.email.toString(),
        "address":  _formData!.cityAddress.toString(),
        "selectedPlace":  _formData!.place.toString(),
        "addressType":  _formData!.addressType.toString(),
        "phoneNumber":  _formData!.phone.toString(),
        "altPhoneNumber":  _formData!.altPhone.toString(),
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
        setLoadingState(false);

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

    setLoadingState(false);
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

  //  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Paymebt api ****************************************

  // 🟢 Get Total Amount
  double get totalAmount {
    return _checkoutItems.fold(
        0.0, (sum, item) => sum + ((item.price) * item.quantity));
  }

  //// Payment call
  Future<String?> fetchRazorpayKey() async {
    setLoadingState(true);
    // notifyListeners();
    final response = await _repository.getRazorPaymentKey();

    if (response["success"] == true) {
      _razorpayKey = response["key"];
      if (razorpayKey != null) {
        StorageHelper().setPaymentKey(razorpayKey.toString());
        return _razorpayKey;
      } else {
        _razorpayKey = null;
      }
      setLoadingState(false);
      // notifyListeners();
    }
  }

  initRazorpay(BuildContext context) async {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) => _handlePaymentSuccess(response, context));

    // _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    createAndStartPayment(1,"Book Test");
  }

  Future<void> createAndStartPayment( int total,  String forName) async {

    setLoadingState(true);
    final requestBody = {
      "total": 1,
      "forName": "Book Test",
    };
    final result = await _repository.createRazerPayOrder(requestBody);
    _checkoutModel = result;
    // setLoadingState(true);
    if (_checkoutModel?.order?.id != null) {
      var apiKey = await fetchRazorpayKey();
      _startRazorpayPayment(apiKey.toString(), _checkoutModel!);
    }
  }

  void _startRazorpayPayment(String? apiKey, PaymentCheckoutModel model) {
    final order = model.order!;
    var options = {
      'key': apiKey,
      'amount': order.amount, // in paise
      'currency': 'INR',
      'name': 'Shanya App',
      'description': 'Payment for order',
      'order_id': order.id,
      'prefill': {
        'contact': _formData?.phone ?? '',
        'email': _formData?.email ?? '',
      }
    };

    _razorpay.open(options);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response, BuildContext context) async {
    final requestBody = {
      "razorpay_payment_id": response.paymentId!,
      "razorpay_order_id": response.orderId!,
      "razorpay_signature": response.signature!,
    };

    // setLoadingState(true);
    final verified = await _repository.verifyPayment(requestBody);
    if (verified) {
      bool orderCreated = await createOrder(
        context,
        _formData!.selectedDate,
        _formData!.selectedTime,
        _formData!.email,
        _formData!.fullName,
        _formData!.age,
        _formData!.phone,
        _formData!.altPhone,
        _formData!.gender,
        _formData!.cityAddress,
        _formData!.place,
        _formData!.addressType,
      );
      if (orderCreated) {
        paymentStatus = 'Payment and order successful';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => OrderSuccessScreen()),
        );
      } else {
        paymentStatus = 'Payment successful, but order failed';
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => OrderFailedScreen(reason: "Order creation failed"),
          ),
        );
      }
    } else {
      paymentStatus = 'Payment verification failed';
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderFailedScreen(reason: "Payment verification failed"),
        ),
      );
    }

    paymentStatus = verified ? 'Payment successful' : 'Payment verification failed';
    print("payment status => ${paymentStatus}");

    setLoadingState(false);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    paymentStatus = 'Payment failed: ${response.message}';
    print("payment status => ${paymentStatus}");
    setLoadingState(false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    paymentStatus = 'External wallet selected: ${response.walletName}';
    print("payment status => ${paymentStatus}");
    setLoadingState(false);
  }

  void clearRazorpay() {
    _razorpay.clear();
  }

}
