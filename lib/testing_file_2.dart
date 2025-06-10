// import 'dart:async';
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:provider/provider.dart';
// import 'package:shanya_scans/ui_helper/storage_helper.dart';
// import 'package:flutter/services.dart' show rootBundle;
// import 'dart:typed_data';
// import 'dart:ui' as ui;
// import 'dart:math' as math;
//
// import 'package:shanya_scans/ui_helper/app_colors.dart';
// import '../controller/socket_provider.dart';
//
// class UserLiveTrackingScreen extends StatefulWidget {
//   final String? salesPersonName,patientName ;
//   const UserLiveTrackingScreen({super.key, this.salesPersonName, this.patientName});
//
//   @override
//   State<UserLiveTrackingScreen> createState() => _UserLiveTrackingScreenState();
// }
//
// class _UserLiveTrackingScreenState extends State<UserLiveTrackingScreen> {
//   late GoogleMapController _mapController;
//
//   LatLng _salesPersonPosition =  LatLng(StorageHelper().getSalesLat(), StorageHelper().getSalesLng()); // Start point for salesperson
//   LatLng _userPosition =  LatLng(StorageHelper().getUserLat(), StorageHelper().getUserLong()); // Destination for user
//
//   // LatLng _salesPersonPosition = const LatLng(26.7793, 80.9043); // Start point for salesperson
//   // LatLng _userPosition = const LatLng(26.8500, 80.9500); // Destination for user
//
//   Set<Polyline> _polylines = {};
//   Set<Marker> _markers = {};
//   bool hasArrived = false;
//   double bearing = 0.0;
//
//   String salesPersonDisplayName = "Sales Person";
//   String salesPersonPhone = "Not Available";
//
//   BitmapDescriptor customSalesPersonIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
//   BitmapDescriptor defaultSalesPersonIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
//
//   late Timer? _locationUpdateTimer;
//
//   // New: Store the decoded polyline points
//   List<LatLng> _routePoints = [];
//   int _currentPolylineIndex = 0; // Tracks which point on the polyline the salesperson is moving towards
//
//   @override
//   void initState() {
//     super.initState();
//
//     _loadCustomMarker();
//
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Listener for real-time updates (if using sockets, currently commented)
//       // Provider.of<SocketProvider>(context, listen: false)
//       //     .listenToSalesPersonLocation(StorageHelper().getUserOrderId());
//     });
//   }
//
//   @override
//   void dispose() {
//     _locationUpdateTimer?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _loadCustomMarker() async {
//     try {
//       String? name = await StorageHelper().getDeliveryBoyName();
//       if (name != null) {
//         salesPersonDisplayName = name;
//       }
//
//       final Uint8List markerIconBytes =
//       await _getBytesFromAsset('assets/images/sales_marker.png', 100);
//       setState(() {
//         customSalesPersonIcon = BitmapDescriptor.fromBytes(markerIconBytes);
//         _updateMarkers();
//       });
//     } catch (e) {
//       print("Error loading custom marker: $e");
//     }
//   }
//
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
//   double _calculateBearing(LatLng start, LatLng end) {
//     double lat1 = start.latitude * (math.pi / 180);
//     double lat2 = end.latitude * (math.pi / 180);
//     double longDiff = (end.longitude - start.longitude) * (math.pi / 180);
//
//     double x = math.sin(longDiff) * math.cos(lat2);
//     double y = math.cos(lat1) * math.sin(lat2) -
//         math.sin(lat1) * math.cos(lat2) * math.cos(longDiff);
//
//     double calculatedBearing = math.atan2(x, y) * (180 / math.pi);
//     return (calculatedBearing + 360) % 360;
//   }
//
//   void updateMarkerSmoothly(LatLng newPosition) {
//     // Only update bearing if the position actually changes.
//     // This helps avoid jitter if the simulation causes no movement in a step.
//     if (newPosition.latitude != _salesPersonPosition.latitude ||
//         newPosition.longitude != _salesPersonPosition.longitude) {
//       double newBearing = _calculateBearing(_salesPersonPosition, newPosition);
//       setState(() {
//         bearing = newBearing;
//       });
//     }
//
//     setState(() {
//       _salesPersonPosition = newPosition;
//       _updateMarkers(); // Update markers to reflect new position and bearing
//     });
//
//     _mapController.animateCamera(CameraUpdate.newLatLng(_salesPersonPosition));
//   }
//
//   void _updateMarkers() {
//     _markers.clear();
//
//     _markers.add(
//       Marker(
//         markerId: const MarkerId('sales_person'),
//         position: _salesPersonPosition,
//         rotation: bearing,
//         icon: customSalesPersonIcon,
//         anchor: const Offset(0.5, 0.5),
//         infoWindow: InfoWindow(
//           title: salesPersonDisplayName,
//           snippet: salesPersonPhone,
//         ),
//       ),
//     );
//
//     _markers.add(
//       Marker(
//         markerId: const MarkerId('user_location'),
//         position: _userPosition,
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//         infoWindow: const InfoWindow(title: 'Your Destination'),
//       ),
//     );
//   }
//
//   Future<void> _updatePolylines() async {
//     if (_salesPersonPosition.latitude == 0.0 && _salesPersonPosition.longitude == 0.0 ||
//         _userPosition.latitude == 0.0 && _userPosition.longitude == 0.0) {
//       print("Cannot draw polyline: Salesperson or user location not set properly.");
//       return;
//     }
//
//     _routePoints = await getRouteCoordinates(_salesPersonPosition, _userPosition);
//
//     // Initial polyline draw.  Subsequent updates happen in _startLocationSimulation
//     _drawRemainingPolyline();
//   }
//
//   // New method: Draws the polyline from the current marker position
//   // to the destination, using the remaining points in _routePoints.
//   void _drawRemainingPolyline() {
//     List<LatLng> remainingPoints = [];
//     if (_routePoints.isNotEmpty && _currentPolylineIndex < _routePoints.length) {
//       remainingPoints = _routePoints.sublist(_currentPolylineIndex);
//     }
//     setState(() {
//       _polylines.clear(); // Clear the old polyline
//       if (remainingPoints.isNotEmpty) {
//         _polylines.add(
//           Polyline(
//             polylineId: const PolylineId("route"),
//             color: AppColors.primary,
//             width: 5,
//             points: remainingPoints, // Draw only the remaining segment
//             jointType: JointType.round,
//             startCap: Cap.roundCap,
//             endCap: Cap.roundCap,
//           ),
//         );
//       }
//     });
//   }
//
//   Future<List<LatLng>> getRouteCoordinates(
//       LatLng source, LatLng destination) async {
//     // Note: It's best practice to secure your API key, e.g., in environment variables.
//     const String googleAPIKey = "AIzaSyC9ZOZHwHmyTWXqACqpZY2TL7wX2_Zn05U"; // <--- REPLACE THIS WITH YOUR KEY!
//
//     String url =
//         "https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleAPIKey&mode=driving";
//
//     try {
//       var response = await Dio().get(url);
//       Map values = response.data;
//       if (values['status'] == 'OK') {
//         String encodedPolyline = values['routes'][0]['overview_polyline']['points'];
//         List<PointLatLng> decodedPoints = decodePolyline(encodedPolyline);
//         return decodedPoints.map((p) => LatLng(p.latitude, p.longitude)).toList();
//       } else {
//         print("Google Directions API Error: ${values['status']}");
//         if (values['error_message'] != null) {
//           print("Error Message: ${values['error_message']}");
//         }
//         return [];
//       }
//     } catch (e) {
//       print("Error fetching route: $e");
//       return [];
//     }
//   }
//
//   List<PointLatLng> decodePolyline(String encoded) {
//     List<PointLatLng> poly = [];
//     int index = 0, len = encoded.length;
//     int lat = 0, lng = 0;
//
//     while (index < len) {
//       int b, shift = 0, result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lat += dlat;
//
//       shift = 0;
//       result = 0;
//       do {
//         b = encoded.codeUnitAt(index++) - 63;
//         result |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
//       lng += dlng;
//
//       poly.add(PointLatLng(lat / 1E5, lng / 1E5));
//     }
//     return poly;
//   }
//
//   void _startLocationSimulation() {
//     print("Starting location simulation...");
//     _locationUpdateTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) async {
//       if (_routePoints.isEmpty || _currentPolylineIndex >= _routePoints.length) {
//         // If no route points or reached end of route, stop simulation
//         if (!hasArrived) {
//           setState(() {
//             hasArrived = true;
//           });
//           print("Salesperson has arrived at the destination! Simulation stopped.");
//         }
//         _locationUpdateTimer?.cancel();
//         return;
//       }
//
//       // Target the next point on the polyline
//       LatLng targetPoint = _routePoints[_currentPolylineIndex];
//
//       double distanceToTarget = Geolocator.distanceBetween(
//         _salesPersonPosition.latitude,
//         _salesPersonPosition.longitude,
//         targetPoint.latitude,
//         targetPoint.longitude,
//       );
//
//       // A small threshold to consider "arrived" at a polyline point
//       double threshold = 5.0; // meters
//
//       if (distanceToTarget < threshold) {
//         // Move to the next point on the polyline
//         _currentPolylineIndex++;
//         if (_currentPolylineIndex < _routePoints.length) {
//           targetPoint = _routePoints[_currentPolylineIndex];
//         } else {
//           // Reached the end of the polyline
//           if (!hasArrived) {
//             setState(() {
//               hasArrived = true;
//             });
//             print("Salesperson has arrived at the destination! Simulation stopped.");
//           }
//           _locationUpdateTimer?.cancel();
//           return;
//         }
//       }
//
//       // Calculate movement towards the current target point on the polyline
//       double moveStep = 0.00005; // Adjust this value for speed along the path
//
//       double latDiff = targetPoint.latitude - _salesPersonPosition.latitude;
//       double lngDiff = targetPoint.longitude - _salesPersonPosition.longitude;
//
//       double angle = math.atan2(lngDiff, latDiff);
//       double moveAmountLat = math.cos(angle) * moveStep;
//       double moveAmountLng = math.sin(angle) * moveStep;
//
//       // Add a small random jitter (optional, for more natural movement)
//       moveAmountLat += (math.Random().nextDouble() - 0.5) * 0.000002;
//       moveAmountLng += (math.Random().nextDouble() - 0.5) * 0.000002;
//
//       LatLng newSalesPersonPosition = LatLng(
//         _salesPersonPosition.latitude + moveAmountLat,
//         _salesPersonPosition.longitude + moveAmountLng,
//       );
//
//       // Ensure we don't overshoot the target point significantly in one step
//       double newDistanceToTarget = Geolocator.distanceBetween(
//         newSalesPersonPosition.latitude,
//         newSalesPersonPosition.longitude,
//         targetPoint.latitude,
//         targetPoint.longitude,
//       );
//
//       if (newDistanceToTarget > distanceToTarget) {
//         // If we overshot, just snap to the target point
//         newSalesPersonPosition = targetPoint;
//       }
//
//       print("Simulating move to: $newSalesPersonPosition, Distance to next polyline point: $distanceToTarget m");
//
//       updateMarkerSmoothly(newSalesPersonPosition);
//       _drawRemainingPolyline(); // Redraw the polyline with only remaining points
//     });
//   }
//
//   void _animateCameraToBounds() {
//     if (_salesPersonPosition.latitude == 0.0 && _salesPersonPosition.longitude == 0.0 ||
//         _userPosition.latitude == 0.0 && _userPosition.longitude == 0.0) {
//       return;
//     }
//
//     double minLat = math.min(_salesPersonPosition.latitude, _userPosition.latitude);
//     double maxLat = math.max(_salesPersonPosition.latitude, _userPosition.latitude);
//     double minLng = math.min(_salesPersonPosition.longitude, _userPosition.longitude);
//     double maxLng = math.max(_salesPersonPosition.longitude, _userPosition.longitude);
//
//     LatLngBounds bounds = LatLngBounds(
//       southwest: LatLng(minLat, minLng),
//       northeast: LatLng(maxLat, maxLng),
//     );
//
//     _mapController.animateCamera(CameraUpdate.newLatLngBounds(bounds, 100));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Consumer<SocketProvider>(
//       builder: (context, socketProvider, child) {
//         return Scaffold(
//           appBar: AppBar(
//             backgroundColor: AppColors.primary,
//             elevation: 0,
//             leading: IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.white),
//               onPressed: () => Navigator.of(context).pop(),
//             ),
//             title: const Text(
//               "Track Sales Person",
//               style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//             ),
//             centerTitle: true,
//           ),
//           body: Stack(
//             children: [
//               GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: _salesPersonPosition,
//                   zoom: 15,
//                 ),
//                 onMapCreated: (GoogleMapController controller) async {
//                   _mapController = controller;
//                   _updateMarkers(); // Initial markers
//                   await _updatePolylines(); // Get route points and draw initial polyline
//                   _animateCameraToBounds(); // Fit map to route
//                   _startLocationSimulation(); // Start simulation along the route
//                 },
//                 markers: _markers,
//                 polylines: _polylines,
//                 rotateGesturesEnabled: true,
//                 compassEnabled: true,
//               ),
//
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   margin: const EdgeInsets.all(12),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 5)],
//                   ),
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         hasArrived
//                             ? "Salesperson has reached your location!"
//                             : "Salesperson is on the way...",
//                         style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 8),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           CircleAvatar(
//                             backgroundColor: AppColors.primary,
//                             child: const Icon(Icons.person, color: Colors.white),
//                           ),
//                           const SizedBox(width: 10),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(salesPersonPhone,
//                                   style: const TextStyle(
//                                       fontSize: 16, fontWeight: FontWeight.w600)),
//                               Text(widget.salesPersonName ?? salesPersonDisplayName,
//                                   style: TextStyle(
//                                       fontSize: 14, color: Colors.grey[700])),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 10),
//                       if (!hasArrived)
//                         LinearProgressIndicator(
//                             color: AppColors.primary, backgroundColor: Colors.grey[300]),
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
//
// class PointLatLng {
//   final double latitude;
//   final double longitude;
//   const PointLatLng(this.latitude, this.longitude);
// }