import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shanya_scans/network_manager/repository.dart';
import 'package:shanya_scans/screen/nav/nav_home/slider/mdel/HomeBanner1ModelResponse.dart';
import 'package:shanya_scans/screen/nav/nav_home/slider/mdel/HomeBanner2ModelResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeBannerApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  HomeBanner1ModelResponse? _homeBanner1Model;
  HomeBanner2ModelResponse? _homeBanner2Model;

  // Getters for UI
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  HomeBanner1ModelResponse? get homeBanner1ListModel => _homeBanner1Model;
  HomeBanner2ModelResponse? get homeBanner2ListModel => _homeBanner2Model;

  /// **Set Loading State for UI**
  void _setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// **Set Error State for UI**
  void _setErrorState(String message) {
    _errorMessage = message;
    _setLoadingState(false);
  }

  /// **Load Cached Banners and Fetch API Only if Needed**
  Future<void> loadCachedBanners() async {
    _setLoadingState(true);
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_home_banners');

    if (cachedData != null) {
      try {
        print("✅ Cache Found: Loading cached banners...");
        _homeBanner1Model =
            HomeBanner1ModelResponse.fromJson(json.decode(cachedData));
        print("✅ Cache Loaded Successfully!");
        notifyListeners();
      } catch (e) {
        _homeBanner1Model = null;
        print("⚠️ Cache Parsing Error: $e");
      }
    } else {
      print("⚠️ No Cached Data Found!");
    }

    // Fetch from API only if cache is empty or outdated
    await getHomeBanner1List();
  }

  /// **Load Cached Banners and Fetch API Only if Needed**
  Future<void> loadCachedBanners1() async {
    _setLoadingState(true);
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_home_banners_1');

    if (cachedData != null) {
      try {
        print("✅ Cache Found: Loading cached banners...");
        _homeBanner2Model = HomeBanner2ModelResponse.fromJson(json.decode(cachedData));
        print("✅ Cache Loaded Successfully!");
        notifyListeners();
      } catch (e) {
        _homeBanner2Model = null;
        print("⚠️ Cache Parsing Error: $e");
      }
    } else {
      print("⚠️ No Cached Data Found!");
    }

    // Fetch from API only if cache is empty or outdated
    await getHomeBanner2List();
  }

  /// **Fetch Home Banner List API with Caching**
  Future<bool> getHomeBanner1List() async {
    _setLoadingState(true);
    _errorMessage = "";

    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_home_banners');

    try {
      var response = await _repository.getHomeBanner2ModelResponse();

      if (response.success == true && response.data != null) {
        print("✅ Home Banner1 List Fetched Successfully");

        String newData = json.encode(response.toJson());

        // Compare new data with cached data
        if (cachedData != null && cachedData == newData) {
          print("🔄 Home Banner1 List. Cache is Up-to-date! ${cachedData.toString()}");
        } else {
          print("📁 API Data Changed! Updating Cache...");
          await prefs.setString('cached_home_banners', newData);
          print("✅ Cache Updated Successfully!");
        }

        _homeBanner1Model = response;
        print("🔄 Home Banner1 List. Cache is Up-to-date! ${_homeBanner1Model.toString()}");
        _setLoadingState(false);
        return true;
      } else {
        _homeBanner1Model = null;
        _setErrorState(response.message ?? "Failed to fetch banner list");
      }
    } catch (error) {
      _homeBanner1Model = null;
      _setErrorState("⚠️ API Error: $error");
    }
    return false;
  }

  /// **Fetch Home Banner List API with Caching**
  Future<bool> getHomeBanner2List() async {
    _setLoadingState(true);
    _errorMessage = "";

    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_home_banners_1');

    try {
      var response = await _repository.getHomeBanner1ModelResponse();

      if (response.success == true && response.data != null) {
        print("✅ Home Banner 2 List Fetched Successfully");

        String newData = json.encode(response.toJson());

        // Compare new data with cached data
        if (cachedData != null && cachedData == newData) {
          print("🔄 No Changes in API Data. Cache is Up-to-date! ${cachedData.toString()}");
        } else {
          print("📁 API Data Changed! Updating Cache...");
          await prefs.setString('cached_home_banners_1', newData);
          print("✅ Cache Updated Successfully!");
        }

        _homeBanner2Model = response;
        _setLoadingState(false);
        return true;
      } else {
        _homeBanner2Model = null;
        _setErrorState(response.message ?? "Failed to fetch banner list");
      }
    } catch (error) {
      _homeBanner2Model = null;
      _setErrorState("⚠️ API Error: $error");
    }
    return false;
  }

  /// **Clear Cache**
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_home_banners');
    print("🗑 Cache Cleared!");
  }
}
