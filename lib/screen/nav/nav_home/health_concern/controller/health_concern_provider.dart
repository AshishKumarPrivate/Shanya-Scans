import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shanya_scans/network_manager/repository.dart';
import 'package:shanya_scans/screen/nav/nav_home/health_concern/model/HealthConcernPacakageTagModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static const String _cacheKey = 'cached_home_health_concern';
  static const String _cacheTimeKey = 'cached_home_health_concern_time';

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

  /// Load cache first, then decide to fetch from API
  Future<void> loadCachedHomeHealthConcern({bool forceRefresh = false}) async {
    _setLoadingState(true);
    final prefs = await SharedPreferences.getInstance();

    final cachedData = prefs.getString(_cacheKey);
    final cachedTime = prefs.getInt(_cacheTimeKey);

    if (cachedData != null) {
      try {
        _healthConcernPackageTagModel = HealthConcernPackageTagModel.fromJson(json.decode(cachedData));
        print("✅ Loaded from Cache");
        notifyListeners();
      } catch (e) {
        print("⚠️ Error parsing cached data: $e");
      }
    }

    // Optional: Add cache expiry logic (e.g. 24 hours = 86400 sec)
    final isExpired = cachedTime == null || DateTime.now().millisecondsSinceEpoch - cachedTime > 86400000;

    if (forceRefresh || cachedData == null || isExpired) {
      print("⏳ Cache expired or force refresh. Fetching new data...");
      await getHealthConcernTagList();
    } else {
      _setLoadingState(false);
      print("✅ Cache is fresh. Skipping API call.");
    }
  }


  /// **Fetch Home Service List API**
  Future<bool> getHealthConcernTagList( ) async {
    _setLoadingState(true);
    _errorMessage = "";
    _healthConcernPackageTagModel = null;

    final prefs = await SharedPreferences.getInstance();
    final oldCache = prefs.getString(_cacheKey);
    try {
      var response =  await _repository.getHealthConcerListTag();

      if (response.success == true && response.data != null) {
        print("✅ Health Concern Tag List Fetched Successfully");
        final newData = json.encode(response.toJson());

        if (oldCache == null || oldCache != newData) {
          await prefs.setString(_cacheKey, newData);
          await prefs.setInt(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
          print("✅ New data cached successfully!");
        } else {
          print("🔁 Data unchanged. Using existing cache.");
        }

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

      if (response.success == true && response.data != null) {
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
