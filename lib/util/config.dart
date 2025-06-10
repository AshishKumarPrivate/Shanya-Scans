import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart'; // Assuming your main.dart provides navigatorKey

class ConfigUtils with WidgetsBindingObserver {
  StreamSubscription<Position>? positionStream;
  final StreamController<Map<String, dynamic>> _locationController = StreamController.broadcast();
  bool _isDialogShown = false; // Flag to prevent multiple dialogs/snackbars
  final ValueNotifier<bool> _locationServiceStatusNotifier = ValueNotifier<bool>(true); // True initially, will be updated.
  bool _isPersistentSnackbarActive = false;
  // Getter for the location service status notifier
  ValueNotifier<bool> get locationServiceStatusNotifier => _locationServiceStatusNotifier;

  // Keep track of the last reported location to debounce
  Position? _lastReportedPosition;
  final int _minDistanceForUpdate = 5; // Meters
  final int _minTimeBetweenUpdatesMs = 1000; // Minimum 1 second between UI updates
  DateTime _lastUpdateTime = DateTime.now();


  Stream<Map<String, dynamic>> get locationStream => _locationController.stream;
  static final ConfigUtils _instance = ConfigUtils._internal();

  // Private constructor for the singleton
  ConfigUtils._internal() {
    WidgetsBinding.instance.addObserver(this); // Add observer to listen for app lifecycle changes
    _checkLocationServiceStatus(); // Check status on initialization
  }

