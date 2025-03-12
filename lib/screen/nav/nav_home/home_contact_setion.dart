import 'package:flutter/material.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
 import 'package:healthians/base_widgets/custom_rounded_container.dart';
import 'package:healthians/util/phone_call_open.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../util/whatsapp_open.dart';

class HomeContactSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Row(
          //   children: [
          //     Spacer(),
          //     Divider(
          //       color: Colors.black,
          //       thickness: 1,
          //       height: 1,
          //     ),
          //     Text(
          //       "Contact Us Via",
          //       style: AppTextStyles.bodyText1(context,overrideStyle: new TextStyle(
          //         fontSize: 14
          //       ))
          //     ),
          //     Spacer(),
          //     Divider(
          //       color: Colors.black,
          //       thickness: 1,
          //       height: 1,
          //     ),
          //   ],
          // ),
          Text(
              "Contact Us Via",
              style: AppTextStyles.bodyText1(context,overrideStyle: new TextStyle(
                  fontSize: 14
              ))
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: ResponsiveHelper.containerWidth(context,40),
              child: Divider(
                color: AppColors.txtGreyColor,
                thickness: 0.3,
                height: 0.1,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Equal width cards using Expanded
                Expanded(
                  child: CustomRoundedContainer(
                    onTap: (){
                      openWhatsApp("Hello,");
                    },
                    borderRadius: 10,
                    borderColor: AppColors.txtGreyColor,
                    borderWidth: 0.1,
                    elevation: 5,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "assets/images/whatsapp.png",
                            width: 20,
                            height: 20,
                            color: Colors.green,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Whatsapp",
                            style: AppTextStyles.bodyText1(context,
                                overrideStyle: TextStyle(
                                  color: Colors.black,
                                    fontSize: ResponsiveHelper.fontSize(
                                        context, 12))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 30), // Space between cards
                Expanded(
                  child: CustomRoundedContainer(
                    onTap: (){
                      makePhoneCall(context);
                    },
                    borderRadius: 10,
                    borderColor: AppColors.txtGreyColor,
                    borderWidth: 0.1,
                    elevation: 5,
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.call_rounded, size: 20),
                          const SizedBox(width: 5),
                          Text(
                            "Call",
                            style: AppTextStyles.bodyText1(context,
                                overrideStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: ResponsiveHelper.fontSize(
                                        context, 12))),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // SizedBox(width: 10), // Space between cards
                // Expanded(
                //   child: CustomRoundedContainer(
                //     borderRadius: 5,
                //     borderColor: AppColors.txtGreyColor,
                //     borderWidth: 0.1,
                //     elevation: 1,
                //     backgroundColor: Colors.white,
                //     child: Padding(
                //       padding: const EdgeInsets.symmetric(vertical: 5.0),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Icon(Icons.camera_alt_outlined, size: 15),
                //           const SizedBox(width: 5),
                //           Text(
                //             "Prescription",
                //             style: AppTextStyles.bodyText1(context,
                //                 overrideStyle: TextStyle(
                //                     color: Colors.black,
                //                     fontSize: ResponsiveHelper.fontSize(
                //                         context, 12))),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          ResponsiveHelper.sizeBoxHeightSpace(context, 2),
        ],
      ),
    );
  }
}
