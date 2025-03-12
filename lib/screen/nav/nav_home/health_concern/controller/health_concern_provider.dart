import 'package:flutter/material.dart';
import 'package:healthians/network_manager/repository.dart';
import 'package:healthians/screen/nav/nav_home/health_concern/model/HealthConcernPacakageTagModel.dart';
import 'package:healthians/screen/nav/nav_lab/model/PathalogyTestListDetailModel.dart';
import 'package:healthians/screen/nav/nav_lab/model/PathalogyTestListModel.dart';
import 'package:healthians/screen/service/model/HomeServiceDetailModel.dart';
import 'package:healthians/screen/service/model/HomeServiceListModel.dart';
import 'package:healthians/screen/service/model/ServiceDetailRateListModel.dart';

import '../../../../packages/model/PackageListByTabIdModel.dart';
import '../model/HealthConcernDetailModel.dart';

class HealthConcernApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  HealthConcernPackageTagModel? _healthConcernPackageTagModel;
  HealthConcernDetailModel? _healthConcernDetailModel;

  // Getters for UI
  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  HealthConcernPackageTagModel? get healthConcernPackageTagListModel => _healthConcernPackageTagModel;
  HealthConcernDetailModel? get healthConcernDetailModel => _healthConcernDetailModel;

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
  Future<bool> getHealthConcernTagList(BuildContext context) async {
    _setLoadingState(true);
    _errorMessage = "";
    _healthConcernPackageTagModel = null;

    try {
      var response =  await _repository.getHealthConcerListTag();

      if (response != null && response.success == true && response.data != null) {
        print("✅ Health Concern Tag List Fetched Successfully");
        _healthConcernPackageTagModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _healthConcernPackageTagModel = null;
        _setErrorState(response.message ?? "Failed to fetch service list");
      }
    } catch (error) {
      _healthConcernPackageTagModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }

  Future<bool>  getHealthConcernListDetail(BuildContext context, String healthConcernSlug) async {
    _setLoadingState(true);
    _errorMessage = "";
    _healthConcernDetailModel = null;

    try {
      var response = await _repository.getHealthConcernDetail(healthConcernSlug);

      if (response != null && response.success == true && response.data != null) {
        print("✅ health Concer Detail Fetched Successfully");
        _healthConcernDetailModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _healthConcernDetailModel = null;
        _setErrorState(response.message ?? "Failed to fetch service detail");
      }
    } catch (error) {
      _healthConcernDetailModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }
}
