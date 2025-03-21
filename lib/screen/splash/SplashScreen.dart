
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthians/deliveryBoy/screen/deleivery_boy_dashboard.dart';
import 'package:healthians/screen/other/screen/user_selection_screen.dart';
import 'package:healthians/screen/splash/screen/NoInternetScreen.dart';
import 'package:provider/provider.dart';

import '../../bottom_navigation_screen.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/responsive_helper.dart';
import '../../ui_helper/storage_helper.dart';
import '../auth/login_screen.dart';
import '../cart/controller/cart_list_api_provider.dart';
import 'controller/network_provider_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }
  void _checkConnectivity() {
    Future.delayed(Duration(seconds: 3), () {
      bool isConnected = Provider.of<NetworkProvider>(context, listen: false).isConnected;
      if (isConnected) {

        ///&&&&&&&&&&&&& Delivery boy login &&&&&&&&&&
        /// Navigator.of(context).pushReplacement(
        ///   MaterialPageRoute(builder: (context) => DeliveryBoyDashboard()), // Replace with your home screen
        /// );
        ///&&&&&&&&&&&&& Delivery boy login &&&&&&&&&&


        //  _navigateToNextScreen(); this will working for user login
        _navigateToNextScreen();
      } else {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NoInternetScreen()));
      }
    });
  }


  /// ✅ **Check if the user email is stored, then navigate accordingly**
  Future<void> _navigateToNextScreen() async {


    await Provider.of<CartProvider>(context, listen: false).loadCartItems(); // ✅ Load cart
    await Future.delayed(Duration(seconds: 3)); // Splash delay
    String userEmail = StorageHelper().getEmail(); // Fetch stored email
    String userToken = StorageHelper().getUserAccessToken(); // Get stored token
    String? userRole = StorageHelper().getRole(); // Get stored role
    // if (userEmail.isNotEmpty) {
    //   // Navigator.of(context).pushReplacement(
    //   //   MaterialPageRoute(builder: (context) => BottomNavigationScreen()), // Replace with your home screen
    //   // );
    //
    //   if (userRole == "user") {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => BottomNavigationScreen()),
    //     );
    //
    //   } else if (userRole == "delivery_boy") {
    //     Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => DeliveryBoyDashboardScreen()),
    //     );
    //
    //   } else {
    //     Navigator.pushReplacement(
    //       context,
    //       MaterialPageRoute(builder: (context) => UserSelectionScreen()),
    //     );
    //   }
    // } else {
    //   Navigator.of(context).pushReplacement(
    //     MaterialPageRoute(builder: (context) => UserSelectionScreen()),
    //     // MaterialPageRoute(builder: (context) => LoginScreen()),
    //   );
    // }

    if (userRole == "user") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => BottomNavigationScreen()),
      );

    } else if (userRole == "delivery_boy") {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => DeliveryBoyDashboardScreen()),
      );

    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => UserSelectionScreen()),
      );
    }




  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
          /// ✅ **Background Image Full-Screen**
          // Positioned.fill(
          //   child: Image.asset(
          //     "assets/images/splash_bg.png",
          //     fit: BoxFit.cover, // ✅ **Full-screen background**
          //   ),
          // ),

          /// ✅ **Logo Center Mein**
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  width: ResponsiveHelper.containerWidth(context, 40),
                  height: ResponsiveHelper.containerWidth(context, 40),
                ),
              ),
              // Text(
              //   "Shanya Scans",
              //   style: AppTextStyles.heading1(
              //     context,
              //     overrideStyle:
              //     TextStyle(fontSize: ResponsiveHelper.fontSize(context, 20)),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}