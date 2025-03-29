import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../network_manager/repository.dart';
import '../../ui_helper/storage_helper.dart';

class SocketProvider with ChangeNotifier {
  IO.Socket? _socket;
  bool isConnected = false;
  LatLng _salesPersonPosition = LatLng(0.0, 0.0);

  LatLng get salesPersonPosition => _salesPersonPosition;

  SocketProvider() {
    _connectToSocket();
  }

  void _connectToSocket() {
    _socket = IO.io(Repository.baseUrl, <String, dynamic>{
      "transports": ["websocket"],
      'autoConnect': true,
      'reconnection': true,
      'reconnectionAttempts': 5,
      'reconnectionDelay': 2000,
    });

    _socket!.onConnect((_) {
      print("Connected to Socket.IO ✅");
      isConnected = true;
      notifyListeners();  // Notify UI that socket is connected

      _socket!.emit("get-sales-lat-lng", {
        "orderDetailId": StorageHelper().getUserOrderId(),
      });
    });

    _socket!.on("get-updated-sales-lat-lng", (data) {
      print("Raw Data Received: $data");

      if (data is Map<String, dynamic>) {
        double salesLat = double.tryParse(data['sales_lat'].toString()) ?? 0.0;
        double salesLng = double.tryParse(data['sales_lng'].toString()) ?? 0.0;

        _salesPersonPosition = LatLng(salesLat, salesLng);
        StorageHelper().setSalesLat(salesLat);
        StorageHelper().setSalesLng(salesLng);

        print("Updated Sales Person Location: $_salesPersonPosition");

        notifyListeners(); // Notify UI to update the map
      } else {
        print("Error: Data is not in Map format -> $data");
      }
    });

    _socket!.onDisconnect((_) {
      print("Disconnected from Socket.IO ❌");
      isConnected = false;
      notifyListeners();
      _reconnectSocket(); // Try reconnecting
    });

    _socket!.onError((error) {
      print('Socket error ❌: $error');
    });
  }



  void _reconnectSocket() {
    if (_socket != null && !_socket!.connected) {
      print("Reconnecting...");
      _socket!.connect();
    }
  }

  void disposeSocket() {
    _socket?.dispose();
    print("Socket disconnected permanently.");
  }
}
