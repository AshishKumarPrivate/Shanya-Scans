import 'package:flutter/material.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';

import '../../../base_widgets/common/default_common_app_bar.dart';

class MyWishListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:DefaultCommonAppBar(activityName: "Your Wishlist"),
      body: SingleChildScrollView(
        child:Center( // Ensures everything is in the center
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center, // Vertically centers content
            children: [
              ResponsiveHelper.sizeBoxHeightSpace(context, 10),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      width: ResponsiveHelper.containerWidth(context, 50),
                      height: ResponsiveHelper.containerWidth(context, 50),
                      child: Image.asset(
                        "assets/images/img_error.jpg",
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      "No Data Found",
                      style: AppTextStyles.heading2(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: ResponsiveHelper.fontSize(context, 14),
                        ),
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
