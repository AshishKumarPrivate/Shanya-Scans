import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:healthians/network_manager/repository.dart';
import 'package:healthians/screen/service/model/HomeServiceDetailModel.dart'
    as HomeDetailModel;
import 'package:healthians/screen/service/model/HomeServiceListModel.dart'
    as HomeListModel;
import 'package:healthians/screen/service/model/ServiceDetailRateListModel.dart'
    as RateModel;

class ServiceApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  HomeListModel.HomeServiceListModel? _homeServiceListModel;
  HomeDetailModel.HomeServiceDetailModel? _homeServiceDetailModel;
  RateModel.ServiceDetailRateListModel? _serviceRateListModel;

  List<HomeListModel.Data> _scanList = [];

  List<HomeListModel.Data> get scanList => _scanList;

  ServiceApiProvider() {
    loadCachedPackages();
  }

  // Getters for UI
  bool get isLoading => _isLoading;

  String get errorMessage => _errorMessage;

  HomeListModel.HomeServiceListModel? get homeServiceListModel =>
      _homeServiceListModel;

  HomeDetailModel.HomeServiceDetailModel? get homeServiceDetailModel =>
      _homeServiceDetailModel;

  RateModel.ServiceDetailRateListModel? get homeDerviceRateListModel =>
      _serviceRateListModel;

  /// &&&&&&&&&&&&&&&&&& strore the service list data in cache api call

  /// **Load Cached Data**
  Future<void> loadCachedPackages() async {
    _setLoadingState(true);
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_health_scanList');

    if (cachedData != null) {
      try {
        final decodeData = json.decode(cachedData);
        if(decodeData is List){
          print("✅ Cache Found: Loading cached scan list...");
          List<dynamic> rawList = json.decode(cachedData);
          _scanList = decodeData.map((e) => HomeListModel.Data.fromJson(e)).toList();
          print("✅ Cache Loaded Successfully! ${_scanList.length} items.");
        }else{
          _scanList = []; // Ensure empty state doesn't break UI
          print("⚠ Cached data is not a List, resetting cache.");

        }
        // print("✅ Cache Found: Loading cached scan list...");
        // List<dynamic> rawList = json.decode(cachedData);
        // _scanList = rawList.map((e) => HomeListModel.Data.fromJson(e)).toList();
        // print("✅ Cache Loaded Successfully! ${_scanList.length} items.");
      } catch (e) {
        _scanList = []; // Ensure empty state doesn't break UI
        print("⚠️ Cache Parsing Error: $e");
      }
    } else {
      _scanList = []; // ✅ Explicitly clear list to trigger shimmer
      print("⚠️ No Cached Data Found!");
    }
    notifyListeners();
    fetchScansList();
  }

  /// **Fetch Home Service List API**
  Future<void> fetchScansList() async {
    print("🛠 fetchScansList() called..."); // ✅ Debugging
    _setLoadingState(true);
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_health_scanList');

    try {
      var response = await _repository.getHomeServiceModelResponse();
      if (response.success == true && response.data != null) {
        print("✅ API Response Received");
        _scanList = List<HomeListModel.Data>.from(response.data!); // ✅ Fixed Type Issue
        // ✅ Compare with cached data
        if (cachedData == json.encode(_scanList)) {
          print("🔄 No Changes in API Data. Cache is Up-to-date!");
        } else {
          print("📁 API Data Changed! Updating Cache...");
          await prefs.setString(
              'cached_health_scanList', json.encode(_scanList));
          print("✅ Cache Updated Successfully!");
        }
      } else {
        _setErrorState(response?.message ?? "Failed to fetch service list");
      }
    } catch (error) {
      _setErrorState("API Error: $error");
    }

    notifyListeners();
    // ✅ Print Cached Data After Fetching
    // final prefs = await SharedPreferences.getInstance();
    // print(
    //     "🔍 Cached Data After Fetch: ${prefs.getString('cached_health_scanList')}");
  }

  Future<void> checkCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('cached_health_scanList');

    if (cachedData == null || cachedData.isEmpty) {
      print("⚠️ No Cached Data Found!");
    } else {
      print("✅ Cached Data Retrieved Successfully: $cachedData");
    }
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_health_scanList');
    print("🗑 Cache Cleared!");
  }

  /// &&&&&&&&&&&&&&&&&& strore the service list data in cahse api call

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
  Future<bool> getHomeServiceList(BuildContext context) async {
    _setLoadingState(true);
    _errorMessage = "";
    _homeServiceListModel = null;

    try {
      var response = await _repository.getHomeServiceModelResponse();

      if (response != null &&
          response.success == true &&
          response.data != null) {
        print("✅ Home Service List Fetched Successfully");

        // Reorder the list before passing it to the GridView
        // Define the priority order
        List<String> priorityItems = [
          "Digital 3.0 Tesla MRI"
              "Digital Gamma Scans",
          "Digital PET CT Scan",
        ];

        // Ensure response.data is a List and sort it based on priority
        response.data!.sort((a, b) {
          bool aIsPriority = priorityItems.contains(a.serviceDetailName);
          bool bIsPriority = priorityItems.contains(b.serviceDetailName);

          if (aIsPriority && !bIsPriority) {
            return -1; // `a` should come first
          } else if (!aIsPriority && bIsPriority) {
            return 1; // `b` should come first
          }
          return 0; // Maintain relative order otherwise
        });

        _homeServiceListModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _homeServiceListModel = null;
        _setErrorState(response.message ?? "Failed to fetch service list");
      }
    } catch (error) {
      _homeServiceListModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }

  /// **Fetch Home Service Detail API**
  Future<bool> getHomeServiceListDetail(
      BuildContext context, String serviceSlug) async {
    _setLoadingState(true);
    _errorMessage = "";
    _homeServiceDetailModel = null;

    try {
      var response =
          await _repository.getHomeServiceDetailResponse(serviceSlug);

      if (response != null &&
          response.success == true &&
          response.data != null) {
        print("✅ Home Service Detail Fetched Successfully");
        _homeServiceDetailModel = response;
        return true;
      } else {
        _homeServiceDetailModel = null;
        _setErrorState(response.message ?? "Failed to fetch service detail");
      }
    } catch (error) {
      _homeServiceDetailModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    _setLoadingState(false);
    return false;
  }

  /// **Fetch Service Detail Rate List API**
  Future<bool> getServiceDetailRateList(
      BuildContext context, String serviceName) async {
    _setLoadingState(true);
    _errorMessage = ""; // Reset error message on each call
    _serviceRateListModel = null; // Reset the model

    try {
      var response = await _repository
          .getServiceDetailRateList({"serviceName": serviceName});

      if (response != null &&
          response.success == true &&
          response.data != null) {
        print("✅ Service Detail Rate List Fetched Successfully");
        _serviceRateListModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _serviceRateListModel = null;
        _setErrorState(response.message ?? "Failed to fetch service rate list");
      }
    } catch (error) {
      _serviceRateListModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }
}
