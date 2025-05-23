import 'package:flutter/material.dart';
import 'package:shanya_scans/ui_helper/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class PhoneCallHelper {
  static bool _isCalling = false;

  static Future<void> makePhoneCall(BuildContext context) async {
    if (_isCalling) return; // ⛔ Prevent multiple launches
    _isCalling = true;

    String phoneNumber = "9219816159";
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(
          launchUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        debugPrint('Could not launch $launchUri');
        showCustomSnackbarHelper.showSnackbar(
          context: context,
          message: "Unable to open dialer. Please check your device settings.",
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      debugPrint("Error launching phone dialer: $e");
    } finally {
      await Future.delayed(Duration(milliseconds: 500)); // Small buffer to avoid race
      _isCalling = false;
    }
  }
}
