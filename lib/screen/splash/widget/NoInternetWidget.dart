import 'package:flutter/material.dart';
import 'package:healthians/bottom_navigation_screen.dart';
import 'package:healthians/screen/splash/SplashScreen.dart';
import 'package:provider/provider.dart';
import '../controller/network_provider_controller.dart';

class NoInternetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<NetworkProvider>(
      builder: (context, networkProvider, child) {
        if (networkProvider.isConnected) {
          return SizedBox(); // Hide if internet is available
        }
        return Container(
          width: double.infinity,
          color: Colors.red,
          padding: EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 250), // Show No Internet Image
              // Image.asset("assets/images/no_internet.png", width: 250), // Show No Internet Image
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
      },
    );
  }
}
