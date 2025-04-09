import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'dart:async';

class AppShareHelper {

  static bool _isSharing = false;

  static Future<String> getAppId() async {

    try {
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.packageName;
    } catch (e) {
      debugPrint("Error getting package info: $e");
      return "com.default.package"; // Provide a fallback package name
    }
  }

  static Future<void> shareApp(BuildContext context) async {
    if (_isSharing) return; // ⛔ Prevent multiple dialogs
    _isSharing = true;

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
    }finally {
      _isSharing = false;
    }
  }


}


