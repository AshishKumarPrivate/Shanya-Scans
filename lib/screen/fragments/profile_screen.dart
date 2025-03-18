import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthians/screen/auth/controller/auth_provider.dart';
import 'package:healthians/screen/auth/forget_password_screen.dart';
import 'package:healthians/screen/cart/cart_list_screen.dart';
import 'package:healthians/screen/nav/nav_profile/cell_profile_list_tile.dart';
import 'package:healthians/screen/order/screen/order_list_screen.dart';
import 'package:healthians/screen/other/webview_screen.dart';
import 'package:healthians/screen/profile/edit_profile.dart';
import 'package:healthians/screen/profile/screen/need_help_screen.dart';
import 'package:healthians/screen/profile/screen/refer_and_earn.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:healthians/ui_helper/storage_helper.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/outlined_rounded_button.dart';
import '../../deliveryBoy/screen/deleivery_boy_dashboard.dart';
import '../../ui_helper/app_colors.dart';
import '../../util/share_app_utils.dart';

class ProfileScreen extends StatelessWidget {
  // const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userName = StorageHelper().getUserName();
    final userEmail = StorageHelper().getEmail();

    print("userId => ${StorageHelper().getUserId()}");

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: AppColors.primary, // Same as Clipper color
        statusBarIconBrightness:
            Brightness.light, // Light icons on dark background
      ),
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height, // Fill full height
            width: double.infinity,
            color: Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 0.0, right: 0, bottom: 0, left: 0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipPath(
                      clipper: CustomClipPath(),
                      child: Container(
                        height: 170, // Height of the curved container
                        // height: ResponsiveHelper.containerHeight(context, 20), // Height of the curved container
                        color: AppColors.primary,
                        child: Stack(
                          children: [
                            // Centered content
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  SizedBox(
                                    width: ResponsiveHelper.containerWidth(
                                        context, 15),
                                    height: ResponsiveHelper.containerWidth(
                                        context, 15),
                                    child: CircleAvatar(
                                      radius: 15, // Image radius
                                      backgroundImage:
                                          AssetImage('assets/images/user.png'),
                                    ),
                                  ),
                                  ResponsiveHelper.sizeBoxHeightSpace(
                                      context, 1),
                                  Text(
                                    "Hi, ${userName}",
                                    style: AppTextStyles.heading1(
                                      context,
                                      overrideStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 14),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${userEmail}",
                                    style: AppTextStyles.bodyText1(
                                      context,
                                      overrideStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 12),
                                      ),
                                    ),
                                  ),
                                  ResponsiveHelper.sizeBoxHeightSpace(
                                      context, 1),
                                ],
                              ),
                            ),

                            // Edit icon positioned at the top right
                            Positioned(
                              top: 0, // Adjust top padding as needed
                              right: 10, // Adjust right padding as needed
                              child: IconButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditProfileScreen(),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.mode_edit_sharp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          ProfileListTile(
                            leadingAssetImage: "assets/svg/order_icons.svg",
                            title: "Orders",
                            onTap: () {
                              print("Tapped on Account Settings");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OrderListScreen(),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ProfileListTile(
                            title: "Cart",
                            onTap: () {
                              print("Tapped on Account Settings");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CartListScreen(),
                                  // builder: (context) => MyWishListScreen(),
                                ),
                              );
                            },
                            leadingAssetImage: "assets/svg/cart_icons.svg",
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ProfileListTile(
                            title: "Refer & Earn",
                            onTap: () {
                              print("Tapped on Account Settings");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReferAndEarnScreen(),
                                ),
                              );
                            },
                            leadingAssetImage: "assets/svg/refer_earn.svg",
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ProfileListTile(
                            title: "Need Help",
                            onTap: () {
                              print("Tapped on Account Settings");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NeedHelpScreen(),
                                ),
                              );
                            },
                            leadingAssetImage: "assets/svg/help_icon.svg",
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ProfileListTile(
                            title: "Privacy Policy",
                            onTap: () {
                              print("Tapped on Account Settings");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                      isPrivacyPolicy: true,
                                      isRefundPolicy: false,
                                      isTermAndConditions: false,
                                      aciviyName: "Privacy Policy",
                                      url: "https://ayush.webakash1806.com/privacy-policy"),
                                ),
                              );
                            },
                            leadingAssetImage: "assets/svg/privacy_icon.svg",
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ProfileListTile(
                            title: "Terms & Conditions",
                            onTap: () {
                              print("Tapped on terms and conditions");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                      isPrivacyPolicy: false,
                                      isRefundPolicy: false,
                                      isTermAndConditions: true,
                                      aciviyName: "Terms & Conditions",
                                      url:
                                          "https://ayush.webakash1806.com/term-condition"),
                                ),
                              );
                            },
                            leadingAssetImage: "assets/svg/term_condition.svg",
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ProfileListTile(
                            title: "Refund & Cancellation",
                            onTap: () {
                              print("Tapped on Refund & Cancellation");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WebViewScreen(
                                      isPrivacyPolicy: false,
                                      isRefundPolicy: true,
                                      isTermAndConditions: false,
                                      aciviyName: "Refund & Cancellation",
                                      url:
                                          "https://ayush.webakash1806.com/term_condition.svg"),
                                ),
                              );
                            },
                            leadingAssetImage: "assets/svg/refund_icon.svg",
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ProfileListTile(
                            title: "Share App",
                            leadingIcon: Icons.share,
                            leadingIconColor: AppColors.primary,
                            onTap: () {
                              print("Tapped on Share app card");
                              AppShareHelper.shareApp(
                                  context); // Call the reusable share function
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          ProfileListTile(
                            title: "Sales Dashoard",
                            leadingIcon: Icons.share,
                            leadingIconColor: AppColors.primary,
                            onTap: () {
                              // Call the reusable share function
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        DeliveryBoyDashboardScreen()), // Replace with your home screen
                              );
                            },
                          ),
                          Visibility(
                            visible: false,
                            child: ProfileListTile(
                              title: "Forget Password",
                              onTap: () {
                                print("Tapped on Forget Password");
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen(),
                                    // builder: (context) => MyWishListScreen(),
                                  ),
                                );
                              },
                              titleStyle: TextStyle(
                                color: Colors.red,
                              ),
                              backgroundColor: Colors.transparent,
                              leadingIcon: Icons.lock_reset_outlined,
                              leadingIconColor: Colors.red,
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width:
                                  ResponsiveHelper.containerWidth(context, 30),
                              height:
                                  ResponsiveHelper.containerWidth(context, 8),
                              child: OutlinedRoundedButton(
                                text: 'Logout',
                                borderWidth: 0.2,
                                icon: Icon(
                                  Icons.logout,
                                  color: Colors.red,
                                ),
                                color: Colors.red,
                                borderColor: Colors.red,
                                borderRadius: 10.0,
                                onPressed: () {
                                  showLogoutBottomSheet(context);
                                  print('Button clicked!');
                                },
                                textStyle: TextStyle(fontSize: 18),
                                // icon: Icon(Icons.touch_app, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom clipper for curved effect
class CustomClipPath extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

void showLogoutBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// **Red Warning Icon**
            Container(
              width: 100,
              height: 5,
              color: Colors.grey[400],
            ),

            Container(
              width: double.infinity,
              // color: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 50,
                    ),
                    const SizedBox(height: 10),

                    /// **Sign Out Text**
                    Text(
                      "Sign out from Account",
                      style: AppTextStyles.bodyText1(context,
                          overrideStyle: new TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),
                    const SizedBox(height: 8),

                    /// **Confirmation Message**
                    Text(
                      "Are you sure you would like to signout of your Account",
                      textAlign: TextAlign.start,
                      style: AppTextStyles.bodyText1(context,
                          overrideStyle: new TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// **Cancel & Logout Buttons**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                /// **Cancel Button**
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightBrown_color,
                    // Light background
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                  ),
                  child: Text(
                    "Cancel",
                    style: AppTextStyles.heading1(context,
                        overrideStyle: new TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                  ),
                ),

                /// **Logout Button**
                ElevatedButton(
                  onPressed: () async {
                    Provider.of<AuthApiProvider>(context, listen: false)
                        .logoutUser(context);
                    // **Storage se logout & async process complete hone ka wait karein**
                    // await StorageHelper().logout();
                    // // **Bottom Sheet Close karein**
                    // Navigator.pop(context);
                    // // **Navigate to LoginScreen & Remove All Screens**
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(builder: (context) => LoginScreen()),
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Orange button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                  ),
                  child: Text(
                    "Logout",
                    style: AppTextStyles.heading1(context,
                        overrideStyle: new TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}
