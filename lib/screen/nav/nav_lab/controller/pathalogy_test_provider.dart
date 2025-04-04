import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:healthians/network_manager/repository.dart';
import 'package:healthians/screen/nav/nav_lab/model/PathalogyTestListDetailModel.dart';
import 'package:healthians/screen/nav/nav_lab/model/PathalogyTestListModel.dart' as pathalogyTestList;
import 'package:shared_preferences/shared_preferences.dart';


class PathalogyTestApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  bool _isFetchingMore = false; // To track pagination state
  bool _isLastPage = false;
  pathalogyTestList.PathalogyTestListModel? _pathalogyTestListModel;
  PathalogyScansListDetailModel? _pathalogyTestListDetailModel;


  List<pathalogyTestList.Data> _filteredPathalogyTest = [];
  int _currentPage = 1;
  final int _perPage = 10; // Adjust per API limit

  // Getters for UI
  bool get isFetchingMore => _isFetchingMore;
  bool get isLastPage => _isLastPage;
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


  /// **Load Cached Data Before API Call**
  Future<void> loadCachedNavPathalogyTests(BuildContext context) async {
    // _setLoadingState(true);
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_pathalogy_tests');

    if (cachedData != null && _filteredPathalogyTest.isEmpty) {
      try {
        print("✅ Loading cached pathology test data...");
        _pathalogyTestListModel = pathalogyTestList.PathalogyTestListModel.fromJson(json.decode(cachedData));
        _filteredPathalogyTest = _pathalogyTestListModel?.data ?? [];
        notifyListeners();
        print("✅ Cache Loaded Successfully!");
      } catch (e) {
        print("⚠️ Cache Parsing Error: $e");
      }
    } else {
      print("⚠️ No Cached Data Found!");
    }
    if (_filteredPathalogyTest.isEmpty)
      await getPathalogyTestList(context);
  }

  /// **Clear Cache**
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_pathalogy_tests');
    print("🗑 Cache Cleared!");
  }

  /// **Fetch Pathology Test List from API**
  Future<bool> getPathalogyTestList(BuildContext context ,{bool loadMore = false,bool forceRefresh = false}) async {

  // &&&&&& just add below code for loading more data &&&&&&&&&&
    // if (_isFetchingMore || _isLastPage) return true;

    // if (loadMore) {
    //   _setFetchingMoreState(true);
    // } else {
    //   _setLoadingState(true);
    //   _errorMessage = "";
    //   _filteredPathalogyTest.clear();
    //   _currentPage = 1;
    //   _isLastPage = false;
    // }

    // &&&&&& just add below code for loading more data &&&&&&&&&&

    _setLoadingState(true);
    _errorMessage = "";
    _filteredPathalogyTest.clear();
    _currentPage = 1;
    _isLastPage = false;

    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_pathalogy_tests');

    try {
      var response = await _repository.getNavLabScanResponse();

      if (response.success == true && response.data != null) {
        print("✅ Pathology Test List Fetched Successfully");

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
        _setErrorState(response.message ?? "Failed to fetch pathology test list");
      }
    } catch (error) {
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
          .where((test) =>
      test.testDetailName?.toLowerCase().contains(query.toLowerCase()) ?? false)
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

      if (response.success == true && response.data != null) {
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

  Future<void> refreshgetPathalogyTestList(BuildContext context) async {
    await getPathalogyTestList(context, forceRefresh: true);
  }

}
