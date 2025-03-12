import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthians/network_manager/repository.dart';
import 'package:healthians/screen/nav/nav_lab/model/PathalogyTestListDetailModel.dart';
import 'package:healthians/screen/nav/nav_lab/model/PathalogyTestListModel.dart' as pathalogyTestList;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../network_manager/dio_helper.dart';

class PathalogyTestApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  bool _isFetchingMore = false; // To track pagination state
  pathalogyTestList.PathalogyTestListModel? _pathalogyTestListModel;
  PathalogyScansListDetailModel? _pathalogyTestListDetailModel;


  List<pathalogyTestList.Data> _filteredPathalogyTest = [];
  int _currentPage = 1;
  final int _perPage = 10; // Adjust per API limit

  // Getters for UI
  bool get isFetchingMore => _isFetchingMore;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  pathalogyTestList.PathalogyTestListModel? get pathalogyTestListModel => _pathalogyTestListModel;
  PathalogyScansListDetailModel? get pathalogyTestListDetailModel => _pathalogyTestListDetailModel;
  List<pathalogyTestList.Data> get filteredPathalogyTest => _filteredPathalogyTest;


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
  void _setFetchingMoreState(bool fetching) {
    _isFetchingMore = fetching;
    notifyListeners();
  }


  Future<void> loadCachedNavPathalogyTests(BuildContext context) async {
    _setLoadingState(true);
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_pathalogy_tests');

    if (cachedData != null) {
      try {
        print("✅ Loading cached pathology test data...");
        _pathalogyTestListModel = pathalogyTestList.PathalogyTestListModel.fromJson(json.decode(cachedData));
        _filteredPathalogyTest = _pathalogyTestListModel?.data ?? [];
        print("✅ Cache Loaded Successfully!");
      } catch (e) {
        print("⚠️ Cache Parsing Error: $e");
      }
    } else {
      print("⚠️ No Cached Data Found!");
    }

    await getPathalogyTestList(context);
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_pathalogy_tests');
    print("🗑 Cache Cleared!");
  }


  /// **Fetch Home Service List API**
  Future<bool> getPathalogyTestList(BuildContext context, {bool loadMore = false}) async {

    if (loadMore) {
      _setFetchingMoreState(true);
    } else {
      _setLoadingState(true);
      _errorMessage = "";
      _filteredPathalogyTest.clear();
      _currentPage = 1;
    }
    // _setLoadingState(true);
    // _errorMessage = "";
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_pathalogy_tests');
    _pathalogyTestListModel = null;

    try {
      var response = await _repository.getNavLabScanResponse();

      if (response != null && response.success == true && response.data != null) {
        print("✅ Home Service List Fetched Successfully");

        String newData = json.encode(response.toJson());
        if (cachedData == null || cachedData != newData) {
          print("📁 API Data Changed! Updating Cache...");
          await prefs.setString('cached_pathalogy_tests', newData);
          print("✅ Cache Updated Successfully!");
        }

        _pathalogyTestListModel = response;
        _filteredPathalogyTest = loadMore ? [..._filteredPathalogyTest, ...response.data!] : response.data!;
        _currentPage++;
        _setLoadingState(false);
        return true;
      } else {
        _pathalogyTestListModel = null;
        _setErrorState(response.message ?? "Failed to fetch service list");
      }
    } catch (error) {
      _pathalogyTestListModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }
  /// **Filter Packages by Search Query**
  void filterPathologyTestList(String query) {
    if (_pathalogyTestListModel?.data == null || query.isEmpty) {
      _filteredPathalogyTest = _pathalogyTestListModel?.data ?? [];
    } else {
      _filteredPathalogyTest = _pathalogyTestListModel!.data!
          .where((package) =>
      package.testDetailName?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
    notifyListeners();
  }

  Future<bool>  getPathalogyTestDetail(BuildContext context, String pathalogyTestSlug) async {
    _setLoadingState(true);
    _errorMessage = "";
    _pathalogyTestListDetailModel = null;

    try {
      var response = await _repository.getNavLabScanDetailResponse(pathalogyTestSlug);

      if (response != null && response.success == true && response.data != null) {
        print("✅ Home Service Detail Fetched Successfully");
        _pathalogyTestListDetailModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _pathalogyTestListDetailModel = null;
        _setErrorState(response.message ?? "Failed to fetch service detail");
      }
    } catch (error) {
      _pathalogyTestListDetailModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }


}
