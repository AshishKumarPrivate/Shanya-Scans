import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shanya_scans/network_manager/repository.dart';
import 'package:shanya_scans/screen/nav/nav_home/frquently_pathalogy_test/model/FrequentlyPathalogyTagListModel.dart';

class FrequentlyPathalogyTagApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  FrequentlyTagListModel? _frequentlyPathalogyTagListModel;

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  FrequentlyTagListModel? get frequentlyPathalogyTagListModel => _frequentlyPathalogyTagListModel;

  static const String _cacheKey = 'cached_home_lab_test';
  static const String _cacheTimeKey = 'cached_home_lab_test_time';

  void _setLoadingState(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setErrorState(String message) {
    _errorMessage = message;
    _setLoadingState(false);
  }

  /// Load cache first, then decide to fetch from API
  Future<void> loadCachedFrequentlyHomeLabTest({bool forceRefresh = false}) async {
    _setLoadingState(true);
    final prefs = await SharedPreferences.getInstance();

    final cachedData = prefs.getString(_cacheKey);
    final cachedTime = prefs.getInt(_cacheTimeKey);

    if (cachedData != null) {
      try {
        _frequentlyPathalogyTagListModel = FrequentlyTagListModel.fromJson(json.decode(cachedData));
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
      await getFrequentlyLabTestList();
    } else {
      _setLoadingState(false);
      print("✅ Cache is fresh. Skipping API call.");
    }
  }

  /// Clear cache manually
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_cacheTimeKey);
    print("🗑 Cache cleared!");
  }

  /// Fetch API and cache response
  Future<bool> getFrequentlyLabTestList() async {
    _setLoadingState(true);
    _errorMessage = "";

    final prefs = await SharedPreferences.getInstance();
    final oldCache = prefs.getString(_cacheKey);

    try {
      final response = await _repository.getFrequentlyLabTestListResponse();

      if (response.success == true && response.data != null) {
        final newData = json.encode(response.toJson());

        if (oldCache == null || oldCache != newData) {
          await prefs.setString(_cacheKey, newData);
          await prefs.setInt(_cacheTimeKey, DateTime.now().millisecondsSinceEpoch);
          print("✅ New data cached successfully!");
        } else {
          print("🔁 Data unchanged. Using existing cache.");
        }

        _frequentlyPathalogyTagListModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _setErrorState(response.message ?? "Failed to fetch frequently test list.");
      }
    } catch (e) {
      _setErrorState("⚠️ API error: $e");
    }

    return false;
  }
}
