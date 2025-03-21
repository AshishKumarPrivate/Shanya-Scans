import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../screen/auth/model/OtpVerifyModel.dart';

class StorageHelper {
  static final StorageHelper _singleton = StorageHelper._internal();
  static const String _orderDetailsKey = 'order_details';

  factory StorageHelper() {
    return _singleton;
  }

  StorageHelper._internal();

  late SharedPreferences sp;

  Future<void> init() async {
    sp = await SharedPreferences.getInstance();
  }
  /// ✅ Ensure `sp` is initialized before using it
  Future<void> _ensureInitialized() async {
    if (!(_singleton.sp is SharedPreferences)) {
      await init();
    }
  }

  void clear() {
    sp.clear();
  }
  // ✅ Logout Method: Clears stored login data
  /// ✅ Reusable Logout Method
  Future<void> logout() async {
    await _ensureInitialized(); // Ensure SharedPreferences is initialized
    clearUserRole();
    List<String> keysToRemove = [
      'user_access_token',
      'user_id',
      'user_name',
      'email',
      'password',
      'phoneNumber',
      'whatsappNumber',
      'verify',
      'user_profile_image'
    ];

    for (String key in keysToRemove) {
      await sp.remove(key);
      sp.clear();
    }

    print("✅ User logged out successfully!");
  }

  void setRole(String role) {
    sp.setString('role', role);
  }

  String getRole() {
    return sp.getString('role') ?? "";
  }
  static Future<void> clearUserRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("role");
  }


  void setUserAccessToken(String token) {
    sp.setString('user_access_token', token);
  }

  String getUserAccessToken() {
    return sp.getString('user_access_token') ?? "";
  }

  void setUserId(String username) {
    sp.setString('user_id', username);
  }

  String getUserId() {
    return sp.getString('user_id') ?? "";
  }

  // set user order data

  /// Store order details from API response
  Future<void> saveOrderListFromApi(OtpVerifyModel response) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    if (response.data?.orderDetails != null) {
      String jsonString = jsonEncode(
          response.data!.orderDetails!.map((order) => order.toJson()).toList());
      await sp.setString(_orderDetailsKey, jsonString);
    }
  }

  /// Retrieve stored order details
  Future<List<OrderDetails>> getOrderList() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    String? jsonString = sp.getString(_orderDetailsKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => OrderDetails.fromJson(json)).toList();
  }

  /// Clear stored order details
  Future<void> clearOrderList() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.remove(_orderDetailsKey);
  }

  // set user order data


  void setUserName(String username) {
    sp.setString('user_name', username);
  }

  String getUserName() {
    return sp.getString('user_name') ?? "";
  }

  void setEmail(String username) {
    sp.setString('email', username);
  }

  String getEmail() {
    return sp.getString('email') ?? "";
  }

  void setPassword(String passwrod) {
    sp.setString('passwrod', passwrod);
  }

  String getPasswrod() {
    return sp.getString('passwrod') ?? "";
  }

  void setPhoneNumber(String phoneNumber) {
    sp.setString('phoneNumber', phoneNumber);
  }

  String getPhoneNumber() {
    return sp.getString('phoneNumber') ?? "";
  }

  void setAge(String phoneNumber) {
    sp.setString('age', phoneNumber);
  }

  String getAge() {
    return sp.getString('age') ?? "";
  }

  void setWhatsappNumber(String whatsappNumber) {
    sp.setString('whatsappNumber', whatsappNumber);
  }

  String getWhatsappNumber() {
    return sp.getString('whatsappNumber') ?? "";
  }
  void setVerified(bool verify) async {
    await sp.setBool('verify', verify); // Store the boolean value correctly
  }

  Future<bool> isUserVerified() async {
    return sp.getBool('verify') ?? false; // Retrieve the boolean value
  }
  void setProfileImage(String url) {
    sp.setString('user_profile_image', url);
  }

  String getProfileImage() {
    return sp.getString('user_profile_image') ?? "";
  }

  void setDialogShown(bool isDialogShown) {
    sp.setBool('isDialogShown', isDialogShown);
  }

  bool getDialogShown() {
    return sp.getBool('isDialogShown') ?? false;
  }

  //&&&&&&&&&&&&&&&&&&&&&&  DELIVERY BOY LOGIN &&&&&&&&&&&&&&&&&&&&&&

  void setDeliveryBoyId(String username) {
    sp.setString('delivery_boy_id', username);
  }
  String getDeliveryBoyId() {
    return sp.getString('delivery_boy_id') ?? "";
  }

  void setDeliveryBoyEmail(String username) {
    sp.setString('delivery_boy_email', username);
  }

  String getDeliveryBoyEmail() {
    return sp.getString('delivery_boy_email') ?? "";
  }
  void setDeliveryBoyName(String username) {
    sp.setString('delivery_boy_name', username);
  }

  String getDeliveryBoyName() {
    return sp.getString('delivery_boy_name') ?? "";
  }

  void setDeliveryBoyPassword(String username) {
    sp.setString('delivery_boy_password', username);
  }

  String getDeliveryBoyPassword() {
    return sp.getString('delivery_boy_password') ?? "";
  }






}
