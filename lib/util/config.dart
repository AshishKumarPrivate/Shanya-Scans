// lib/services/location_manager.dart (REVISED AGAIN)
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import '../main.dart'; // Import the global navigatorKey

/// A singleton class to manage all location-related operations,
/// including permissions, service status, and continuous/one-time location fetching.
class ConfigUtils with WidgetsBindingObserver {
  // --- Singleton Setup ---
  static final ConfigUtils _instance = ConfigUtils._internal();

  factory ConfigUtils() {
    return _instance;
  }

  ConfigUtils._internal() {
    WidgetsBinding.instance.addObserver(this);
    // Initial check of location status when the manager is first created
    // This initial check will manage the snackbar on app start if needed.
    _checkLocationServiceAndPermissionStatus();
  }

  // --- Location Data & State Management ---
  final StreamController<Map<String, dynamic>> _locationController = StreamController.broadcast();
  Stream<Map<String, dynamic>> get locationStream => _locationController.stream;

  final ValueNotifier<bool> _locationServiceStatusNotifier = ValueNotifier<bool>(true);
  ValueNotifier<bool> get locationServiceStatusNotifier => _locationServiceStatusNotifier;

  // --- Internal State & Debouncing ---
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isSnackbarActive = false; // Flag to manage the persistent snackbar's state
  Position? _lastReportedPosition;
  final int _minDistanceForUpdate = 1;
  final int _minTimeBetweenUpdatesMs = 1000;
  DateTime _lastUpdateTime = DateTime.now();

  // Reference to the currently shown snackbar, to programmatically dismiss it
  SnackBarClosedReason? _lastSnackbarCloseReason; // To track why the snackbar closed

