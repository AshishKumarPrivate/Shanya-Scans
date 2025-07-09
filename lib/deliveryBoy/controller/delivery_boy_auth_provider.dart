import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shanya_scans/deliveryBoy/screen/deleivery_boy_dashboard.dart';
import 'package:shanya_scans/deliveryBoy/screen/delivery_boy_login_screen.dart';
import 'package:shanya_scans/network_manager/repository.dart';
import 'package:shanya_scans/screen/auth/login_screen.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/ui_helper/storage_helper.dart';
import '../../../network_manager/api_error_handler.dart';
import '../../../ui_helper/snack_bar.dart';
import '../../screen/other/screen/user_selection_screen.dart';
import '../../util/config.dart';
import '../model/DeliveryLoginModelResponse.dart';

class DeliveryBoyAuthApiProvider with ChangeNotifier, WidgetsBindingObserver {
  final Repository _repository = Repository();
  bool _isLoading = false;

  late final ConfigUtils _configUtils;
  bool get isLoading => _isLoading;
  // To store email and password when waiting for location to be enabled
  String? _pendingEmail;
  String? _pendingPassword;
  BuildContext? _pendingContext; // Store context for re-attempt after resume


  DeliveryBoyAuthApiProvider() {
    _configUtils = ConfigUtils();
    WidgetsBinding.instance.addObserver(this); // Add observer
    _configUtils.locationServiceStatusNotifier.addListener(_onLocationServiceStatusChanged);

  }
  /// Clears any pending login credentials.
  void _clearPendingLoginState() {
    _pendingEmail = null;
    _pendingPassword = null;
    _pendingContext = null;
  }


  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _configUtils.locationServiceStatusNotifier.removeListener(_onLocationServiceStatusChanged);
    // Dispose ConfigUtils to clean up streams/timers
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // ConfigUtils already handles checking location service status on resume.
      // We only need to trigger a login re-attempt if we were in a pending state.
      if (_pendingEmail != null && _pendingPassword != null && _pendingContext != null) {
        print("App resumed, re-attempting location acquisition for pending login.");
        // We re-attempt _getLocationAndProceedLogin. ConfigUtils will re-verify permissions/service.
        final email = _pendingEmail;
        final password = _pendingPassword;
        final context = _pendingContext;
        _clearPendingLoginState();
        _getLocationAndProceedLogin(_pendingContext!, _pendingEmail!, _pendingPassword!);
        // Clear pending state after re-attempt

      }
    }
  }
  // Callback for when location service status changes in ConfigUtils
  void _onLocationServiceStatusChanged() {
    print("Location service status changed: ${_configUtils.locationServiceStatusNotifier.value}");
    // If we have a pending login and location service becomes enabled, re-attempt login
    if (_pendingEmail != null && _pendingPassword != null && _pendingContext != null && _configUtils.locationServiceStatusNotifier.value) {
      print("Location service enabled, re-attempting pending login...");

      _clearPendingLoginState();
      _getLocationAndProceedLogin(_pendingContext!, _pendingEmail!, _pendingPassword!);
      // Clear pending state after re-attempt
    }
    // You could also notify listeners here if your UI needs to react to this status change
    // For example, if you have a "Location Services Off" banner on your login screen.
    // notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void reset() {
    _setLoading(false);
    _configUtils.stopTracking(); // Ensure tracking is stopped on reset
    _clearPendingLoginState();
  }

  Future<bool> _showLocationDisclosureDialog(BuildContext context) async {
    bool userAccepted = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text("Location Permission Required"),
          content: const Text(
            "To help you reach users for test collection, this app requests location access. This data is used only to track your delivery routes and will not be shared.",
            // "We need to track your location in the background to help you reach users for test collection. Your data will only be used for this purpose and not shared with anyone.",
          ),
          actions: [
            TextButton(
              onPressed: () {
                userAccepted = false;
                Navigator.of(ctx).pop();
              },
              child: const Text("Not Now"),
            ),
            ElevatedButton(
              onPressed: () async {
                userAccepted = true;
                await StorageHelper().setSalesLocationDisclosureAccepted(true);
                Navigator.of(ctx).pop();
              },
              child: const Text("Continue"),
            ),
          ],
        );
      },
    );
    return userAccepted;
  }

  // New method to handle location acquisition and continuation of login
  Future<void> _getLocationAndProceedLogin(BuildContext context, String email, String password) async {
    _setLoading(true);
    Map<String, dynamic> locationData = await _configUtils.getSingleLocation();

    if (locationData.isEmpty || locationData["latitude"] == null || locationData["longitude"] == null) {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();

      _pendingEmail = email;
      _pendingPassword = password;
      _pendingContext = context;
      if (!serviceEnabled) {
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: "Location services are OFF. Please enable them to login.",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        );
        print("Location service off after initial attempts. Setting pending state.");
        _setLoading(false);
        return;
      } else if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: "Location permission denied. Please grant permission to login.",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        );
        print("Location permission denied. Setting pending state.");
        _setLoading(false); // Stop loading if waiting for user action
        return;
      } else {
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: "Failed to get precise location. Please ensure you have a strong GPS signal or stable network.",
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        );
        _setLoading(false);
        _configUtils.stopTracking(); // Ensure tracking is stopped
        _clearPendingLoginState();
        return;
      }
    }

    // If we successfully got location, proceed with login
    await _performLogin(context, email, password, locationData);
  }

  Future<void> deliveryBoyLogin(BuildContext context, String email, String password) async {
    _setLoading(true);

    // --- NEW LOGIC: Check if disclosure has been accepted before showing dialog ---
    bool hasAcceptedDisclosure = await StorageHelper().isSalesLocationDisclosureAccepted();

    if (!hasAcceptedDisclosure) {
      bool accepted = await _showLocationDisclosureDialog(context);
      if (!accepted) {
        _setLoading(false);
        return;
      }
    } else {
      print("Location disclosure already accepted.");
    }

    _pendingEmail = email;
    _pendingPassword = password;
    _pendingContext = context;

    await _getLocationAndProceedLogin(context, email, password);
  }

  Future<void> _performLogin(BuildContext context, String email, String password, Map<String, dynamic> locationData) async {
    try {
      String latitude = locationData["latitude"].toString();
      String longitude = locationData["longitude"].toString();
      String address = locationData["address"];

      Map<String, dynamic> requestBody = {
        "email": email,
        "password": password,
        "lat": latitude,
        "lng": longitude,
        "address": address,
      };

      var response = await _repository.deliveryBoyLogin(requestBody);
      if (response.success == true) {
        await _storeDeliveryBoyData(response);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) =>  DeliveryBoyDashboardScreen()));
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: response.message ?? 'Login successful!',
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        );
        reset(); // Reset state after successful login
      } else {
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: "Invalid Credential" ?? 'Login failed! User not exist.', // Use server message, fallback if null
          backgroundColor: AppColors.deliveryPrimary,
          duration: const Duration(seconds: 2),
        );
      }
    } on DioException catch (e) {
      _handleDioErrors(context, e);
    } catch (e) {
      _handleUnexpectedErrors(context, e, "An unexpected error occurred during login.");
    } finally {
      _setLoading(false);
      _configUtils.stopTracking(); // Ensure tracking is stopped after login attempt
      _clearPendingLoginState();
    }
  }


  // Future<void> deliveryBoyLogin( BuildContext context, String email, String password) async {
  //   _setLoading(true);
  //   bool accepted = await _showLocationDisclosureDialog(context);
  //   if (!accepted) {
  //     _setLoading(false);
  //     return;
  //   }
  //
  //   Map<String, dynamic> locationData = {};
  //   bool gotLocation = false;
  //   int retryCount = 0;
  //   const int maxRetries = 3; // Allow a few retries for immediate location
  //
  //   // First attempt to get location directly
  //   try {
  //     locationData = await _configUtils.getSingleLocation();
  //     if (locationData.isNotEmpty && locationData["latitude"] != null) {
  //       gotLocation = true;
  //       print("Successfully acquired location immediately for login.");
  //     }
  //   } catch (e) {
  //     print("Error getting single location: $e");
  //   }
  //
  //   try {
  //     ConfigUtils _configUtils = ConfigUtils();
  //     _configUtils.startTracking();
  //     Map<String, dynamic> locationData = await _configUtils.locationStream.first;
  //
  //     String latitude = locationData["latitude"].toString();
  //     String longitude = locationData["longitude"].toString();
  //     String address = locationData["address"];
  //
  //
  //     Map<String, dynamic> requestBody = {
  //       "email": email,
  //       "password": password,
  //       "lat": latitude,
  //       "lng": longitude,
  //       "address": address,
  //
  //     };
  //
  //     var response = await _repository.deliveryBoyLogin(requestBody);
  //     if (response.success == true) {
  //       await _storeDeliveryBoyData(response);
  //       Navigator.pushReplacement(
  //           context, MaterialPageRoute(builder: (context) => DeliveryBoyDashboardScreen()));
  //       showCustomSnackbarHelper.showSnackbar(
  //         context: context,
  //         message: response.message ?? 'Login successful!',
  //         backgroundColor: Colors.green,
  //         duration: Duration(seconds: 2),
  //       );
  //
  //     } else {
  //       showCustomSnackbarHelper.showSnackbar(
  //         context: context,
  //         message: "User not exist" ?? 'Login failed!',
  //         backgroundColor: AppColors.deliveryPrimary,
  //         duration: Duration(seconds: 2),
  //       );
  //     }
  //   } on DioException catch (e) {
  //     _handleDioErrors(context, e);
  //   } catch (e) {
  //     _handleUnexpectedErrors(context, e, "User not exist! Please Contact to Authorized Admin");
  //   } finally {
  //     _setLoading(false);
  //   }
  // }

  void logoutUser(BuildContext context) {
    _setLoading(true);
    Future.delayed(Duration(seconds: 1), () {
      StorageHelper().logout();
      _setLoading(false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => DeliveryLoginScreen()),
        (route) => false,
      );
    });
  }

  Future<void> _storeDeliveryBoyData(DeliveryLoginModelResponse response) async {
    if (response.data != null) {
      StorageHelper().setDeliveryBoyId(response.data!.sId.toString());
      StorageHelper().setDeliveryBoyName(response.data!.name.toString());
      StorageHelper().setDeliveryBoyEmail(response.data!.email.toString());
      StorageHelper().setDeliveryBoyPassword(response.data!.password.toString());

    } else {
      await StorageHelper().clearOrderList();
    }
  }

  void _handleDioErrors(BuildContext context, DioException e) {
    showCustomSnackbarHelper.showSnackbar(
      context: context,
      message: ApiErrorHandler.handleError(e),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
  }

  void _handleUnexpectedErrors(  BuildContext context, dynamic e, String message) {

    showCustomSnackbarHelper.showSnackbar(
      context: context,
      message: message,
      backgroundColor: Colors.red,
      duration: Duration(seconds: 3),
    );
  }



}
