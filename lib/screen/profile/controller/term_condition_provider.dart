import 'package:flutter/material.dart';
import 'package:healthians/network_manager/repository.dart';
import 'package:healthians/screen/profile/termsConditionPrivacyPollicy/terms_conditions_privacy_refund_policy_model.dart';


class TermConditionPrivacyPolicyApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  TermsConditionsPrivacyRefundPolicyModel? _termAndConditionsModel;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  TermsConditionsPrivacyRefundPolicyModel? get termAndConditionsModel => _termAndConditionsModel;


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

  /// **Fetch Home Service List API**
  Future<bool> getTermAndConditions(BuildContext context) async {
    _setLoadingState(true);
    _errorMessage = "";
    _termAndConditionsModel = null;

    try {
      var response = await _repository.getTermAndConditions();

      if (response.success == true && response.data != null) {
        print("✅ Terms And Conditions Fetched Successfully");
        _termAndConditionsModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _termAndConditionsModel = null;
        _setErrorState(response.message ?? "Failed to fetch Terms And Conditions");
      }
    } catch (error) {
      _termAndConditionsModel = null;
      _setErrorState("⚠️Terms And Conditions API Error: $error");
    }

    return false;
  }
  /// **Fetch Home Service List API**
  Future<bool> getPrivacyPolicy(BuildContext context) async {
    _setLoadingState(true);
    _errorMessage = "";
    _termAndConditionsModel = null;

    try {
      var response = await _repository.getPrivacyPolicy();

      if (response.success == true && response.data != null) {
        print("✅Privacy Policy  Fetched Successfully");
        _termAndConditionsModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _termAndConditionsModel = null;
        _setErrorState(response.message ?? "Failed to fetch Terms And Conditions");
      }
    } catch (error) {
      _termAndConditionsModel = null;
      _setErrorState("⚠️Terms And Conditions API Error: $error");
    }

    return false;
  }
  /// **Fetch Home Service List API**
  Future<bool> getRefundPolicy(BuildContext context) async {
    _setLoadingState(true);
    _errorMessage = "";
    _termAndConditionsModel = null;

    try {
      var response = await _repository.getRefundPolicy();

      if (response.success == true && response.data != null) {
        print("✅ Refund Policy Fetched Successfully");
        _termAndConditionsModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _termAndConditionsModel = null;
        _setErrorState(response.message ?? "Failed to fetch Terms And Conditions");
      }
    } catch (error) {
      _termAndConditionsModel = null;
      _setErrorState("⚠️Terms And Conditions API Error: $error");
    }

    return false;
  }




}
