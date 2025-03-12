import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:async';

class AppShareHelper {
  static Future<String> getAppId() async {
    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.packageName;
    } catch (e) {
      debugPrint("Error getting package info: $e");
      return "com.default.package"; // Provide a fallback package name
    }
  }

  // static Future<void> shareApp(BuildContext context) async {
  //   try {
  //     String packageName = await getAppId();
  //     String appLink = "";
  //
  //     if (Platform.isAndroid) {
  //       appLink = 'https://play.google.com/store/apps/details?id=$packageName';
  //     } else if (Platform.isIOS) {
  //       appLink = 'https://apps.apple.com/app/idYOUR_APP_ID'; // Replace with actual App ID
  //     } else {
  //       appLink = 'https://yourwebsite.com'; // Fallback for other platforms
  //     }
  //
  //     String appMessage = 'Check out the Shanya Scans app: $appLink';
  //
  //     if (context.mounted) {
  //       await Share.share(
  //         appMessage,
  //         subject: "Check out this app!",
  //         sharePositionOrigin: Rect.fromCenter(
  //           center: Offset(MediaQuery.of(context).size.width / 2, MediaQuery.of(context).size.height / 2),
  //           width: 0,
  //           height: 0,
  //         ),
  //       );
  //     }
  //   } catch (e, stackTrace) {
  //     debugPrint("Error sharing app: $e");
  //     debugPrint("StackTrace: $stackTrace");
  //   }
  // }

  static Future<void> shareApp(BuildContext context) async {
    try {
      String packageName = await getAppId();
      String appLink = Platform.isAndroid
          ? 'https://play.google.com/store/apps/details?id=$packageName'
          : 'https://apps.apple.com/app/idYOUR_APP_ID'; // Replace with actual ID

      String appMessage = 'Check out the Shanya Scans app: $appLink';

      if (!context.mounted) return;

      await Future.delayed(Duration(milliseconds: 200)); // Prevent UI freeze
      await Share.share(appMessage, subject: "Check out this app!");
    } catch (e, stackTrace) {
      debugPrint("Error sharing app: $e");
      debugPrint("StackTrace: $stackTrace");
    }
  }

}
