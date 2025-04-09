import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

import '../main.dart';

class ConfigUtils {
  StreamSubscription<Position>? positionStream;
  final StreamController<Map<String, dynamic>> _locationController = StreamController.broadcast();
  Timer? locationTimer;

  Stream<Map<String, dynamic>> get locationStream => _locationController.stream;

  // Request Location Permission Before Tracking
  Future<bool> _requestPermission() async {

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        print("❌ Location permission denied.");
        return false;
      }
    }


    var status = await Permission.location.request();
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      print("❌ Location Permission Denied.");
      return false;
    } else if (status.isPermanentlyDenied) {
      print("⚠️ Location permission is permanently denied. Enable it from settings.");
      openAppSettings();
      return false;
    }
    return false;
  }

  // Convert Latitude & Longitude to Address
  Future<String> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];

        // print("Name: ${place.name}");
        // print("Street: ${place.street}");
        // print("SubLocality: ${place.subLocality}");
        // print("Locality: ${place.locality}");
        // print("SubAdministrativeArea: ${place.subAdministrativeArea}");
        // print("AdministrativeArea: ${place.administrativeArea}");
        // print("PostalCode: ${place.postalCode}");
        // print("Country: ${place.country}");
        // print("ISO Country Code: ${place.isoCountryCode}");
        // print("Thoroughfare: ${place.thoroughfare}");
        // print("SubThoroughfare: ${place.subThoroughfare}");

        return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}";
        return "${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.administrativeArea}, ${place.country}";
      }
      return "Address Not Found";
    } catch (e) {
      print("⚠️ Error Fetching Address: $e");
      return "Error Fetching Address";
    }
  }
  void _showEnableLocationDialog() {
    if (navigatorKey.currentContext == null) {
      print("❗ navigatorKey context is null, cannot show dialog.");
      return;
    }

    showDialog(
      context: navigatorKey.currentContext!, // Replace with your global navigator key
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          title: const Text("Enable Location"),
          content: const Text("Location services are disabled. Please enable them in settings."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Geolocator.openLocationSettings();
              },
              child: const Text("Open Settings"),
            ),
          ],
        );
      },
    );
  }


  // Start Real-Time Location Tracking (Every 5 Seconds)
  // void startTracking() async {
  //
  //   bool hasPermission = await _requestPermission();
  //   if (!hasPermission) return;
  //
  //   LocationPermission permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied ||
  //       permission == LocationPermission.deniedForever) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied ||
  //         permission == LocationPermission.deniedForever) {
  //       print("❌ Location permission denied.");
  //       return;
  //     }
  //   }
  //
  //
  //
  //   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     print("⚠️ Location services are OFF. Prompting user...");
  //     // Show dialog to turn on location
  //     _showEnableLocationDialog();
  //     // Wait and check again after user returns from settings
  //     await Future.delayed(Duration(seconds: 5));
  //     serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       print("❌ Location services are still OFF.");
  //       return;
  //     }
  //   }
  //
  //   // ✅ Get initial location immediately
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.high,
  //     );
  //     String address = await _getAddressFromLatLng(position.latitude, position.longitude);
  //     _locationController.add({
  //       "latitude": position.latitude,
  //       "longitude": position.longitude,
  //       "address": address,
  //     });
  //
  //     print("✅ Initial Location: $address");
  //   } catch (e) {
  //     print("⚠️ Error Getting Initial Location: $e");
  //   }
  //
  //   locationTimer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
  //     try {
  //       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //       String address = await _getAddressFromLatLng(position.latitude, position.longitude);
  //       // Emit data to listeners
  //       _locationController.add({
  //         "latitude": position.latitude,
  //         "longitude": position.longitude,
  //         "address": address
  //       });
  //
  //
  //       print("📍 Live Location: Lat: ${position.latitude}, Lng: ${position.longitude} 🏠 Address: $address");
  //       // print("🏠 Address: $address");
  //     } catch (e) {
  //       print("⚠️ Error Fetching Location: $e");
  //     }
  //   });
  // }

  // Stop Location Tracking
  void startTracking() async {
    bool hasPermission = await _requestPermission();
    if (!hasPermission) return;

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("⚠️ Location services are OFF. Prompting user...");
      _showEnableLocationDialog();
      await Future.delayed(Duration(seconds: 5));
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print("❌ Location services are still OFF.");
        return;
      }
    }

    // Get initial position
    try {
      Position initialPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      String address = await _getAddressFromLatLng(initialPosition.latitude, initialPosition.longitude);
      _locationController.add({
        "latitude": initialPosition.latitude,
        "longitude": initialPosition.longitude,
        "address": address,
      });

      print("✅ Initial Location: $address");
    } catch (e) {
      print("⚠️ Error Getting Initial Location: $e");
    }

    // Stream for continuous updates
    positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // get update every 10 meters
      ),
    ).listen((Position position) async {
      try {
        String address = await _getAddressFromLatLng(position.latitude, position.longitude);
        _locationController.add({
          "latitude": position.latitude,
          "longitude": position.longitude,
          "address": address,
        });

        print("📍 Live Location: Lat: ${position.latitude}, Lng: ${position.longitude} 🏠 $address");
      } catch (e) {
        print("⚠️ Error in location stream: $e");
      }
    });
  }
  // get location at once

  Future<Map<String, dynamic>> getSingleLocation() async {
    bool hasPermission = await _requestPermission();
    if (!hasPermission) return {};

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showEnableLocationDialog();
      await Future.delayed(Duration(seconds: 5));
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return {};
      }
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      String address = await _getAddressFromLatLng(position.latitude, position.longitude);
      return {
        "latitude": position.latitude,
        "longitude": position.longitude,
        "address": address,
      };
    } catch (e) {
      print("⚠️ Error getting single location: $e");
      return {};
    }
  }



  void stopTracking() {
    locationTimer?.cancel();
    positionStream?.cancel();
    _locationController.close();
  }
}
