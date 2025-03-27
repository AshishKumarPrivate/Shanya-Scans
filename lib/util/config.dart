import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:permission_handler/permission_handler.dart';

class ConfigUtils {
  StreamSubscription<Position>? positionStream;
  final StreamController<Map<String, dynamic>> _locationController = StreamController.broadcast();
  Timer? locationTimer;

  Stream<Map<String, dynamic>> get locationStream => _locationController.stream;

  // Request Location Permission Before Tracking
  Future<bool> _requestPermission() async {
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
        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }
      return "Address Not Found";
    } catch (e) {
      print("⚠️ Error Fetching Address: $e");
      return "Error Fetching Address";
    }
  }

  // Start Real-Time Location Tracking (Every 5 Seconds)
  void startTracking() async {
    bool hasPermission = await _requestPermission();
    if (!hasPermission) return;

    locationTimer = Timer.periodic(Duration(seconds: 5), (Timer t) async {
      try {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        String address = await _getAddressFromLatLng(position.latitude, position.longitude);

        // Emit data to listeners
        _locationController.add({
          "latitude": position.latitude,
          "longitude": position.longitude,
          "address": address
        });


        print("📍 Live Location: Lat: ${position.latitude}, Lng: ${position.longitude} 🏠 Address: $address");
        // print("🏠 Address: $address");
      } catch (e) {
        print("⚠️ Error Fetching Location: $e");
      }
    });
  }

  // Stop Location Tracking
  void stopTracking() {
    locationTimer?.cancel();
    positionStream?.cancel();
    _locationController.close();
  }
}
