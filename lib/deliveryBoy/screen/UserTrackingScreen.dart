import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shanya_scans/ui_helper/storage_helper.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;

import 'package:shanya_scans/ui_helper/app_colors.dart';
import '../controller/socket_provider.dart';

class UserLiveTrackingScreen extends StatefulWidget {
  final String? salesPersonName,patientName ;
  const UserLiveTrackingScreen({super.key, this.salesPersonName, this.patientName});

  @override
  State<UserLiveTrackingScreen> createState() => _UserLiveTrackingScreenState();
}

class _UserLiveTrackingScreenState extends State<UserLiveTrackingScreen> {
  late GoogleMapController _mapController;

  // Initialize with values from StorageHelper
  LatLng _salesPersonPosition =  LatLng(StorageHelper().getSalesLat(), StorageHelper().getSalesLng());
  LatLng _userPosition =  LatLng(StorageHelper().getUserLat(), StorageHelper().getUserLong());

  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {};
  bool hasArrived = false;
  double bearing = 0.0;

  String salesPersonDisplayName = "Sales Person";
  String salesPersonPhone = "Not Available";

  BitmapDescriptor customSalesPersonIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
  BitmapDescriptor defaultSalesPersonIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

  List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();

    _loadCustomMarker();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final socketProvider = Provider.of<SocketProvider>(context, listen: false);

      // Start listening for location updates
      socketProvider.listenToSalesPersonLocation(StorageHelper().getUserOrderId());

      // Add a listener to react to changes in SocketProvider's salesPersonPosition
      socketProvider.addListener(_handleSalesPersonLocationUpdate);

