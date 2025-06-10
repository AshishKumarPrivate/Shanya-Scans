import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shanya_scans/network_manager/repository.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shanya_scans/ui_helper/storage_helper.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:ui' as ui;
import 'dart:math' as math;

import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../ui_helper/responsive_helper.dart';
import '../controller/socket_provider.dart';

class SalesLiveTrackingScreen extends StatefulWidget {
  String? patientname;
  SalesLiveTrackingScreen(this.patientname);

  @override
  _SalesLiveTrackingScreenState createState() => _SalesLiveTrackingScreenState();
}

class _SalesLiveTrackingScreenState extends State<SalesLiveTrackingScreen> {
  late GoogleMapController _mapController;
  IO.Socket? _socket;
  LatLng _salesPersonPosition = LatLng(StorageHelper().getSalesLat(), StorageHelper().getSalesLng());
  LatLng _userPosition = LatLng(StorageHelper().getUserLat(), StorageHelper().getUserLong());
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {}; // ✅ Marker set added
  bool hasArrived = false;
  double bearing = 0.0;

  late BitmapDescriptor _salesPersonIcon;
  late BitmapDescriptor _salesPersonArrivedIcon;
  String? salesPersonName ;
  String salesPersonPhone = "Patient Name";
  late BitmapDescriptor customIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomMarker();
    // _connectToSocket();
    _startLocationUpdates();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final socketProvider = Provider.of<SocketProvider>(context);

    // Add a post frame callback to ensure setState() is not called during the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (socketProvider.salesPersonPosition.latitude != 0 && socketProvider.salesPersonPosition.longitude != 0) {
        setState(() {
          _salesPersonPosition = socketProvider.salesPersonPosition;
        });
        _updateMarkers();
        _updatePolylines();
      }
      print("Socket Reconnect✅ ");
    });
    print("Socket Reconnect✅ ");
  }

  // ✅ Load custom marker function
  Future<void> _loadCustomMarker() async {

    salesPersonName = await StorageHelper().getDeliveryBoyName();
    final Uint8List markerIcon =
    await _getBytesFromAsset('assets/images/shanya_marker.png', 100);
    setState(() {
      customIcon = BitmapDescriptor.fromBytes(markerIcon);
    });
  }

  // ✅ Convert asset image to bytes
  Future<Uint8List> _getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? byteData =
    await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  double calculateBearing(LatLng start, LatLng end) {
    double lat1 = start.latitude * (math.pi / 180);
    double lat2 = end.latitude * (math.pi / 180);
    double longDiff = (end.longitude - start.longitude) * (math.pi / 180);

    double x = math.sin(longDiff) * math.cos(lat2);
    double y = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(longDiff);

    bearing = math.atan2(x, y) * (180 / math.pi);
    return (bearing + 360) % 360; // Ensure positive angle
  }

  // void _updateMarkers() {
  //   setState(() {
  //     _markers.clear();
  //     _markers.add(
  //       Marker(
  //         markerId: MarkerId('sales_person'),
  //         position: _salesPersonPosition,
  //         rotation: bearing, // ✅ Rotation apply karein
  //         icon: customIcon,
  //         // icon: BitmapDescriptor.defaultMarkerWithHue(
  //         //   hasArrived ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueBlue,
  //         // ),
  //       ),
  //     );
  //     _markers.add(
  //       Marker(
  //         markerId: MarkerId('user'),
  //         position: _userPosition,
  //         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
  //       ),
  //     );
  //   });
  // }

  void updateMarkerSmoothly(LatLng newPosition) {
    final GoogleMapController controller = _mapController;
    // ✅ Bearing calculate karein
    double bearing = calculateBearing(_salesPersonPosition, newPosition);

    // Camera ko naye position pe smoothly animate karo
    controller.animateCamera(CameraUpdate.newLatLng(newPosition));

    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('sales_person'),
          position: newPosition,
          icon: customIcon,
          rotation: bearing,
          // ✅ Rotation apply karein
          anchor: Offset(0.5, 0.5), // ✅ Center se rotate hoga
          // icon: BitmapDescriptor.defaultMarkerWithHue(
          //   hasArrived ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueBlue,
          // ),
        ),
      );
    });
  }
  /// **3️⃣ Update Markers on Map**
  void _updateMarkers() {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: MarkerId('sales_person'),
          position: _salesPersonPosition,
          rotation: bearing, // ✅ Rotation apply karein
          icon: customIcon,
          // icon: BitmapDescriptor.defaultMarkerWithHue(
          //   hasArrived ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueBlue,
          // ),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('user'),
          position: _userPosition,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
    });
  }


  /// **3️⃣ Fetch Current Location**
  void _startLocationUpdates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        print("Location permissions are permanently denied.");
        return;
      }
    }

    Geolocator.getPositionStream(
      locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
    ).listen((Position position) {
      double latitude = position.latitude;
      double longitude = position.longitude;

      if (mounted) {
        setState(() {
          _salesPersonPosition = LatLng(latitude, longitude);
          _updatePolylines(); // ✅ Update polyline when location changes
        });
      }
    });
  }

  /// **4️⃣ Update Polyline Instantly**

  void _updatePolylines() async {
    List<LatLng> routeCoordinates =
    await getRouteCoordinates(_salesPersonPosition, _userPosition);

    setState(() {
      _polylines.clear();
      if (routeCoordinates.isNotEmpty) {
        _polylines.add(
          Polyline(
            polylineId: PolylineId("route"),
            color: Colors.blue,
            width: 5,
            points: routeCoordinates,
          ),
        );
      }
    });
  }
  Future<List<LatLng>> getRouteCoordinates(
      LatLng source, LatLng destination) async {
    const String googleAPIKey = "AIzaSyC9ZOZHwHmyTWXqACqpZY2TL7wX2_Zn05U"; // 🔹 API Key add karein

    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleAPIKey&mode=driving";

    try {
      var response = await Dio().get(url);
      Map values = response.data;
      if (values['status'] == 'OK') {
        List<LatLng> routePoints = [];
        var steps = values['routes'][0]['legs'][0]['steps'];

        for (var step in steps) {
          // double lat = step['end_location']['lat'];
          // double lng = step['end_location']['lng'];
          // routePoints.add(LatLng(lat, lng));
          double startLat = step['start_location']['lat'];
          double startLng = step['start_location']['lng'];
          double endLat = step['end_location']['lat'];
          double endLng = step['end_location']['lng'];

          routePoints.add(LatLng(startLat, startLng)); // ✅ Include start point
          routePoints.add(LatLng(endLat, endLng)); // ✅ Include end point
        }
        return routePoints;
      } else {
        print("Google Directions API Error: ${values['status']}");
        return [];
      }
    } catch (e) {
      print("Error fetching route: $e");
      return [];
    }
  }


  @override
  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.deliveryPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          // onPressed: () =>
          //     _showExitDialog(context), // Show exit confirmation dialog
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Track Patient",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        // actions: [
        //   IconButton(
        //     icon:
        //         const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        //     onPressed: () {},
        //   ),
        // ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _salesPersonPosition,
              zoom: 15,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              _updateMarkers(); // ✅ Ensure markers are set after map creation
              _updatePolylines();
            },
            markers: _markers,
            polylines: _polylines,
          ),

          // Bottom Status Box
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    hasArrived
                        ? "Salesperson has reached the destination!"
                        : "Salesperson is on the way...",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(salesPersonPhone, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                          Text(widget.patientname.toString(), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (!hasArrived)
                    LinearProgressIndicator(
                        color: Colors.blue, backgroundColor: Colors.grey[300]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
