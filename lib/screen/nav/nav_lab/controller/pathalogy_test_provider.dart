import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shanya_scans/network_manager/repository.dart';
import 'package:shanya_scans/screen/nav/nav_lab/model/PathalogyTestListDetailModel.dart';
import 'package:shanya_scans/screen/nav/nav_lab/model/PathalogyTestListModel.dart';

class PathalogyTestApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  bool _isFetchingMore = false;
  bool _isLastPage = false;

  PathalogyTestListModel? _pathalogyTestListModel;
  PathalogyScansListDetailModel? _pathalogyTestListDetailModel;

  List<Allpathology> _allPathalogyTests = [];
  List<Allpathology> _filteredPathalogyTests = [];

  int _currentPage = 1;
  final int _limit = 15;

  // Getters
  bool get isLoading => _isLoading;
  bool get isFetchingMore => _isFetchingMore;
  bool get isLastPage => _isLastPage;
  String get errorMessage => _errorMessage;
  List<Allpathology> get filteredPathalogyTests => _filteredPathalogyTests;
  PathalogyScansListDetailModel? get pathalogyTestListDetailModel => _pathalogyTestListDetailModel;

  // Helpers
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setFetchingMore(bool value) {
    _isFetchingMore = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    _setLoading(false);
    notifyListeners();
  }

  /// Load Cached Data (before API call)
  Future<void> loadCachedNavPathalogyTests(BuildContext context, {bool forceReload = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString('cached_pathalogy_tests');


    if (forceReload) {
      await clearCache(); // clear old cache
      _currentPage = 1;
      _isLastPage = false;
      _allPathalogyTests.clear();
      _filteredPathalogyTests.clear();
      notifyListeners();
      await getPathalogyTestList(context); // fresh data
      return;
    }

    if (cachedData != null) {
      try {
        final decoded = json.decode(cachedData);
        _pathalogyTestListModel = PathalogyTestListModel.fromJson(decoded);

        _allPathalogyTests = _pathalogyTestListModel?.data?.allpathology ?? [];
        _filteredPathalogyTests = List.from(_allPathalogyTests);
        // 🧮 Calculate correct page to continue from
        _currentPage = ((_allPathalogyTests.length / _limit).ceil()) + 1;
        _isLastPage = _allPathalogyTests.length < (_currentPage - 1) * _limit;
        notifyListeners();
        print("✅ Loaded pathology test list from cache.");
      } catch (e) {
        print("⚠️ Cache parse error: $e");
      }
    }

    // If nothing loaded, call API
    if (_filteredPathalogyTests.isEmpty) {
      await getPathalogyTestList(context);
    }
  }

  /// Clear Cached Data
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cached_pathalogy_tests');
    print("🗑 Cache Cleared!");
  }

  /// Get Pathology Test List with Pagination
  Future<bool> getPathalogyTestList(
      BuildContext context, {
        bool loadMore = false,
        bool forceRefresh = false,
      }) async {
    if (_isFetchingMore || _isLastPage) return true;

    final prefs = await SharedPreferences.getInstance();

    if (loadMore) {
      _setFetchingMore(true);
    } else {
      _setLoading(true);
      _errorMessage = "";

      if (forceRefresh) {
        _currentPage = 1;
        _isLastPage = false;
        _allPathalogyTests.clear();
      }
    }

    try {
      final response = await _repository.getNavLabScanResponse(
        page: _currentPage,
        limit: _limit,
      );

      if (response.success == true && response.data != null) {
        final newTests = response.data!.allpathology ?? [];

        if (newTests.length < _limit) {
          _isLastPage = true;
        }

        _allPathalogyTests.addAll(newTests);
        _filteredPathalogyTests = List.from(_allPathalogyTests);
        _currentPage++;

        // ✅ Merge new data into cache
        final existingCache = prefs.getString('cached_pathalogy_tests');

        if (existingCache != null) {
          try {
            final decoded = json.decode(existingCache);
            final cachedModel = PathalogyTestListModel.fromJson(decoded);
            final cachedTests = cachedModel.data?.allpathology ?? [];

            // Merge old + new, avoiding duplicates by slug or ID
            final mergedTestsMap = {
              for (var test in [...cachedTests, ...newTests])
                test.sId ?? test.slug ?? test.hashCode: test
            };

            final mergedTests = mergedTestsMap.values.toList();

            cachedModel.data?.allpathology = mergedTests;
            final mergedJson = json.encode(cachedModel.toJson());
            await prefs.setString('cached_pathalogy_tests', mergedJson);
            print("✅ Appended new data to cache.");
          } catch (e) {
            print("⚠️ Error merging cache: $e");
          }
        } else {
          // First-time caching
          final jsonStr = json.encode(response.toJson());
          await prefs.setString('cached_pathalogy_tests', jsonStr);
          print("✅ Initial cache set.");
        }

        _setLoading(false);
        _setFetchingMore(false);
        return true;
      } else {
        _setError(response.message ?? "Failed to fetch data");
      }
    } catch (e) {
      _setError("⚠️ Error: $e");
    }

    return false;
  }

  /// Filter Pathology Tests by Search Query
  void filterPathologyTestList(String query) {
    if (query.isEmpty) {
      _filteredPathalogyTests = List.from(_allPathalogyTests);
    } else {
      _filteredPathalogyTests = _allPathalogyTests.where((test) {
        final name = test.testDetailName ?? "Hello ";
        return name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }

  /// Fetch Pathology Test Detail
  Future<bool> getPathalogyTestDetail(BuildContext context, String slug) async {
    _setLoading(true);
    _errorMessage = "";
    _pathalogyTestListDetailModel = null;

    try {
      final response = await _repository.getNavLabScanDetailResponse(slug);

      if (response.success == true && response.data != null) {
        _pathalogyTestListDetailModel = response;
        _setLoading(false);
        return true;
      } else {
        _setError(response.message ?? "Failed to fetch test detail");
      }
    } catch (e) {
      _setError("⚠️ Error: $e");
    }

    return false;
  }

  /// Pull to Refresh
  Future<void> refreshgetPathalogyTestList(BuildContext context) async {
    await getPathalogyTestList(context, forceRefresh: true);
  }
}
