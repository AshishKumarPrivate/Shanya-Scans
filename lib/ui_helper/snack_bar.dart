import 'package:flutter/material.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';

import 'app_text_styles.dart';

class showCustomSnackbarHelper {
  static void showSnackbar({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 5),
    Color? backgroundColor,
  }) {
    final snackbar = SnackBar(
      content: Text(
        message,
        style: AppTextStyles.heading1(context,
            overrideStyle: TextStyle(
              color: Colors.white,
                fontSize: ResponsiveHelper.fontSize(context, 12))),

      ),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor ?? AppColors.primary,
      // Default background color
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
    );

    ScaffoldMessenger.of(context)
        .clearSnackBars(); // Clear any previous snackbars
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
