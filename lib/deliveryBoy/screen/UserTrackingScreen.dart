///////// user tracking screen //////
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthians/network_manager/repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:healthians/ui_helper/storage_helper.dart';

class UserLiveTrackingScreen extends StatefulWidget {

  // String? userLat, userLong;
  //
  // LiveTrackingScreen({
  //   required this.userLat,
  //   required this.userLong,
  // });


  @override
  _UserLiveTrackingScreenState createState() => _UserLiveTrackingScreenState();
}

class _UserLiveTrackingScreenState extends State<UserLiveTrackingScreen> {
  late GoogleMapController _mapController;
  IO.Socket? _socket;
  LatLng _salesPersonPosition = LatLng(StorageHelper().getSalesLat(), StorageHelper().getSalesLng());
  LatLng _userPosition = LatLng(StorageHelper().getUserLat(), StorageHelper().getUserLong()); // Example user location
  // LatLng _userPosition = LatLng(26.883301, 80.983299); // Example user location
  Set<Polyline> _polylines = {};
  Set<Marker> _markers = {}; // ✅ Marker set added
  bool hasArrived = false;

  String salesPersonName = "Rahul Sharma";
  String salesPersonPhone = "+91 9876543210";

  @override
  void initState() {
    super.initState();
    _connectToSocket();
    _startLocationUpdates();
  }

  /// **1️⃣ Connect to Socket.IO Server**
  void _connectToSocket() {
    // print("User and Sales lat long => "
    //     "${StorageHelper().getSalesLat()}, ${StorageHelper().getSalesLng()} /// "
    //     "${StorageHelper().getUserLat()}, ${StorageHelper().getUserLong()}");

    _socket = IO.io("${Repository.baseUrl}", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });

    // print("user and sales lat long => ${StorageHelper().getUserLat()} , ${StorageHelper().getUserLong()} //// ${StorageHelper().getSalesLat()} , ${StorageHelper().getSalesLng()} ");

    _socket!.onConnect((_) {
      print("Connected to Socket.IO ✅");

      _socket!.emit("get-sales-lat-lng", {
        "orderDetailId": StorageHelper().getUserOrderId(),
      });

    });

    _socket!.on("get-updated-sales-lat-lng", (data) {
      print("Raw Data Received: $data");

      // Check if data is a Map before accessing values
      if (data is Map<String, dynamic>) {
        print("inside the if condition");
        print("Sales Latitude: ${data['sales_lat']}");
        print("Sales Longitude: ${data['sales_lng']}");

        // Convert to double if necessary
        double salesLat = double.tryParse(data['sales_lat'].toString())??0.0;
        double salesLng = double.tryParse(data['sales_lng'].toString()) ??0.0;

        print("Sales Lat: $salesLat, Sales Lng: $salesLng");
        print("after getting data ");
        // Store in StorageHelper
        StorageHelper().setSalesLat(salesLat);
        StorageHelper().setSalesLng(salesLng);
        setState(() {
          _salesPersonPosition = LatLng(salesLat, salesLng);

        });
        // Markers aur Polylines ko setState ke baad update karein
        _updateMarkers();
        _updatePolylines();
        _moveCameraToSalesPerson();
        // _updatePolylines();
        print("Stored in StorageHelper: ${StorageHelper().getSalesLat()}, ${StorageHelper().getSalesLng()} /// ${StorageHelper().getUserLat()} , ${StorageHelper().getUserLong()}");
      } else {
        print("Error: Data is not in Map format -> $data");
      }
    });

    _socket!.onDisconnect((_) {
      print("Disconnected from Socket.IO ❌");
    });
  }


  /// **3️⃣ Fetch Current Location (for salesperson)**
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
          _salesPersonPosition = LatLng(position.latitude, position.longitude);
          _updateMarkers(); // ✅ Marker update here
          _updatePolylines();
        });
      }

      /// **4️⃣ Send Salesperson's Updated Location to Backend**
      // _socket!.emit("change-track-path", {
      //   "orderDetailId": StorageHelper().getUserOrderId(),
      // });
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
          icon: BitmapDescriptor.defaultMarkerWithHue(
            hasArrived ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueBlue,
          ),
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



  /// **5️⃣ Update Route Polyline**
  void _updatePolylines() {
    setState(() {
      _polylines.clear();
      _polylines.add(
        Polyline(
          polylineId: PolylineId("route"),
          color: Colors.blue,
          width: 5,
          points: [_salesPersonPosition, _userPosition],
        ),
      );
    });
  }



  /// **🔹 Move Camera to Salesperson's Location**
  void _moveCameraToSalesPerson() {
    if (_mapController != null) {
      _mapController.animateCamera(
        CameraUpdate.newLatLng(_salesPersonPosition),
      );
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
      appBar: AppBar(title: Text('Live Tracking')),
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

            markers: _markers, // ✅ Use updated markers
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
                          Text(salesPersonName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          Text(salesPersonPhone, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  if (!hasArrived)
                    LinearProgressIndicator(color: Colors.blue, backgroundColor: Colors.grey[300]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
