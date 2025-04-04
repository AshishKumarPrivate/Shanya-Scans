import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthians/base_widgets/solid_rounded_button.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:share_plus/share_plus.dart';

import '../../../base_widgets/common/default_common_app_bar.dart';
import '../../../ui_helper/app_colors.dart';

class ReferAndEarnScreen extends StatelessWidget {
  final String referralCode = "3YWAK"; // Replace with dynamic code
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(activityName: "Refer & Earn",backgroundColor: Color(0xffb3e7ff),),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: ResponsiveHelper.containerWidth(
                context,
                60,
              ),
              child: Image.asset(
                "assets/images/referearn.jpg",
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 16),
            Padding(
              padding: ResponsiveHelper.padding(context, 5, 0),
              child: Column(
                children: [
                  Text(
                    "Sharing is Rewarding",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Get ₹250 in your PharmEasy wallet every time you invite your friend",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "3YWAK",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                        ),
                        IconButton(
                          icon: Icon(Icons.copy),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: "${referralCode}"));
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Referral code copied!")),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  SolidRoundedButton(
                    text: 'Share via Whatsapp',
                    color: AppColors.primary,
                    borderRadius: 10.0,
                    onPressed: () {
                      print('Button clicked!');
                      String message =
                          "Hey! Use my referral code *$referralCode* to get ₹250 in Shanya Scans Wallet.";
                      String whatsappUrl = "$message";

                      try {
                        Share.share(whatsappUrl);
                      } catch (e) {
                        print("WhatsApp not installed.");
                      }
                    },
                    textStyle: TextStyle(
                        color: Colors.white, fontSize: 18, letterSpacing: 1),
                    // icon: Icon(Icons.touch_app, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  buildStep("Share your referral code with friends & family",
                      "Invite your friends and family to download the PharmEasy App."),
                  buildStep("Your friend enters the code",
                      "Once installed & registered, they need to enter the referral code."),
                  buildStep("Get ₹250 Reward",
                      "Once your friend registers & orders medicine, you'll get ₹250."),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildStep(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.orangeAccent,
            radius: 20,
            child: Icon(Icons.check, color: Colors.white),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
