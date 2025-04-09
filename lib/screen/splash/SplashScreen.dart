
import 'package:flutter/material.dart';
import 'package:shanya_scans/deliveryBoy/screen/deleivery_boy_dashboard.dart';
import 'package:shanya_scans/screen/other/screen/user_selection_screen.dart';
import 'package:shanya_scans/screen/splash/screen/NoInternetScreen.dart';
import 'package:provider/provider.dart';

import '../../bottom_navigation_screen.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/responsive_helper.dart';
import '../../ui_helper/storage_helper.dart';
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
  void _checkConnectivity() async {
    await Future.delayed(const Duration(seconds: 2));

    bool isConnected = Provider.of<NetworkProvider>(context, listen: false).isConnected;

    if (!isConnected) {
      _navigateTo(NoInternetScreen());
      return;
    }
    await Provider.of<CartProvider>(context, listen: false).loadCartItems();
    final userRole = StorageHelper().getRole();
    if (userRole == "user") {
      final isOtpVerified = await StorageHelper().getOtpVerified();
      if (isOtpVerified) {
        _navigateTo(const BottomNavigationScreen());
      } else {
        _navigateTo( UserSelectionScreen());
      }
    } else if (userRole == "delivery_boy") {
      _navigateTo( DeliveryBoyDashboardScreen());
    } else {
      _navigateTo( UserSelectionScreen());
    }
  }

  void _navigateTo(Widget screen) {
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Stack(
        children: [
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
            ],
          ),
        ],
      ),
    );
  }
}