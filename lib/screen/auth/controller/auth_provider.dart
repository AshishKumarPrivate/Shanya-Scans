import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:healthians/network_manager/repository.dart';
import 'package:healthians/screen/auth/otp_screen.dart';
import 'package:healthians/screen/other/screen/user_selection_screen.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:healthians/ui_helper/storage_helper.dart';
import '../../../bottom_navigation_screen.dart';
import '../../../network_manager/api_error_handler.dart';
import '../../../ui_helper/snack_bar.dart';
import '../login_screen.dart';

class AuthApiProvider with ChangeNotifier {
  final Repository _repository = Repository();
  bool _isLoading = false;

  bool _isOtpSent = false; // Added to track OTP state

  bool get isLoading => _isLoading;
  bool get isOtpSent => _isOtpSent;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void reset() {
    _setLoading(false);
  }

  Future<void> signUpUser( BuildContext context, String name, String email, String password) async {
    _setLoading(true);
    try {
      Map<String, dynamic> requestBody = {
        "name": name,
        "email": email,
        "password": password
      };
      var response = await _repository.userSignUp(requestBody);

      if (response.success) {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OTPScreen(email)));
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: "Sign-up successful! Please verify OTP.",
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 2),
        );
      } else {
        print("❌ Unexpected response format: $response");
        _handleSignupErrors(context, response.message);
        throw Exception("Invalid API response format");
      }
    } on DioException catch (e) {
      print("❌ DioException occurred: $e");
      String errorMessage = ApiErrorHandler.handleError(e);
      showCustomSnackbarHelper.showSnackbar(
        context: context,
        message: errorMessage,
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      );
    } catch (e) {
      // print("Stacktrace: $stacktrace");
      // showCustomSnackbarHelper.showSnackbar(
      //   context: context,
      //   message: "Account already exists! Try logging in",
      //   backgroundColor: Colors.red,
      //   duration: Duration(seconds: 3),
      // );
      _handleUnexpectedErrors(context, e, "Account already exists! Try logging in");
    }
    // finally {
    //   print("finalyy block ");
      _setLoading(false);
    // }
  }

  Future<bool> getOtp(BuildContext context, String email, String otp) async {
    _setLoading(true);
    try {
      Map<String, dynamic> requestBody = {"email": email, "otp": otp};
      var response = await _repository.verifyOtp(requestBody);

      if (response.success == true) {
        await StorageHelper().setOtpVerified(true);
        await _storeUserData(response);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => BottomNavigationScreen()));
        return true;
      } else {
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: "Invalid OTP!",
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
    } on DioException catch (e) {
      _handleDioErrors(context, e);
    } catch (e) {
      _handleUnexpectedErrors(context, e, "Otp Verification Failed");
    } finally {
      _setLoading(false);
    }
    return false;
  }

  Future<bool> getResendOtp(BuildContext context, String email) async {
    _setLoading(true);
    try {
      Map<String, dynamic> requestBody = {"email": email};
      var response = await _repository.resendOtp(requestBody);
      showCustomSnackbarHelper.showSnackbar(
        context: context,
        message: response,
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 3),
      );
    } on DioException catch (e) {
      _handleDioErrors(context, e);
    } finally {
      _setLoading(false);
    }
    return false;
  }

  Future<void> loginUser(
      BuildContext context, String email, String password) async {
    _setLoading(true);
    try {
      Map<String, dynamic> requestBody = {"email": email, "password": password};
      var response = await _repository.userLogin(requestBody);

      if (response.success == true) {
        bool isOtpVerified = await StorageHelper().getOtpVerified();
        if (!isOtpVerified) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => OTPScreen(email)));
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => BottomNavigationScreen()));
        }
        // showCustomSnackbarHelper.showSnackbar(
        //   context: context,
        //   message: response.message ?? 'Login successful!',
        //   backgroundColor: AppColors.primary,
        //   duration: Duration(seconds: 2),
        // );
      } else {
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: "User not exist" ?? 'Login failed!',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
    } on DioException catch (e) {
      _handleDioErrors(context, e);
    } catch (e) {
      _handleUnexpectedErrors(context, e, "User not exist! Please SignUp");
    } finally {
      _setLoading(false);
    }
  }

  // Add method to manually update `isOtpSent`
  void setOtpSent(bool value) {
    _isOtpSent = value;
    notifyListeners();
  }


  Future<bool> forgetPassword(BuildContext context, String email) async {
    _setLoading(true);
    try {
      Map<String, dynamic> requestBody = {"email": email};
      var response = await _repository.forgetPassword(requestBody);

      if (response["success"] == true) {
        setOtpSent(true); // Update OTP sent state
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: response["message"] ?? "Reset link sent to your email!",
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 2),
        );
        return true;
      } else {
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: response["message"] ?? "Failed to send reset link!",
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
    } on DioException catch (e) {
      _handleDioErrors(context, e);
    } catch (e) {
      _handleUnexpectedErrors(context, e, "Something went wrong!");
    } finally {
      _setLoading(false);
    }
    return false;
  }

  Future<bool> resetPassword(
      BuildContext context, String email, String code, String newPassword) async {
    _setLoading(true);
    try {
      Map<String, dynamic> requestBody = {
        "email": email,
        "code": code,
        "newPassword": newPassword,
      };

      var response = await _repository.resetPassword(requestBody);

      if (response["success"] == true) {
        setOtpSent(false); // Update OTP sent state
        StorageHelper().setPassword(newPassword);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BottomNavigationScreen()));
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: response["message"] ?? "Password reset successfully!",
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 2),
        );
        return true;
      } else {
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: response["message"] ?? "Password reset failed!",
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
    } on DioException catch (e) {
      _handleDioErrors(context, e);
    } catch (e) {
      _handleUnexpectedErrors(context, e, "Something went wrong!");
    } finally {
      _setLoading(false);
    }
    return false;
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
      StorageHelper()
          .setWhatsappNumber(response.data!.whatsappNumber.toString());
      await StorageHelper().saveOrderListFromApi(response);
    } else {
      await StorageHelper().clearOrderList();
    }
  }

  Future<void> updateProfile(BuildContext context, String userId, String name,
      String phoneNumber, String age) async {
    _setLoading(true);
    try {
      Map<String, dynamic> requestBody = {
        "name": name,
        "phoneNumber": phoneNumber,
        "age": age,
      };

      var response = await _repository.updateProfile(userId, requestBody);

      if (response.success == true) {
        StorageHelper().setUserName(response.data!.name.toString());
        StorageHelper().setPhoneNumber(response.data!.phoneNumber.toString());
        StorageHelper()
            .setWhatsappNumber(response.data!.whatsappNumber.toString());
        StorageHelper().setAge(response.data!.age.toString());

        Navigator.push(context,
            MaterialPageRoute(builder: (context) => BottomNavigationScreen()));
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: response.message.toString(),
          backgroundColor: AppColors.primary,
          duration: Duration(seconds: 2),
        );
      } else {
        _handleSignupErrors(context, response.message.toString());
      }
    } on DioException catch (e) {
      _handleDioErrors(context, e);
    } catch (e) {
      _handleUnexpectedErrors(context, e, "SignUp Failed! Please try again");
    } finally {
      _setLoading(false);
    }
  }

  void _handleSignupErrors(BuildContext context, String message) {
    showCustomSnackbarHelper.showSnackbar(
      context: context,
      message: message.contains("User Already Exists")
          ? "Account already exists! Try logging in."
          : message,
      backgroundColor:
          message.contains("User Already Exists") ? Colors.orange : Colors.red,
      duration: Duration(seconds: 2),
    );
  }

  void _handleDioErrors(BuildContext context, DioException e) {
    showCustomSnackbarHelper.showSnackbar(
      context: context,
      message: ApiErrorHandler.handleError(e),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
  }

  void _handleUnexpectedErrors(
      BuildContext context, dynamic e, String message) {
    showCustomSnackbarHelper.showSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
  }
}
