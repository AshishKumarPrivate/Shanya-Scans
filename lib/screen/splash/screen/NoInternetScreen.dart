import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/splash/controller/network_provider_controller.dart';
import 'package:provider/provider.dart';
import 'package:shanya_scans/util/image_loader_util.dart';

import '../SplashScreen.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access the network connection status from the provider
    bool isConnected = Provider.of<NetworkProvider>(context).isConnected;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageLoaderUtil.assetImage("assets/images/no_internet.png", width: 250), // Show No Internet Image
          SizedBox(height: 20),
          Text(
            "No Internet Connection!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text("Please check your network and try again."),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              // Refresh network connection status
              await Provider.of<NetworkProvider>(context, listen: false).checkConnection(context);

              // After checking, update the UI based on the new connection status
              bool updatedConnectionStatus = Provider.of<NetworkProvider>(context, listen: false).isConnected;

              if (updatedConnectionStatus) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SplashScreen()));
              } else {
                // Optionally, show a dialog or some message if still not connected
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("No internet connection. Please try again.")),
                );
              }
            },
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }
}
