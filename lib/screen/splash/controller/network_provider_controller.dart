import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class NetworkProvider with ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  // Constructor doesn't start connectivity check anymore
  NetworkProvider();

  // Method to manually check the network status
  Future<void> checkConnection(BuildContext context) async {
    // Check the current connectivity status
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    bool isNotConnected = result == ConnectivityResult.none;
    _isConnected = !isNotConnected;
    notifyListeners();  // Notify listeners to update the UI

    // Show the network status via Snackbar after checking
    _showNetworkStatusSnackBar(context, isNotConnected);
  }

  // Method to listen for connectivity changes and show the snackbar
  void _showNetworkStatusSnackBar(BuildContext context, bool isNotConnected) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isNotConnected ? Colors.red : Colors.green,
        duration: Duration(seconds: isNotConnected ? 6 : 3),
        content: Text(
          isNotConnected ? "No internet connection" : "Connected",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
