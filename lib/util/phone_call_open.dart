import 'package:flutter/material.dart';
import 'package:healthians/ui_helper/snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> makePhoneCall(BuildContext context) async {
  String phoneNumber = "9161066154";
  final Uri launchUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(
      launchUri,
      mode: LaunchMode.externalApplication, // Explicit mode
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
}
