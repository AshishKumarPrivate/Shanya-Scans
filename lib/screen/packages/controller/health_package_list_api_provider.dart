import 'package:flutter/material.dart';
import 'package:healthians/network_manager/repository.dart';
import 'package:healthians/screen/packages/model/PackageListByTabIdModel.dart' as packageModel;
import 'package:healthians/screen/packages/model/TopSellingPackagesListModel.dart';

class HealthPacakgeListApiProvider with ChangeNotifier {
  final Repository _repository = Repository();

  bool _isLoading = false;
  String _errorMessage = "";
  packageModel.PackageListByTabIdModel? _PackageListByTabModel;
  packageModel.PackageListByTabIdModel? _navPackageListlModel;
  TopSellingPackagesListModel? _topSellingPackageListlModel;

  List<packageModel.Data> _filteredPackages = [];

  // Getters for UI
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  packageModel.PackageListByTabIdModel? get packageListByTabModel =>  _PackageListByTabModel;
  packageModel.PackageListByTabIdModel? get navPackageListlModel =>  _navPackageListlModel;
  List<packageModel.Data> get filteredPackages => _filteredPackages;
  TopSellingPackagesListModel? get topSellingPackageListlModel =>  _topSellingPackageListlModel;

  // Cache management
  DateTime? _lastFetchTime;
  final Duration _cacheDuration = Duration(minutes: 5); // Cache expires in 5 minutes

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

  /// **Fetch Home Service List API**
  Future<bool> getPackageListByTab(BuildContext context,String packageTabId) async {
    _setLoadingState(true);
    _errorMessage = "";
    _PackageListByTabModel = null;

    try {

      Map<String, dynamic> requestBody = {"id": packageTabId};
      var response =  await _repository.getPackageListByTabResponse(requestBody);

      if (response.success == true && response.data != null) {
        print("✅ Package list By Tab  Fetched Successfully");
        _PackageListByTabModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _PackageListByTabModel = null;
        _setErrorState(response.message ?? "Failed to fetch service list");
      }
    } catch (error) {
      _PackageListByTabModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }

  /// **Fetch Home Service List API**
  Future<bool> getTopSellingPackageListByTab(BuildContext context,String blankPackageId) async {
    _setLoadingState(true);
    _errorMessage = "";
    _topSellingPackageListlModel = null;

    try {

      Map<String, dynamic> requestBody = {"id": blankPackageId};
      var response =  await _repository.getTopSellingPackageListResponse(requestBody);

      if (response.success == true && response.data != null) {
        print("✅ Package list By Tab  Fetched Successfully");
        _topSellingPackageListlModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _topSellingPackageListlModel = null;
        _setErrorState(response.message ?? "Failed to fetch service list");
      }
    } catch (error) {
      _topSellingPackageListlModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }

  /// **Fetch Home Service List API**
  Future<bool> getNavPackageList(BuildContext context) async {
    _setLoadingState(true);
    _errorMessage = "";
    _navPackageListlModel = null;

    try {
      var response =  await _repository.getPackageListResponse();

      if (response.success == true && response.data != null) {
        print("${response.data.toString()}");
        print("✅ Package list  Fetched Successfully");
        _navPackageListlModel = response;
        _setLoadingState(false);
        return true;
      } else {
        _navPackageListlModel = null;
        _setErrorState(response.message ?? "Failed to fetch service list");
      }
    } catch (error) {
      _navPackageListlModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }


  /// **Fetch Home Service List API**
  Future<bool> getBottomNavPackageList(BuildContext context, {bool forceRefresh = false}) async {

    // If not force refreshing and cache is valid, return cached data
    if (!forceRefresh && _navPackageListlModel != null && _lastFetchTime != null) {
      final timeDiff = DateTime.now().difference(_lastFetchTime!);
      if (timeDiff < _cacheDuration) {
        print("🟢 Using cached package list data");
        return true;
      }
    }
    // If force refreshing, clear cache
    if (forceRefresh) {
      _lastFetchTime = null;
    }

    _setLoadingState(true);
    _errorMessage = "";
    _navPackageListlModel = null;

    try {
      var response =  await _repository.getNavPackageListResponse();

      if (response.success == true && response.data != null) {
        print("✅ Package list  Fetched Successfully");
        _navPackageListlModel = response;
        // Ensure correct type conversion
        _filteredPackages = _navPackageListlModel?.data ?? [];
        _lastFetchTime = DateTime.now(); // Update cache timestamp
        _setLoadingState(false);
        return true;
      } else {
        _navPackageListlModel = null;
        _setErrorState(response.message ?? "Failed to fetch service list");
      }
    } catch (error) {
      _navPackageListlModel = null;
      _setErrorState("⚠️ API Error: $error");
    }

    return false;
  }
  /// **Pull-to-Refresh Handler**
  Future<void> refreshBottomNavPackageList(BuildContext context) async {
    await getBottomNavPackageList(context, forceRefresh: true);
  }

  /// **Filter Packages by Search Query**
  void filterPackages(String query) {
    if (_navPackageListlModel?.data == null || query.isEmpty) {
      _filteredPackages = _navPackageListlModel?.data ?? [];
    } else {
      _filteredPackages = _navPackageListlModel!.data!
          .where((package) =>
      package.packageName?.toLowerCase().contains(query.toLowerCase()) ?? false)
          .toList();
    }
    notifyListeners();
  }

}
