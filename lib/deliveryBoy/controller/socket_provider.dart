import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../network_manager/repository.dart';
import '../../ui_helper/storage_helper.dart';

class SocketProvider with ChangeNotifier {
  IO.Socket? _socket;
  bool _isConnected  = false;
  LatLng _salesPersonPosition;
  bool get isConnected => _isConnected;
  LatLng get salesPersonPosition => _salesPersonPosition;

  SocketProvider() : _salesPersonPosition = LatLng(StorageHelper().getSalesLat(), StorageHelper().getSalesLng()) {
    _connectToSocket();
  }
  void listenToSalesPersonLocation(String orderId) {
    // if (isConnected) {
    //   _socket?.emit("get-sales-lat-lng", {
    //     "orderDetailId": orderId,
    //   });

      if (_socket?.connected == true) { // Check if socket is connected before emitting
        print("Emitting get-sales-lat-lng for order: $orderId");
        _socket?.emit("get-sales-lat-lng", {
          "orderDetailId": orderId,
        });
    } else {
      print("Socket not connected yet, cannot emit event.");
      _connectToSocket();
    }
  }


  void _connectToSocket() {
    // Only connect if not already connected or connecting
    if (_socket?.connected == true) {
      print("Socket already connected or connecting. Skipping new connection.");
      return;
    }
    _socket = IO.io(Repository.baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      'autoConnect': true,
      'reconnection': true,
      'reconnectionAttempts': 5,
      'reconnectionDelay': 2000,
      'forceNew': false,
    });

    _socket!.onConnect((_) {
      print("Connected to Socket.IO ✅");
      _isConnected  = true;
      notifyListeners();  // Notify UI that socket is connected

      // _socket?.emit("get-sales-lat-lng", {
      //   "orderDetailId": StorageHelper().getUserOrderId(),
      // });
    });

    _socket!.on("get-updated-sales-lat-lng", (data) {
      print("Raw Data Received: $data");

      if (data is Map<String, dynamic>) {
        double salesLat = double.tryParse(data['sales_lat'].toString()) ?? 0.0;
        double salesLng = double.tryParse(data['sales_lng'].toString()) ?? 0.0;

        // _salesPersonPosition = LatLng(salesLat, salesLng);
        //
        // StorageHelper().setSalesLat(salesLat);
        // StorageHelper().setSalesLng(salesLng);
        // notifyListeners(); // Notify UI to update the map
        //
        // print("Updated Sales Person Location: $_salesPersonPosition");

        // Only update and notify if the position has actually changed significantly
        const double epsilon = 0.000001;
        if ((_salesPersonPosition.latitude - salesLat).abs() > epsilon ||
            (_salesPersonPosition.longitude - salesLng).abs() > epsilon) {
          _salesPersonPosition = LatLng(salesLat, salesLng);
          StorageHelper().setSalesLat(salesLat); // Store last known position
          StorageHelper().setSalesLng(salesLng);
          notifyListeners(); // Notify UI to update the map
          print("Updated Sales Person Location: $_salesPersonPosition");
        } else {
          print("Sales Person Location unchanged, not notifying.");
        }

      } else {
        print("Error: Data is not in Map format -> $data");
      }
    });

    _socket!.onDisconnect((_) {
      print("Disconnected from Socket.IO ❌");
      _isConnected  = false;
      notifyListeners();
      _reconnectSocket(); // Try reconnecting
    });

    _socket!.onError((error) {
      print('Socket error ❌: $error');
      _isConnected = false; // Set disconnected on error as well
      notifyListeners();
    });

    _socket!.connect(); // Explicitly connect
  }



  void _reconnectSocket() {
    if (_socket != null && !_socket!.connected) {
      print("Reconnecting...");
      _socket!.connect();
    }
  }

  void disposeSocket() {
    _socket?.disconnect(); // Disconnect cleanly
    _socket?.dispose();    // Dispose resources
    _isConnected = false;
    print("Socket disconnected permanently.");
  }
}