      // Initial check for position in case socket already connected and data received before listener attached
      _handleSalesPersonLocationUpdate();
    });
  }

  @override
  void dispose() {
    // Remove the listener when the widget is disposed
    Provider.of<SocketProvider>(context, listen: false).removeListener(_handleSalesPersonLocationUpdate);
    super.dispose();
  }

  void _handleSalesPersonLocationUpdate() {
    // We are listening to changes in SocketProvider directly.
    // So, we get the current salesPersonPosition from the provider.
    final socketProvider = Provider.of<SocketProvider>(context, listen: false);
    LatLng newPosition = socketProvider.salesPersonPosition;

    // Check if the new position is valid (not 0.0, 0.0 which could be initial uninitialized state)
    if (newPosition.latitude != 0.0 || newPosition.longitude != 0.0) {
      // Check if the position has actually changed to update bearing and marker
      // Using a small epsilon to account for floating point inaccuracies
      const double epsilon = 0.000001;
      if ((newPosition.latitude - _salesPersonPosition.latitude).abs() > epsilon ||
          (newPosition.longitude - _salesPersonPosition.longitude).abs() > epsilon) {

        double newBearing = _calculateBearing(_salesPersonPosition, newPosition);

        setState(() {
          _salesPersonPosition = newPosition;
          bearing = newBearing;
          _updateMarkers(); // Update marker position and rotation
        });

        // Animate camera to the new salesperson position
        _mapController.animateCamera(CameraUpdate.newLatLng(_salesPersonPosition));

        // Re-calculate and redraw polyline from current position to user.
        // This makes the route dynamic as the sales person moves.
        _updatePolylines();
      }

      // Check for arrival
      double remainingDistance = Geolocator.distanceBetween(
        _salesPersonPosition.latitude,
        _salesPersonPosition.longitude,
        _userPosition.latitude,
        _userPosition.longitude,
      );

      // Define a small threshold for arrival, e.g., 50 meters
      if (remainingDistance < 50 && !hasArrived) {
        setState(() {
          hasArrived = true;
        });
        print("Salesperson has arrived at the destination!");
        // Optionally, stop listening for location updates if arrival is definitive
        // Make sure your SocketProvider has a method to stop listening, e.g., `stopListeningToSalesPersonLocation()`
        // You had `st()` which was likely a typo.
        socketProvider.disposeSocket(); // Assuming disposeSocket() stops all socket activity
      } else if (remainingDistance >= 50 && hasArrived) {
        // If they moved away after arriving, reset status (optional)
        setState(() {
          hasArrived = false;
        });
      }
    }
  }


  Future<void> _loadCustomMarker() async {
    try {
      String? name = await StorageHelper().getDeliveryBoyName();
      if (name != null) {
        salesPersonDisplayName = name;
      }

      // You might also want to fetch phone number here if available via StorageHelper
      // String? phone = await StorageHelper().getDeliveryBoyPhone(); // Assuming you have this
      // if (phone != null) {
      //   salesPersonPhone = phone;
      // }


      final Uint8List markerIconBytes =
      await _getBytesFromAsset('assets/images/sales_marker.png', 100);
      setState(() {
        customSalesPersonIcon = BitmapDescriptor.fromBytes(markerIconBytes);
        _updateMarkers(); // Update markers after custom icon is loaded
      });
    } catch (e) {
      print("Error loading custom marker: $e");
    }
  }

  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? byteData =
    await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  double _calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * (math.pi / 180);
    double lat2 = end.latitude * (math.pi / 180);
    double longDiff = (end.longitude - start.longitude) * (math.pi / 180);

    double x = math.sin(longDiff) * math.cos(lat2);
    double y = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(longDiff);

    double calculatedBearing = math.atan2(x, y) * (180 / math.pi);
    return (calculatedBearing + 360) % 360;
  }

  // This method is now solely for updating the marker visual
  void _updateMarkers() {
    _markers.clear();

    _markers.add(
      Marker(
        markerId: const MarkerId('sales_person'),
        position: _salesPersonPosition,
        rotation: bearing,
        icon: customSalesPersonIcon,
        anchor: const Offset(0.5, 0.5),
        infoWindow: InfoWindow(
          title: salesPersonDisplayName,
          snippet: salesPersonPhone,
        ),
      ),
    );

    _markers.add(
      Marker(
        markerId: const MarkerId('user_location'),
        position: _userPosition,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'Your Destination'),
      ),
    );
  }

  Future<void> _updatePolylines() async {
    // Only draw polyline if both points are valid
    if ((_salesPersonPosition.latitude == 0.0 && _salesPersonPosition.longitude == 0.0) ||
        (_userPosition.latitude == 0.0 && _userPosition.longitude == 0.0)) {
      print("Cannot draw polyline: Salesperson or user location not set properly.");
      return;
    }

    // Always fetch a new route from the current salesperson position to the user
    _routePoints = await getRouteCoordinates(_salesPersonPosition, _userPosition);

    // Draw the new polyline
    _drawPolyline();
  }

  // This method simply draws the entire calculated route
  void _drawPolyline() {
    setState(() {
      _polylines.clear(); // Clear the old polyline
      if (_routePoints.isNotEmpty) {
        _polylines.add(
          Polyline(
            polylineId: const PolylineId("route"),
            color: AppColors.primary,
            width: 5,
            points: _routePoints, // Draw the entire route from current sales person position
            jointType: JointType.round,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
          ),
        );
      }
    });
  }

  Future<List<LatLng>> getRouteCoordinates(
      LatLng source, LatLng destination) async {
    const String googleAPIKey = "AIzaSyC9ZOZHwHmyTWXqACqpZY2TL7wX2_Zn05U"; // <--- REPLACE THIS WITH YOUR KEY!

    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleAPIKey&mode=driving";

    try {
      var response = await Dio().get(url);
      Map values = response.data;
      if (values['status'] == 'OK') {
        String encodedPolyline = values['routes'][0]['overview_polyline']['points'];
        List<PointLatLng> decodedPoints = decodePolyline(encodedPolyline);
        return decodedPoints.map((p) => LatLng(p.latitude, p.longitude)).toList();
      } else {
        print("Google Directions API Error: ${values['status']}");
        if (values['error_message'] != null) {
          print("Error Message: ${values['error_message']}");
        }
        return [];
      }
    } catch (e) {
      print("Error fetching route: $e");
      return [];
    }
  }

  List<PointLatLng> decodePolyline(String encoded) {
    List<PointLatLng> poly = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += dlng;

      poly.add(PointLatLng(lat / 1E5, lng / 1E5));
    }
    return poly;
  }

  void _animateCameraToBounds() {
    if (_salesPersonPosition.latitude == 0.0 && _salesPersonPosition.longitude == 0.0 ||
        _userPosition.latitude == 0.0 && _userPosition.longitude == 0.0) {
      return;
    }

    double minLat = math.min(_salesPersonPosition.latitude, _userPosition.latitude);
    double maxLat = math.max(_salesPersonPosition.latitude, _userPosition.latitude);
    double minLng = math.min(_salesPersonPosition.longitude, _userPosition.longitude);
    double maxLng = math.max(_salesPersonPosition.longitude, _userPosition.longitude);

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SocketProvider>(
      builder: (context, socketProvider, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: const Text(
              "Track Sales Person",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _salesPersonPosition, // Initial target set from stored position
                  zoom: 15,
                ),
                onMapCreated: (GoogleMapController controller) async {
                  _mapController = controller;
                  _updateMarkers(); // Initial markers
                  await _updatePolylines(); // Get route points and draw initial polyline
                  _animateCameraToBounds(); // Fit map to route
                },
                markers: _markers,
                polylines: _polylines,
                rotateGesturesEnabled: true,
                compassEnabled: true,
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        hasArrived
                            ? "Salesperson has reached your location!"
                            : "Salesperson is on the way...",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: const Icon(Icons.person, color: Colors.white),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Display dynamic sales person name and phone from props or fetched data
                              Text(salesPersonPhone,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600)),
                              Text(widget.salesPersonName ?? salesPersonDisplayName,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[700])),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      if (!hasArrived)
                        LinearProgressIndicator(
                            color: AppColors.primary, backgroundColor: Colors.grey[300]),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class PointLatLng {
  final double latitude;
  final double longitude;
  const PointLatLng(this.latitude, this.longitude);
}