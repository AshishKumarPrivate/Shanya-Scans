import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthians/network_manager/repository.dart';
import 'package:healthians/screen/nav/nav_home/frquently_pathalogy_test/model/FrequentlyPathalogyTagListModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FrequentlyPathalogyTagApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  FrequentlyTagListModel? _frequentlyPathalogyTagListModel;
  // Getters for UI
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  FrequentlyTagListModel? get frequentlyPathalogyTagListModel => _frequentlyPathalogyTagListModel;

  /// **Set Loading State for UI**
  void _setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// **Set Error State for UI**
  void _setErrorState(String message) {
    _errorMessage = message;
    _setLoadingState(false);
    // notifyListeners(); // Ensure UI rebuilds
  }

  /// **Load Cached Banners and Fetch API Only if Needed**
  Future<void> loadCachedFrequentlyHomeLabTest() async {
    _setLoadingState(true);
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_home_lab_test');

    if (cachedData != null) {
      try {
        print("✅ Cache Found: Loading cached banners...");
        _frequentlyPathalogyTagListModel =
            FrequentlyTagListModel.fromJson(json.decode(cachedData));
        print("✅ Cache Loaded Successfully!");
        notifyListeners();
      } catch (e) {
        _frequentlyPathalogyTagListModel = null;
        print("⚠️ Cache Parsing Error: $e");
      }
    } else {
      print("⚠️ No Cached Data Found!");
    }

    // Fetch from API only if cache is empty or outdated
    await getFrequentlyLabTestList();
  }
  /// **Clear Cache**
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_home_lab_test');
    print("🗑 Cache Cleared!");
  }

  /// **Fetch Home Service List API**
  Future<bool> getFrequentlyLabTestList() async {
    _setLoadingState(true);
    _errorMessage = "";

    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_home_lab_test');

    _frequentlyPathalogyTagListModel = null;

    try {
      var response =  await _repository.getFrequentlyLabTestListResponse();

      if (response.success == true && response.data != null) {
        print("✅ Frequently Pathalogy Tag List Fetched Successfully");
        String newData = json.encode(response.toJson());

        // Compare new data with cached data
        if (cachedData != null && cachedData == newData) {
          print("🔄 No Changes in API Data. Cache is Up-to-date!");
        } else {
          print("📁 API Data Changed! Updating Cache...");
          await prefs.setString('cached_home_lab_test', newData);
          print("✅ Cache Updated Successfully!");
        }

        _frequentlyPathalogyTagListModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _frequentlyPathalogyTagListModel = null;
        _setErrorState(response.message ?? "Failed to fetch service list");
      }
    } catch (error) {
      _frequentlyPathalogyTagListModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }
}
