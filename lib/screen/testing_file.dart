
class MyOrderHistoryListModel {
  bool? success;
  String? message;
  Data? data;

  MyOrderHistoryListModel({this.success, this.message, this.data});

  MyOrderHistoryListModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? name;
  String? email;
  String? verificationCode;
  bool? isVerified;
  String? password;
  List<dynamic>? member;
  int? iV;
  String? age;
  List<OrderDetails>? orderDetails;
  String? phoneNumber;
  String? token;
  String? whatsappNumber;

  Data(
      {this.sId,
        this.name,
        this.email,
        this.verificationCode,
        this.isVerified,
        this.password,
        this.member,
        this.iV,
        this.age,
        this.orderDetails,
        this.phoneNumber,
        this.token,
        this.whatsappNumber});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    email = json['email'];
    verificationCode = json['verificationCode'];
    isVerified = json['isVerified'];
    password = json['password'];
    member = json['member'] ?? []; // FIXED: Handle null lists
    // if (json['member'] != null) {
    //   member = <Null>[];
    //   json['member'].forEach((v) {
    //     member!.add(new fromJson(v));
    //   });
    // }
    iV = json['__v'];
    age = json['age'];
    if (json['orderDetails'] != null) {
      orderDetails = <OrderDetails>[];
      json['orderDetails'].forEach((v) {
        orderDetails!.add(new OrderDetails.fromJson(v));
      });
    }
    phoneNumber = json['phoneNumber'];
    token = json['token'];
    whatsappNumber = json['whatsappNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['verificationCode'] = this.verificationCode;
    data['isVerified'] = this.isVerified;
    data['password'] = this.password;
    if (this.member != null) {
      data['member'] = this.member!.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
    data['age'] = this.age;
    if (this.orderDetails != null) {
      data['orderDetails'] = this.orderDetails!.map((v) => v.toJson()).toList();
    }
    data['phoneNumber'] = this.phoneNumber;
    data['token'] = this.token;
    data['whatsappNumber'] = this.whatsappNumber;
    return data;
  }
}

class OrderDetails {
  String? sId;
  String? orderName;
  String? phone;
  String? altPhone;
  String? address;
  String? name;
  String? category;
  String? price;
  String? bod;
  String? bot;
  String? createdAt;
  String? updatedAt;
  String? status; // ✅ Manually added field
  int? iV;

  OrderDetails(
      {this.sId,
        this.orderName,
        this.phone,
        this.altPhone,
        this.address,
        this.name,
        this.category,
        this.price,
        this.bod,
        this.bot,
        this.createdAt,
        this.updatedAt,
        this.status = "Pending", // ✅ Default value if status is missing
        this.iV});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    orderName = json['orderName'];
    phone = json['phone'];
    altPhone = json['altPhone'];
    address = json['address'];
    name = json['name'];
    category = json['category'];
    price = json['price'];
    bod = json['bod'];
    bot = json['bot'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    status = json.containsKey('status') ? json['status'] : "Pending"; // ✅ Set status if available, else "Pending"
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['orderName'] = this.orderName;
    data['phone'] = this.phone;
    data['altPhone'] = this.altPhone;
    data['address'] = this.address;
    data['name'] = this.name;
    data['category'] = this.category;
    data['price'] = this.price;
    data['bod'] = this.bod;
    data['bot'] = this.bot;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['status'] = status; // ✅ Include manually added status field
    data['__v'] = this.iV;
    return data;
  }
}



























// import 'dart:async';







// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
//
// class LiveTrackingScreen extends StatefulWidget {
//   @override
//   _LiveTrackingScreenState createState() => _LiveTrackingScreenState();
// }
//
// class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
//   late GoogleMapController _mapController;
//   LatLng _salesPersonPosition = LatLng(28.6139, 77.2090); // Start Position (New Delhi)
//   LatLng _userPosition = LatLng(28.6200, 77.2100); // Static User Position
//   Set<Polyline> _polylines = {};
//   Timer? _timer;
//
//   @override
//   void initState() {
//     super.initState();
//     _startSimulatedLocationUpdates();
//   }
//
//   void _startSimulatedLocationUpdates() {
//     _timer = Timer.periodic(Duration(seconds: 5), (timer) {
//       setState(() {
//         _salesPersonPosition = LatLng(
//           _salesPersonPosition.latitude + 0.0005, // Simulate movement
//           _salesPersonPosition.longitude + 0.0005,
//         );
//         _updatePolylines();
//       });
//     });
//   }
//
//   void _updatePolylines() {
//     setState(() {
//       _polylines.clear();
//       _polylines.add(
//         Polyline(
//           polylineId: PolylineId("route"),
//           color: Colors.blue,
//           width: 5,
//           points: [_salesPersonPosition, _userPosition],
//         ),
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Live Tracking (Static)')),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: _salesPersonPosition,
//           zoom: 15,
//         ),
//         onMapCreated: (GoogleMapController controller) {
//           _mapController = controller;
//         },
//         markers: {
//           Marker(
//             markerId: MarkerId('sales_person'),
//             position: _salesPersonPosition,
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//           ),
//           Marker(
//             markerId: MarkerId('user'),
//             position: _userPosition,
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//           ),
//         },
//         polylines: _polylines,
//       ),
//     );
//   }
// }
