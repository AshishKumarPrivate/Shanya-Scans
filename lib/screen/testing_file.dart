// import 'dart:async';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:healthians/network_manager/repository.dart';
// import 'package:provider/provider.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
// import 'package:healthians/ui_helper/storage_helper.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'dart:math' as math;
//
// import '../controller/socket_provider.dart';
//
// class UserLiveTrackingScreen extends StatefulWidget {
//   // String? userLat, userLong;
//   //
//   // LiveTrackingScreen({
//   //   required this.userLat,
//   //   required this.userLong,
//   // });
//
//   @override
//   _UserLiveTrackingScreenState createState() => _UserLiveTrackingScreenState();
// }
//
// class _UserLiveTrackingScreenState extends State<UserLiveTrackingScreen> {
//   late GoogleMapController _mapController;
//   IO.Socket? _socket;
//   LatLng _salesPersonPosition =LatLng(StorageHelper().getSalesLat(), StorageHelper().getSalesLng());
//   LatLng _userPosition = LatLng(StorageHelper().getUserLat(), StorageHelper().getUserLong()); // Example user location
//   // LatLng _userPosition = LatLng(26.883301, 80.983299); // Example user location
//   Set<Polyline> _polylines = {};
//   Set<Marker> _markers = {}; // ✅ Marker set added
//   bool hasArrived = false;
//   double bearing = 0.0;
//
//   String salesPersonName = "Rahul Sharma";
//   String salesPersonPhone = "+91 9876543210";
//   late BitmapDescriptor customIcon;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadCustomMarker();
//     _connectToSocket();
//     _startLocationUpdates();
//   }
//
//   @override
//   void dispose() {
//     // _socket?.clearListeners();
//     _socket?.disconnect();
//     _socket?.dispose();
//     print("Socket disconnected properly ❌");
//     super.dispose();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // _ensureSocketConnected();
//     _loadCustomMarker();
//     _connectToSocket();
//     _startLocationUpdates();
//     print("Socket Reconnect✅ ");
//   }
//
//   void socketReconnect() {
//     if (!_socket!.connected) {
//       _connectToSocket(); // Ensure reconnection
//     }
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed) {
//       if (!_socket!.connected) {
//         _connectToSocket(); // Reconnect when app comes to foreground
//       }
//     }
//   }
//
//
//   // ✅ Load custom marker function
//   Future<void> _loadCustomMarker() async {
//     final Uint8List markerIcon =
//     await _getBytesFromAsset('assets/images/sales_marker.png', 200);
//     setState(() {
//       customIcon = BitmapDescriptor.fromBytes(markerIcon);
//     });
//   }
//
//   // ✅ Convert asset image to bytes
//   Future<Uint8List> _getBytesFromAsset(String path, int width) async {
//     ByteData data = await rootBundle.load(path);
//     ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
//         targetWidth: width);
//     ui.FrameInfo fi = await codec.getNextFrame();
//     ByteData? byteData =
//     await fi.image.toByteData(format: ui.ImageByteFormat.png);
//     return byteData!.buffer.asUint8List();
//   }
//
//   double calculateBearing(LatLng start, LatLng end) {
//     double lat1 = start.latitude * (math.pi / 180);
//     double lat2 = end.latitude * (math.pi / 180);
//     double longDiff = (end.longitude - start.longitude) * (math.pi / 180);
//
//     double x = math.sin(longDiff) * math.cos(lat2);
//     double y = math.cos(lat1) * math.sin(lat2) -
//         math.sin(lat1) * math.cos(lat2) * math.cos(longDiff);
//
//     bearing = math.atan2(x, y) * (180 / math.pi);
//     return (bearing + 360) % 360; // Ensure positive angle
//   }
//
//   void moveMarkerAlongPolyline(List<LatLng> polylinePoints) async {
//     int index = 0;
//     Timer.periodic(Duration(milliseconds: 300), (Timer timer) {
//       if (index < polylinePoints.length - 1) {
//         LatLng nextPosition = polylinePoints[index];
//
//         // ✅ Bearing calculate karein next point tak
//         double newBearing =
//         calculateBearing(_salesPersonPosition, nextPosition);
//
//         setState(() {
//           _salesPersonPosition = nextPosition;
//           bearing = newBearing; // Direction update karein
//           _updateMarkers();
//         });
//
//         index++;
//       } else {
//         timer.cancel(); // ✅ Stop animation when destination is reached
//       }
//     });
//   }
//
//   /// **1️⃣ Connect to Socket.IO Server**
//   void _connectToSocket() {
//     _socket = IO.io("${Repository.baseUrl}", <String, dynamic>{
//       "transports": ["websocket"],
//       'autoConnect': true, // Ensure automatic connection
//       'reconnection': true, // Enable auto-reconnect
//       'reconnectionAttempts': 5, // Retry up to 5 times
//       'reconnectionDelay': 2000, // Wait 2s before retry
//     });
//
//     // print("user and sales lat long => ${StorageHelper().getUserLat()} , ${StorageHelper().getUserLong()} //// ${StorageHelper().getSalesLat()} , ${StorageHelper().getSalesLng()} ");
//
//     _socket!.onConnect((_) {
//       print("Connected to Socket.IO ✅");
//
//       _socket!.emit("get-sales-lat-lng", {
//         "orderDetailId": StorageHelper().getUserOrderId(),
//       });
//     });
//
//     _socket!.on("get-updated-sales-lat-lng", (data) {
//       print("Raw Data Received: $data");
//
//       // Check if data is a Map before accessing values
//       if (data is Map<String, dynamic>) {
//         print("inside the if condition");
//         print("Sales Latitude: ${data['sales_lat']}");
//         print("Sales Longitude: ${data['sales_lng']}");
//         // Convert to double if necessary
//         double salesLat = double.tryParse(data['sales_lat'].toString()) ?? 0.0;
//         double salesLng = double.tryParse(data['sales_lng'].toString()) ?? 0.0;
//
//         updateMarkerSmoothly(LatLng(salesLat, salesLng));
//
//         print("Sales Lat: $salesLat, Sales Lng: $salesLng");
//         print("after getting data ");
//         // Store in StorageHelper
//         StorageHelper().setSalesLat(salesLat);
//         StorageHelper().setSalesLng(salesLng);
//         setState(() {
//           _salesPersonPosition = LatLng(salesLat, salesLng);
//         });
//         // Markers aur Polylines ko setState ke baad update karein
//         _updateMarkers();
//         _updatePolylines();
//         _moveCameraToSalesPerson();
//         print(
//             "Stored in StorageHelper: ${StorageHelper().getSalesLat()}, ${StorageHelper().getSalesLng()} /// ${StorageHelper().getUserLat()} , ${StorageHelper().getUserLong()}");
//       } else {
//         print("Error: Data is not in Map format -> $data");
//       }
//     });
//
//     _socket!.onDisconnect((_) {
//       print("Disconnected from Socket.IO ❌");
//       _reconnectSocket(); // ✅ Attempt Reconnection
//     });
//
//     _socket!.onError((error) {
//       print('Socket error ❌: $error');
//     });
//   }
//
//   void updateMarkerSmoothly(LatLng newPosition) {
//     final GoogleMapController controller = _mapController;
//     // ✅ Bearing calculate karein
//     double bearing = calculateBearing(_salesPersonPosition, newPosition);
//
//     // Camera ko naye position pe smoothly animate karo
//     controller.animateCamera(CameraUpdate.newLatLng(newPosition));
//
//     setState(() {
//       _markers.add(
//         Marker(
//           markerId: MarkerId('sales_person'),
//           position: newPosition,
//           icon: customIcon,
//           rotation: bearing,
//           // ✅ Rotation apply karein
//           anchor: Offset(0.5, 0.5), // ✅ Center se rotate hoga
//           // icon: BitmapDescriptor.defaultMarkerWithHue(
//           //   hasArrived ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueBlue,
//           // ),
//         ),
//       );
//     });
//   }
//
//   /// **2️⃣ Handle Socket Reconnection**
//   void _reconnectSocket() {
//     if (_socket != null && !_socket!.connected) {
//       print("Attempting to reconnect...");
//       _socket!.connect();
//     }
//   }
//
//   /// **3️⃣ Fetch Current Location (for salesperson)**
//   void _startLocationUpdates() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       print("Location services are disabled.");
//       return;
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.deniedForever) {
//         print("Location permissions are permanently denied.");
//         return;
//       }
//     }
//
//     Geolocator.getPositionStream(
//       locationSettings:
//       LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 5),
//     ).listen((Position position) {
//       double latitude = position.latitude;
//       double longitude = position.longitude;
//
//       if (mounted) {
//         setState(() {
//           _salesPersonPosition = LatLng(position.latitude, position.longitude);
//         });
//         _updateMarkers(); // ✅ Marker update here
//         _updatePolylines();
//       }
//
//       /// **4️⃣ Send Salesperson's Updated Location to Backend**
//       // _socket!.emit("change-track-path", {
//       //   "orderDetailId": StorageHelper().getUserOrderId(),
//       // });
//     });
//   }
//
//   /// **3️⃣ Update Markers on Map**
//   void _updateMarkers() {
//     setState(() {
//       _markers.clear();
//       _markers.add(
//         Marker(
//           markerId: MarkerId('sales_person'),
//           position: _salesPersonPosition,
//           rotation: bearing, // ✅ Rotation apply karein
//           icon: customIcon,
//           // icon: BitmapDescriptor.defaultMarkerWithHue(
//           //   hasArrived ? BitmapDescriptor.hueGreen : BitmapDescriptor.hueBlue,
//           // ),
//         ),
//       );
//       _markers.add(
//         Marker(
//           markerId: MarkerId('user'),
//           position: _userPosition,
//           icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         ),
//       );
//     });
//   }
//
//   /// **5️⃣ Update Route Polyline**
//   // void _updatePolylines() {
//   //   setState(() {
//   //     _polylines.clear();
//   //     _polylines.add(
//   //       Polyline(
//   //         polylineId: PolylineId("route"),
//   //         color: Colors.blue,
//   //         width: 5,
//   //         points: [_salesPersonPosition, _userPosition],
//   //       ),
//   //     );
//   //   });
//   // }
//
//   /// **🛣 Fetch Road Polyline Route**
//   void _updatePolylines() async {
//     List<LatLng> routeCoordinates =
//     await getRouteCoordinates(_salesPersonPosition, _userPosition);
//
//     setState(() {
//       _polylines.clear();
//       if (routeCoordinates.isNotEmpty) {
//         _polylines.add(
//           Polyline(
//             polylineId: PolylineId("route"),
//             color: Colors.blue,
//             width: 5,
//             points: routeCoordinates,
//           ),
//         );
//       }
//     });
//   }
//
//   Future<List<LatLng>> getRouteCoordinates(
//       LatLng source, LatLng destination) async {
//     const String googleAPIKey =
//         "AIzaSyC9ZOZHwHmyTWXqACqpZY2TL7wX2_Zn05U"; // 🔹 API Key add karein
//
//     String url =
//         "https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleAPIKey&mode=driving";
//
//     try {
//       var response = await Dio().get(url);
//       Map values = response.data;
//       if (values['status'] == 'OK') {
//         List<LatLng> routePoints = [];
//         var steps = values['routes'][0]['legs'][0]['steps'];
//
//         for (var step in steps) {
//           // double lat = step['end_location']['lat'];
//           // double lng = step['end_location']['lng'];
//           // routePoints.add(LatLng(lat, lng));
//           double startLat = step['start_location']['lat'];
//           double startLng = step['start_location']['lng'];
//           double endLat = step['end_location']['lat'];
//           double endLng = step['end_location']['lng'];
//
//           routePoints.add(LatLng(startLat, startLng)); // ✅ Include start point
//           routePoints.add(LatLng(endLat, endLng)); // ✅ Include end point
//         }
//         return routePoints;
//       } else {
//         print("Google Directions API Error: ${values['status']}");
//         return [];
//       }
//     } catch (e) {
//       print("Error fetching route: $e");
//       return [];
//     }
//   }
//
//   /// **🔹 Move Camera to Salesperson's Location**
//   void _moveCameraToSalesPerson() {
//     if (_mapController != null) {
//       _mapController.animateCamera(
//         CameraUpdate.newLatLng(_salesPersonPosition),
//       );
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<SocketProvider>(
//       builder: (context, socketProvider, child) {
//         LatLng salesPersonPosition = socketProvider.salesPersonPosition;
//
//         if (salesPersonPosition.latitude != 0 && salesPersonPosition.longitude != 0) {
//           updateMarkerSmoothly(salesPersonPosition);
//         }
//
//         return   Scaffold(
//           appBar: AppBar(title: Text('Live Tracking')),
//           body: Stack(
//             children: [
//               GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: _salesPersonPosition,
//                   zoom: 15,
//                 ),
//                 onMapCreated: (GoogleMapController controller) {
//                   _mapController = controller;
//                   _updateMarkers(); // ✅ Ensure markers are set after map creation
//                   _updatePolylines();
//                 },
//                 markers: _markers, // ✅ Use updated markers
//                 polylines: _polylines,
//               ),
//
//               // Bottom Status Box
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   padding: EdgeInsets.all(16),
//                   margin: EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         hasArrived
//                             ? "Salesperson has reached the destination!"
//                             : "Salesperson is on the way...",
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: Colors.blueAccent,
//                             child: Icon(Icons.person, color: Colors.white),
//                           ),
//                           SizedBox(width: 10),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(salesPersonName,
//                                   style: TextStyle(
//                                       fontSize: 16, fontWeight: FontWeight.w600)),
//                               Text(salesPersonPhone,
//                                   style: TextStyle(
//                                       fontSize: 14, color: Colors.grey[700])),
//                             ],
//                           ),
//                         ],
//                       ),
//                       SizedBox(height: 10),
//                       if (!hasArrived)
//                         LinearProgressIndicator(
//                             color: Colors.blue, backgroundColor: Colors.grey[300]),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
