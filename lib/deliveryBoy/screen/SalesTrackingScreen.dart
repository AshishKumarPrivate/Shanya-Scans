import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthians/network_manager/repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:healthians/ui_helper/storage_helper.dart';
import 'dart:ui' as ui;

class SalesLiveTrackingScreen extends StatefulWidget {
  @override
  _SalesLiveTrackingScreenState createState() => _SalesLiveTrackingScreenState();
}

class _SalesLiveTrackingScreenState extends State<SalesLiveTrackingScreen> {
  late GoogleMapController _mapController;
  IO.Socket? _socket;
  LatLng _salesPersonPosition = LatLng(StorageHelper().getSalesLat(), StorageHelper().getSalesLng());
  LatLng _userPosition = LatLng(StorageHelper().getUserLat(), StorageHelper().getUserLong());
  Set<Polyline> _polylines = {};
  bool hasArrived = false;

  late BitmapDescriptor _salesPersonIcon;
  late BitmapDescriptor _salesPersonArrivedIcon;
  String salesPersonName = "Rahul Sharma";
  String salesPersonPhone = "+91 9876543210";

  @override
  void initState() {
    super.initState();
    _connectToSocket();
    _startLocationUpdates();
    _updatePolylines(); // ✅ Force update on first load
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_socket == null || !_socket!.connected) {
      _connectToSocket();
      _startLocationUpdates();
    }
    _updatePolylines(); // ✅ Ensure polyline updates on every navigation
  }

  /// **1️⃣ Connect to Socket.IO Server**
  void _connectToSocket() {
    print("User and Sales lat long => "
        "${StorageHelper().getSalesLat()}, ${StorageHelper().getSalesLng()} /// "
        "${StorageHelper().getUserLat()}, ${StorageHelper().getUserLong()}");

    _socket = IO.io("${Repository.baseUrl}", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": true,
    });

    _socket!.onConnect((_) {
      print("Connected to Socket.IO ✅");
      _socket!.emit("join-room", {"salesId": StorageHelper().getDeliveryBoyId()});
    });

    /// **2️⃣ Listen for Salesperson's Location Updates from Backend**
    _socket!.on("updated-track-lat-lng", (data) {
      print("Updated Data: $data");

      if (data is Map<String, dynamic>) {
        double salesLat = data['sales_lat']?.toDouble() ?? 0.0;
        double salesLng = data['sales_lng']?.toDouble() ?? 0.0;
        double userLat = data['user_lat']?.toDouble() ?? 0.0;
        double userLng = data['user_lng']?.toDouble() ?? 0.0;

        StorageHelper().setSalesLat(salesLat);
        StorageHelper().setSalesLng(salesLng);
        StorageHelper().setUserLat(userLat);
        StorageHelper().setUserLong(userLng);

        print("Updated Sales Lat/Lng => $salesLat, $salesLng");

        if (mounted) {
          setState(() {
            _salesPersonPosition = LatLng(salesLat, salesLng);
            _updatePolylines(); // ✅ Update polyline immediately
          });
        }
      }
    });

    _socket!.emit("change-track-path", {
      "orderDetailId": StorageHelper().getUserOrderId(),
    });

    _socket!.onDisconnect((_) {
      print("Disconnected from Socket.IO ❌");
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
  void _updatePolylines() {
    if (hasArrived) return;
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

  @override
  void dispose() {
    _socket?.disconnect();
    _socket?.dispose();
    super.dispose();
  }

  // Load image from assets and convert to BitmapDescriptor
  // Convert asset image to Uint8List for BitmapDescriptor
  Future<BitmapDescriptor> _getBytesFromAsset(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final Uint8List bytes = data.buffer.asUint8List();

    final ui.Codec codec = await ui.instantiateImageCodec(bytes, targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  // Load custom icons
  void _loadCustomIcons() async {
    _salesPersonIcon = await _getBytesFromAsset('assets/sales_person_marker.png', 100);
    _salesPersonArrivedIcon = await _getBytesFromAsset('assets/sales_person_arrived.png', 100);

    setState(() {}); // Refresh UI after loading markers
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
            },
            markers: {
              Marker(
                markerId: MarkerId('sales_person'),
                position: _salesPersonPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  hasArrived ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueBlue,
                ),
              ),
              Marker(
                markerId: MarkerId('user'),
                position: _userPosition,
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
            },
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