  // --- App Lifecycle Management ---
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      debugPrint("LocationManager: App Resumed, re-checking location status.");
      // On resume, always re-check status. This will manage the snackbar state.
      _checkLocationServiceAndPermissionStatus();
    }
  }

  // --- Core Location Logic ---

  /// Checks the current status of location services and permissions.
  /// Manages `_locationServiceStatusNotifier` and the persistent warning snackbar.
  Future<void> _checkLocationServiceAndPermissionStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    LocationPermission permission = await Geolocator.checkPermission();

    debugPrint("LocationManager: Service Enabled: $serviceEnabled, Permission: $permission");

    // Update the notifier first
    _locationServiceStatusNotifier.value = serviceEnabled;

    // Determine if a warning should be shown
    bool shouldShowWarning = !serviceEnabled || permission == LocationPermission.deniedForever;

    if (shouldShowWarning) {
      // If a warning is needed and not already active, show the snackbar
      // The _showPersistentSnackbar method itself handles the _isSnackbarActive flag.
      await _showPersistentSnackbar(isPermissionDenied: permission == LocationPermission.deniedForever);
    } else {
      // If no warning is needed, ensure any active snackbar is hidden
      _hidePersistentSnackbar();
    }
  }


  /// Ensures that location services are enabled and permissions are granted.
  /// Handles requesting permissions and checks for service enablement.
  /// Returns `true` if location access is granted and service is enabled, `false` otherwise.
  Future<bool> ensureLocationAccess() async {
    // Always start by hiding any existing snackbar to prevent it lingering if access becomes available
    _hidePersistentSnackbar();

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      debugPrint("LocationManager: Permission denied, requesting...");
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        debugPrint("LocationManager: ❌ Permission still denied after request.");
        await _showPersistentSnackbar(isPermissionDenied: true);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint("LocationManager: ⚠️ Permission permanently denied. User must enable in settings.");
      await _showPersistentSnackbar(isPermissionDenied: true);
      return false;
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint("LocationManager: ⚠️ Location services are off. Prompting user to enable.");
      await _showPersistentSnackbar(isPermissionDenied: false);
      return false;
    }

    debugPrint("LocationManager: ✅ Location access granted and service enabled.");
    _hidePersistentSnackbar(); // All clear, hide snackbar
    return true;
  }

  /// Starts continuous tracking of the user's location.
  Future<bool> startTracking() async {
    bool hasAccess = await ensureLocationAccess();
    if (!hasAccess) {
      _locationServiceStatusNotifier.value = false;
      return false;
    }

    // stopTracking(); // Stop any existing tracking before starting new.

    try {
      Position initialPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );
      String address = await _getAddressFromLatLng(initialPosition.latitude, initialPosition.longitude);

      if (_lastReportedPosition == null ||
          Geolocator.distanceBetween(
              _lastReportedPosition!.latitude,
              _lastReportedPosition!.longitude,
              initialPosition.latitude,
              initialPosition.longitude) >
              _minDistanceForUpdate ||
          DateTime.now().difference(_lastUpdateTime).inMilliseconds >= _minTimeBetweenUpdatesMs) {
        _locationController.add({
          "latitude": initialPosition.latitude,
          "longitude": initialPosition.longitude,
          "address": address,
        });
        _lastReportedPosition = initialPosition;
        _lastUpdateTime = DateTime.now();
        debugPrint("LocationManager: ✅ Initial Location: $address");
      } else {
        debugPrint("LocationManager: Initial location not significantly new.");
      }
    } catch (e) {
      debugPrint("LocationManager: ⚠️ Error getting initial location for stream: $e");
      _locationServiceStatusNotifier.value = false;
      _checkLocationServiceAndPermissionStatus(); // Re-check if initial acquisition failed
      return false;
    }

    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: _minDistanceForUpdate,
      ),
    ).listen(
          (Position position) async {
        bool enoughTimePassed = DateTime.now().difference(_lastUpdateTime).inMilliseconds >= _minTimeBetweenUpdatesMs;

        if (enoughTimePassed) {
          bool hasMovedSignificantly = _lastReportedPosition == null ||
              Geolocator.distanceBetween(
                  _lastReportedPosition!.latitude,
                  _lastReportedPosition!.longitude,
                  position.latitude,
                  position.longitude) > _minDistanceForUpdate;

          if (hasMovedSignificantly) {
            try {
              String address = await _getAddressFromLatLng(position.latitude, position.longitude);
              _locationController.add({
                "latitude": position.latitude,
                "longitude": position.longitude,
                "address": address,
              });
              _lastReportedPosition = position;
              _lastUpdateTime = DateTime.now();
              debugPrint("LocationManager: 📍 Live Location: Lat: ${position.latitude}, Lng: ${position.longitude} 🏠 $address");
            } catch (e) {
              debugPrint("LocationManager: ⚠️ Error in location stream (getAddress): $e");
            }
          }
        }
      },
      onError: (e) {
        debugPrint("LocationManager: ⚠️ Location stream error: $e");
        // If stream errors, re-check status, which might re-show snackbar
        _checkLocationServiceAndPermissionStatus();
      },
      cancelOnError: false,
    );

    return true;
  }

  /// Stops continuous location tracking.
  void stopTracking() {
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    _lastReportedPosition = null;
    _hidePersistentSnackbar(); // Hide snackbar if tracking is explicitly stopped
    debugPrint("LocationManager: 🛑 Location tracking stopped.");
  }

  /// Gets a single, current location and its address.
  Future<Map<String, dynamic>> getSingleLocation() async {
    bool hasAccess = await ensureLocationAccess();
    if (!hasAccess) {
      _locationServiceStatusNotifier.value = false;
      return {};
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      );
      String address = await _getAddressFromLatLng(position.latitude, position.longitude);
      debugPrint("LocationManager: ✅ Single Location: Lat: ${position.latitude}, Lng: ${position.longitude} 🏠 $address");
      return {
        "latitude": position.latitude,
        "longitude": position.longitude,
        "address": address,
      };
    } catch (e) {
      debugPrint("LocationManager: ⚠️ Error getting single location: $e");
      _locationServiceStatusNotifier.value = false;
      _checkLocationServiceAndPermissionStatus(); // Re-check if single acquisition failed
      return {};
    }
  }

  /// Converts latitude and longitude to a human-readable address string.
  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        List<String> addressParts = [];
        if (place.street != null && place.street!.isNotEmpty) addressParts.add(place.street!);
        if (place.subLocality != null && place.subLocality!.isNotEmpty) addressParts.add(place.subLocality!);
        if (place.locality != null && place.locality!.isNotEmpty) addressParts.add(place.locality!);
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) addressParts.add(place.administrativeArea!);
        if (place.country != null && place.country!.isNotEmpty) addressParts.add(place.country!);

        return addressParts.join(', ');
      }
      return "Address Not Found";
    } catch (e) {
      debugPrint("LocationManager: ⚠️ Error fetching address from coordinates ($lat, $lng): $e");
      return "Error Fetching Address";
    }
  }

  // --- UI-related Utility Methods (for SnackBar) ---

  /// Displays a persistent SnackBar with a message prompting user to enable location.
  /// This method is designed to prevent showing duplicate snackbars.
  Future<void> _showPersistentSnackbar({required bool isPermissionDenied}) async {
    final context = navigatorKey.currentContext;
    if (context == null) {
      debugPrint("LocationManager: Cannot show snackbar, no context available.");
      return;
    }
    if (_isSnackbarActive) {
      debugPrint("LocationManager: SnackBar already active, not showing duplicate.");
      return;
    }
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    _isSnackbarActive = true; // Set flag when showing
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    // String message = isPermissionDenied
    //     ? "Location permission denied. Please enable it in app settings."
    //     : "Location services are currently OFF. Please tap 'Open Settings' and turn Location ON.";

    String message = isPermissionDenied
        ? "Location permission denied. Please enable it in app settings."
        : Platform.isIOS
        ? "Location services are currently OFF. Tap 'Open Settings', then navigate to 'Privacy & Security' > 'Location Services' and turn it ON for your device."
        : "Location services are currently OFF. Please tap 'Open Settings' and turn Location ON.";

    debugPrint("LocationManager: Showing persistent snackbar: $message");

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(days: 1), // Make it truly persistent
        behavior: SnackBarBehavior.fixed,
        action: SnackBarAction(
          label: 'Open Settings',
          textColor: Colors.yellowAccent,
          onPressed: () {
            if (isPermissionDenied) {
              Geolocator.openAppSettings();
            } else {
              // Geolocator.openLocationSettings();
              if (Platform.isIOS) {
                Geolocator.openAppSettings(); // iOS doesn't support openLocationSettings
              } else {
                Geolocator.openLocationSettings();
              }
            }
          },
        ),
        backgroundColor: Colors.redAccent,
      ),
    ).closed.then((reason) {
      debugPrint("LocationManager: Persistent snackbar closed. Reason: $reason");
      _isSnackbarActive = false;
      _lastSnackbarCloseReason = reason;
      if (reason == SnackBarClosedReason.action || reason == SnackBarClosedReason.swipe || reason == SnackBarClosedReason.timeout || reason == SnackBarClosedReason.hide) {
        _checkLocationServiceAndPermissionStatus();
      }
    });
  }

  void _hidePersistentSnackbar() {
    final context = navigatorKey.currentContext;
    if (context != null && _isSnackbarActive) {
      debugPrint("LocationManager: Hiding persistent snackbar explicitly.");
      // ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).hideCurrentSnackBar(
          reason: SnackBarClosedReason.hide);
    } else {
      debugPrint("LocationManager: No active snackbar to hide or context is null.");
    }
  }

  // --- Disposal ---
  @override
  void dispose() {
    debugPrint("LocationManager: Disposing resources.");
    WidgetsBinding.instance.removeObserver(this);
    stopTracking(); // Ensure tracking is stopped on dispose
    _locationController.close();
    _locationServiceStatusNotifier.dispose();
    _hidePersistentSnackbar(); // Ensure snackbar is gone on dispose
    // super.dispose();
  }
}