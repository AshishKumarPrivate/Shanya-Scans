import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:healthians/deliveryBoy/screen/deleivery_boy_dashboard.dart';
import 'package:healthians/network_manager/repository.dart';
import 'package:healthians/screen/auth/otp_screen.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:healthians/ui_helper/storage_helper.dart';
import '../../../network_manager/api_error_handler.dart';
import '../../../ui_helper/snack_bar.dart';
import '../../screen/auth/login_screen.dart';
import '../../screen/other/screen/user_selection_screen.dart';

class DeliveryBoyAuthApiProvider with ChangeNotifier {
  final Repository _repository = Repository();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void reset() {
    _setLoading(false);
  }

  Future<void> deliveryBoyLogin( BuildContext context, String email, String password) async {
    _setLoading(true);
    try {
      Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.deliveryBoyLogin(requestBody);

      if (response.success == true) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DeliveryBoyDashboardScreen()));
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: response.message ?? 'Login successful!',
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        );
      } else {
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: "User not exist" ?? 'Login failed!',
          backgroundColor: AppColors.deliveryPrimary,
          duration: Duration(seconds: 2),
        );
      }
    } on DioException catch (e) {
      _handleDioErrors(context, e);
    } catch (e) {
      _handleUnexpectedErrors(context, e, "User not exist! Please Contact to Authorized Admin");
    } finally {
      _setLoading(false);
    }
  }

  void logoutUser(BuildContext context) {
    _setLoading(true);
    Future.delayed(Duration(seconds: 1), () {
      StorageHelper().logout();
      _setLoading(false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => UserSelectionScreen()),
        (route) => false,
      );
    });
  }

  Future<void> _storeUserData(response) async {
    if (response.data != null) {
      StorageHelper().setUserId(response.data!.sId.toString());
      StorageHelper().setUserName(response.data!.name.toString());
      StorageHelper().setEmail(response.data!.email.toString());
      StorageHelper().setPassword(response.data!.password.toString());
      StorageHelper().setPhoneNumber(response.data!.phoneNumber.toString());
      StorageHelper() .setWhatsappNumber(response.data!.whatsappNumber.toString());
      await StorageHelper().saveOrderListFromApi(response);
    } else {
      await StorageHelper().clearOrderList();
    }
  }

  void _handleDioErrors(BuildContext context, DioException e) {
    showCustomSnackbarHelper.showSnackbar(
      context: context,
      message: ApiErrorHandler.handleError(e),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
  }

  void _handleUnexpectedErrors(  BuildContext context, dynamic e, String message) {
    showCustomSnackbarHelper.showSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
  }


}
