import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';

import '../../../ui_helper/storage_helper.dart';

class RoleBasedOverlay extends StatelessWidget {
  final Widget child;

  const RoleBasedOverlay({Key? key, required this.child}) : super(key: key);

  Future<Color> _getStatusBarColor() async {
    String? userRole = StorageHelper().getRole(); // Get stored role
    if (userRole == "delivery_boy") {
      return AppColors.deliveryPrimary; // Example color for Delivery Boy
    } else {
      return AppColors.primary; // Example color for User
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Color>(
      future: _getStatusBarColor(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
            statusBarColor: snapshot.data ?? AppColors.primary,
            statusBarIconBrightness: Brightness.light,
          ));
        }
        return Overlay(
          initialEntries: [
            OverlayEntry(
              builder: (context) {
                return child;
              },
            ),
          ],
        );
      },
    );
  }
}
