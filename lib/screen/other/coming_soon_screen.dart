import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthians/base_widgets/solid_rounded_button.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';

import '../../../base_widgets/common/default_common_app_bar.dart';
import '../../../ui_helper/app_colors.dart';

class ComingSoonScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(activityName: "Manage Profile"),
      body: SingleChildScrollView(
        child:Center( // Ensures everything is in the center
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center, // Vertically centers content
            children: [
              ResponsiveHelper.sizeBoxHeightSpace(context, 30),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Text(
                      "This Features will",
                      style: AppTextStyles.heading2(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 14),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ResponsiveHelper.containerWidth(context, 30),
                      height: ResponsiveHelper.containerWidth(context, 30),
                      child: Image.asset(
                        "assets/images/comingsoon.png",
                        fit: BoxFit.fill,
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
