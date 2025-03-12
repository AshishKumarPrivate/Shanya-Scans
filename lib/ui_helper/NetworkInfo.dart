import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screen/splash/controller/network_provider_controller.dart';
class NetworkInfo {
  static void checkConnectivity(BuildContext context) {
    final networkProvider = Provider.of<NetworkProvider>(context, listen: false);

    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      bool isNotConnected = results.isEmpty || results.every((result) => result == ConnectivityResult.none);

      WidgetsBinding.instance.addPostFrameCallback((_) {
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
      });
    });
  }
}
