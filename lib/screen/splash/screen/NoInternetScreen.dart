import 'package:flutter/material.dart';
import 'package:healthians/screen/splash/controller/network_provider_controller.dart';
import 'package:provider/provider.dart';

import '../SplashScreen.dart';

class NoInternetScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/no_internet.png", width: 250), // Show No Internet Image
          SizedBox(height: 20),
          Text(
            "No Internet Connection!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text("Please check your network and try again."),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              bool isConnected = Provider.of<NetworkProvider>(context, listen: false).isConnected;
              if (isConnected) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SplashScreen()));
              }
            },
            child: Text("Retry"),
          ),
        ],
      ),
    );
  }
}