  // Factory constructor (the public way to get the instance)
  factory ConfigUtils() {
    return _instance;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // When the app comes to the foreground, re-check location service status
      print("App Resumed: Checking location service status...");
      _checkLocationServiceStatus();
    }
  }

  /// Checks the current status of location services and updates the notifier.
  /// Shows/hides the persistent snackbar accordingly.
  Future<void> _checkLocationServiceStatus() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    print("Location Service Enabled: $serviceEnabled");
    _locationServiceStatusNotifier.value = serviceEnabled; // Update the notifier

    // We don't request permission here, just check status.
    LocationPermission permission = await Geolocator.checkPermission();

    if (!serviceEnabled) {
      // If service is disabled, show warning for service.
      await _showPersistentLocationSnackbar(isPermissionDenied: false);
    } else if (permission == LocationPermission.deniedForever) {
      // If permission is denied forever, show warning for permission.
      await _showPersistentLocationSnackbar(isPermissionDenied: true);
    } else {
      // If all is good (service enabled, permission granted or temporary denied), hide snackbar.
      _hidePersistentLocationSnackbar();
    }
  }

  /// Requests location permissions from the user.
  /// Returns true if permission is granted, false otherwise.
  Future<bool> _requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      // If permission is denied but not permanently, request it.
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("❌ Location permission denied during request (user tapped 'Don't Allow').");
        // If still denied after requesting, show persistent snackbar for *permission* denial.
        await _showPersistentLocationSnackbar(isPermissionDenied: true);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("⚠️ Location permission is permanently denied. User needs to enable it from app settings.");
      // If permanently denied, try to open app settings directly AND show snackbar.
      openAppSettings();
      await _showPersistentLocationSnackbar(isPermissionDenied: true);
      return false;
    }

    // At this point, permission is either granted or restricted.
    // Confirm with permission_handler for explicit granted status.
    var status = await Permission.location.status;
    if (status.isGranted) {
      _hidePersistentLocationSnackbar(); // Hide snackbar if permission is now granted
      return true;
    } else {
      print("🤔 Location permission state is ambiguous (not granted, not explicitly deniedForever). Status: $status");
      // This case might be `restricted` or `limited`. For now, treat as a problem.
      await _showPersistentLocationSnackbar(isPermissionDenied: true);
      return false;
    }
  }

  /// Shows a persistent SnackBar prompting the user to enable location services.
  /// Uses `navigatorKey.currentContext` to display the SnackBar globally.
  /// `isPermissionDenied` helps tailor the message slightly.
  Future<void> _showPersistentLocationSnackbar({required bool isPermissionDenied}) async {
    if (_isDialogShown || navigatorKey.currentContext == null) return;

    _isDialogShown = true; // Set flag to prevent duplicates

    final context = navigatorKey.currentContext!;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Remove any existing snackbars first to avoid duplicates
    scaffoldMessenger.hideCurrentSnackBar();

    String message = isPermissionDenied
        ? "Location permission denied. Please enable it in app settings."
        : "Location services are disabled. Please enable them.";

    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        ),
        duration: const Duration(days: 1), // Very long duration to make it persistent
        behavior: SnackBarBehavior.fixed, // Stays at the bottom, covers content
        action: SnackBarAction(
          label: 'Open Settings',
          textColor: Colors.yellowAccent,
          onPressed: () {
            // Decide which settings to open based on the type of issue
              if (isPermissionDenied) {
              openAppSettings(); // Open app specific settings
            } else {
              Geolocator.openLocationSettings(); // Open device location settings
            }
          },
        ),
        backgroundColor: Colors.redAccent,
      ),
    ).closed.then((reason) {
      // Reset the flag once the snackbar is closed.
      _isDialogShown = false;
    });
  }

  /// Hides the persistent location SnackBar if it is currently shown.
  void _hidePersistentLocationSnackbar() {
    if (navigatorKey.currentContext != null && _isDialogShown) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).hideCurrentSnackBar();
      _isDialogShown = false; // Reset the flag
    }
  }

  /// A utility function to wait for location service to become enabled.
  /// It polls `Geolocator.isLocationServiceEnabled()` for a given duration.
  Future<bool> _waitForLocationServiceEnabled({Duration timeout = const Duration(seconds: 5), Duration interval = const Duration(milliseconds: 500)}) async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) return true; // Already enabled

    print("Attempting to wait for location service to become enabled...");
    DateTime startTime = DateTime.now();

    while (DateTime.now().difference(startTime) < timeout) {
      await Future.delayed(interval);
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (serviceEnabled) {
        print("Location service became enabled after waiting.");
        return true;
      }
    }
    print("Location service did not become enabled within timeout.");
    return false; // Timeout reached, service still not enabled
  }


  /// Starts continuous tracking of the user's location.
  /// Emits location updates to the `locationStream`.
  Future<bool> startTracking() async {
    _hidePersistentLocationSnackbar(); // Always try to hide if active before re-checking

    // if (_isDialogShown) { // Check if a dialog/snackbar is already active from a previous attempt
    //   return false; // Already handling a permission/service issue
    // }

    // 1. Request Permissions
    bool hasPermission = await _requestPermission();
    if (!hasPermission) {
      _locationServiceStatusNotifier.value = false; // Update status
      return false; // Permission not granted (snackbar already shown by _requestPermission if needed)
    }

    // 2. Wait for Location Service to be enabled after permission is granted
    bool serviceEnabled = await _waitForLocationServiceEnabled();
    if (!serviceEnabled) {
      print("⚠️ Location services are OFF after permission and wait. Prompting user...");
      _locationServiceStatusNotifier.value = false; // Update status
      await _showPersistentLocationSnackbar(isPermissionDenied: false); // It's a service issue now
      return false; // Service still off
    }

    _hidePersistentLocationSnackbar(); // Ensure snackbar is hidden if service is now enabled
    _locationServiceStatusNotifier.value = true;
    // Stop previous tracking if any to avoid multiple subscriptions
    stopTracking();

    // 3. Get Initial Position
    try {
      Position initialPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 60),
      );
      String address = await _getAddressFromLatLng(
          initialPosition.latitude, initialPosition.longitude);

      // Only add initial position if it's new or sufficiently different
      if (_lastReportedPosition == null ||
          Geolocator.distanceBetween(
              _lastReportedPosition!.latitude,
              _lastReportedPosition!.longitude,
              initialPosition.latitude,
              initialPosition.longitude) > _minDistanceForUpdate) {
        _locationController.add({
          "latitude": initialPosition.latitude,
          "longitude": initialPosition.longitude,
          "address": address,
        });
        _lastReportedPosition = initialPosition;
        _lastUpdateTime = DateTime.now();
        print("✅ Initial Location: $address");
      } else {
        print("Initial Location: Same as last, not adding to stream.");
      }

    } catch (e) {
      print("⚠️ Error Getting Initial Location: $e");
      _locationServiceStatusNotifier.value = false; // Indicate error
      return false; // Error getting initial location
    }

    // 4. Start Continuous Stream for updates
    positionStream = Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: _minDistanceForUpdate, // Use the configured minimum distance
      ),
    ).listen(
          (Position position) async {
        // Check if enough time has passed and if the position has significantly changed
        bool hasMovedSignificantly = _lastReportedPosition == null ||
            Geolocator.distanceBetween(
                _lastReportedPosition!.latitude,
                _lastReportedPosition!.longitude,
                position.latitude,
                position.longitude) > _minDistanceForUpdate;

        bool enoughTimePassed = DateTime.now().difference(_lastUpdateTime).inMilliseconds >= _minTimeBetweenUpdatesMs;

        if (hasMovedSignificantly && enoughTimePassed) {
          try {
            String address = await _getAddressFromLatLng(
                position.latitude, position.longitude);
            _locationController.add({
              "latitude": position.latitude,
              "longitude": position.longitude,
              "address": address,
            });
            _lastReportedPosition = position;
            _lastUpdateTime = DateTime.now();
            print(
                "📍 Live Location: Lat: ${position.latitude}, Lng: ${position.longitude} 🏠 $address");
          } catch (e) {
            print("⚠️ Error in location stream (getAddress): $e");
          }
        }
      },
      onError: (e) {
        print("⚠️ Location stream error: $e");
        // Re-check status on error (e.g., if permissions revoked while tracking)
        _checkLocationServiceStatus();
      },
      cancelOnError: false, // Don't cancel stream on first error
    );

    return true; // Tracking started successfully
  }

  // get location at once
  Future<Map<String, dynamic>> getSingleLocation() async {
    _hidePersistentLocationSnackbar(); // Hide any active snackbar

    // if (_isDialogShown) { // Check if a dialog/snackbar is already active
    //   return {}; // Already handling a permission/service issue
    // }

    // 1. Request Permissions
    bool hasPermission = await _requestPermission();
    if (!hasPermission) {
      _locationServiceStatusNotifier.value = false; // Update status
      return {}; // Snackbar already shown by _requestPermission if needed
    }

    // 2. Wait for Location Service to be enabled after permission is granted
    bool serviceEnabled = await _waitForLocationServiceEnabled();
    if (!serviceEnabled) {
      _locationServiceStatusNotifier.value = false; // Update status
      await _showPersistentLocationSnackbar(isPermissionDenied: false); // It's a service issue now
      return {}; // Cannot get single location if service is off
    }

    _hidePersistentLocationSnackbar(); // Ensure snackbar is hidden if service is now enabled
    _locationServiceStatusNotifier.value = true;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 60),
      );
      String address =
      await _getAddressFromLatLng(position.latitude, position.longitude);
      return {
        "latitude": position.latitude,
        "longitude": position.longitude,
        "address": address,
      };
    } catch (e) {
      print("⚠️ Error getting single location: $e");
      _locationServiceStatusNotifier.value = false; // Indicate error
      return {};
    }
  }

  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        List<String> addressParts = [];
        if (place.street != null && place.street!.isNotEmpty) addressParts.add(place.street!);
        if (place.subLocality != null && place.subLocality!.isNotEmpty) addressParts.add(place.subLocality!);
        if (place.locality != null && place.locality!.isNotEmpty) addressParts.add(place.locality!);
        if (place.postalCode != null && place.postalCode!.isNotEmpty) addressParts.add(place.postalCode!);
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) addressParts.add(place.administrativeArea!);
        if (place.country != null && place.country!.isNotEmpty) addressParts.add(place.country!);

        return addressParts.join(', ');
      }
      return "Address Not Found";
    } catch (e) {
      print("⚠️ Error Fetching Address: $e");
      return "Error Fetching Address";
    }
  }

  void stopTracking() {
    positionStream?.cancel(); // Cancel the stream subscription
    positionStream = null; // Set to null after canceling
    _lastReportedPosition = null; // Reset last reported position
    _hidePersistentLocationSnackbar(); // Ensure snackbar is hidden
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer in dispose
    stopTracking();
    _locationController.close();
    _locationServiceStatusNotifier.dispose(); // Dispose the notifier
  }
}