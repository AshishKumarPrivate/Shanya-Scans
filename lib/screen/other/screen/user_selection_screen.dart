import 'package:flutter/material.dart';
import 'package:shanya_scans/base_widgets/outlined_rounded_button.dart';
import 'package:shanya_scans/deliveryBoy/screen/delivery_boy_login_screen.dart';
import 'package:shanya_scans/screen/auth/login_screen.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/ui_helper/storage_helper.dart';
import 'package:shanya_scans/util/image_loader_util.dart';

import '../../../base_widgets/solid_rounded_button.dart';

class UserSelectionScreen extends StatelessWidget {

  Future<void> _saveRoleAndNavigate(BuildContext context, String role) async {
    StorageHelper().setRole(role);
    // F44336

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => role == "user" ? LoginScreen() : DeliveryLoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              ImageLoaderUtil.assetImage(
                'assets/images/img_logo.png', // Replace with your actual logo asset
                height: 80,
              ),
              SizedBox(height: 10),
              Text(
                'Shanya Scans',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 30),
              Text(
                "Let's get started!",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Login to enjoy the features we've provided, and stay healthy!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 40),
              SolidRoundedButton(
                onPressed: () {
                  _saveRoleAndNavigate(context, "user");
                },
                text: 'Patient Login',
                color: AppColors.primary,
                borderRadius: 10.0,
                textStyle: const TextStyle(
                    color: Colors.white, fontSize: 18),

              ),
              SizedBox(height: 15),
              OutlinedRoundedButton(
                borderRadius: 10,
                borderWidth: 1,
                borderColor: AppColors.deliveryPrimary,
                text: 'Sales Person Login',
                onPressed: () {
                  _saveRoleAndNavigate(context, "delivery_boy");
                },

              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}