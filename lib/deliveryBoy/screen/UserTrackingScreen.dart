import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// class UserTrackingScreen extends StatefulWidget {
//   const UserTrackingScreen({Key? key}) : super(key: key);
//
//   @override
//   _UserTrackingScreenState createState() => _UserTrackingScreenState();
// }
//
// class _UserTrackingScreenState extends State<UserTrackingScreen> {
//   late GoogleMapController _mapController;
//
//   final Completer<GoogleMapController> _controller = Completer();
//   static const LatLng  sourceLocaiton  = LatLng(28.7041, 77.1025);
//   static const LatLng  destinationLocaiton  = LatLng(28.7041, 77.1025);
//
//   int _index = 0;
//   List<LatLng> polylineCoordinates = [];
//   Set<Polyline> _polylines = {};
//
//
//   Future<void> getPolyPoints(LatLng sourceLocation, LatLng destination) async {
//     PolylinePoints polylinePoints = PolylinePoints();
//
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       "YOUR_GOOGLE_MAPS_API_KEY", // Replace with your actual API key
//       PointLatLng(sourceLocation.latitude, sourceLocation.longitude),
//       PointLatLng(destination.latitude, destination.longitude),
//     );
//
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point )=>polylineCoordinates.add(LatLng(point.latitude, point.longitude)));
//     }
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     getPolyPoints(sourceLocaiton, destinationLocaiton)
//     super.initState();
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Track Sales Person")),
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(target: sourceLocaiton, zoom: 16),
//             onMapCreated: (controller) => _mapController = controller,
//             polygons: ,
//             markers: {
//               Marker(
//                 markerId: const MarkerId("source"),
//                 position: sourceLocaiton,
//                 icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//               ),
//               Marker(
//                 markerId: const MarkerId("destination"),
//                 position: destinationLocaiton,
//                 icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//               ),
//             },
//             polylines: _polylines,
//           ),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: ElevatedButton(
//               onPressed: _isTracking ? stopTracking : startMockTracking,
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.all(16),
//                 backgroundColor: _isTracking ? Colors.red : Colors.blue,
//               ),
//               child: Text(
//                 _isTracking ? "Stop Tracking" : "Start Tracking",
//                 style: const TextStyle(fontSize: 18, color: Colors.white),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//

















// import 'dart:async';


// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:socket_io_client/socket_io_client.dart' as IO;
//
// class UserTrackingScreen extends StatefulWidget {
//   final String salesPersonId;
//   const UserTrackingScreen({required this.salesPersonId, Key? key}) : super(key: key);
//
//   @override
//   _UserTrackingScreenState createState() => _UserTrackingScreenState();
// }
//
// class _UserTrackingScreenState extends State<UserTrackingScreen> {
//   late GoogleMapController _mapController;
//   IO.Socket? socket;
//   LatLng? salesPersonLocation;
//
//   @override
//   void initState() {
//     super.initState();
//     initializeSocket();
//   }
//
//   void initializeSocket() {
//     socket = IO.io('https://your-server.com', IO.OptionBuilder()
//         .setTransports(['websocket'])
//         .disableAutoConnect()
//         .build());
//
//     socket!.connect();
//     socket!.onConnect((_) {
//       print("Connected to server for tracking");
//     });
//
//     socket!.on('sales_person_location', (data) {
//       setState(() {
//         salesPersonLocation = LatLng(data['latitude'], data['longitude']);
//       });
//
//       if (_mapController != null) {
//         _mapController.animateCamera(CameraUpdate.newLatLng(salesPersonLocation!));
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Track Sales Person")),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(target: LatLng(28.7041, 77.1025), zoom: 12),
//         onMapCreated: (controller) => _mapController = controller,
//         markers: salesPersonLocation != null
//             ? {
//           Marker(
//             markerId: const MarkerId("salesPerson"),
//             position: salesPersonLocation!,
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//           )
//         }
//             : {},
//       ),
//     );
//   }
// }
