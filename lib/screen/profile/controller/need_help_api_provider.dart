import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:healthians/network_manager/repository.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:healthians/ui_helper/storage_helper.dart';
import '../../../network_manager/api_error_handler.dart';
import '../../../ui_helper/snack_bar.dart';
import '../model/enquiry_need_help_model.dart';

class NeedHelpApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  EnquiryNeedHelpModel? _enquiryNeedHelpModel;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  EnquiryNeedHelpModel? get enquiryNeedHelpModel => _enquiryNeedHelpModel;

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

  /// **Send Help Enquiry API**
  Future<bool> sendEnquiry(
      BuildContext context,
      String firstName,
      String lastName,
      String subject,
      String message,) async {
    _setLoadingState(true);
    _errorMessage = "";
    _enquiryNeedHelpModel = null;

    var userEmail = StorageHelper().getEmail();

    try {
      Map<String, dynamic> requestBody = {
        "firstName": firstName,
        "lastName": lastName,
        "subject": subject,
        "email": userEmail,
        "message": message,
      };

      var response = await _repository.sendEnquiry(requestBody);

      if (response.status == "success" && response.data != null) {
        _enquiryNeedHelpModel = response;
        _setLoadingState(false);

        // Show success snackbar with green color
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: response.message.toString(),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        );

        // Exit the screen and return to the previous screen
        Navigator.of(context).pop();
        return true;
      } else {
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: response.message.toString() ?? 'Failed to send enquiry!',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
        _setErrorState(response.message ?? "Failed to send request");
      }
    } on DioException catch (e) {
      _setErrorState(ApiErrorHandler.handleError(e));
    }

    return false;
  }
}
