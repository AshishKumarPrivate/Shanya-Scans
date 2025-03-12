import 'package:flutter/material.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';

import '../ui_helper/app_text_styles.dart';

class AsteriskTextWidget extends StatelessWidget {
  final String text;

  AsteriskTextWidget({required this.text});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // To allow overflow of the asterisk
      children: [
        Text(
          text,
          // style: AppTextStyles.bodyText1.copyWith(
          //   fontSize: 14,
          //   // color: Colors.black,
          // ),
          style: AppTextStyles.bodyText1(context,overrideStyle: TextStyle(
            fontSize: ResponsiveHelper.fontSize(context, 14),
          ),

            // color: Colors.black,
          ),
        ),
        Positioned(
          top: -5, // Adjusts the vertical position of the asterisk
          right: -10, // Adjusts the horizontal position of the asterisk
          child:Text(
            "*",
            style:  AppTextStyles.bodyText1(
              context,
              overrideStyle: AppTextStyles.bodyText1(context,
                  overrideStyle: TextStyle(
                      fontSize: ResponsiveHelper.fontSize(
                          context, 14))),
            ),
          ),
        ),
      ],
    );
  }
}
