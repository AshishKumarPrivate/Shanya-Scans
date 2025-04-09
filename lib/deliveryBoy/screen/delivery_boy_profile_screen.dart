import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shanya_scans/deliveryBoy/screen/delivery_boy_order_list_screen.dart';
import 'package:shanya_scans/deliveryBoy/screen/widget/DeliveryOrderList.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/ui_helper/app_text_styles.dart';
import 'package:provider/provider.dart';
import 'package:shanya_scans/ui_helper/storage_helper.dart';

import '../../base_widgets/common/default_common_app_bar.dart';
import '../../base_widgets/outlined_rounded_button.dart';
import '../controller/DeliveryOrdersProvider.dart';
import '../controller/delivery_boy_auth_provider.dart';

class DeliveryBoyProfileScreen extends StatefulWidget {
  @override
  _DeliveryBoyProfileScreenState createState() =>
      _DeliveryBoyProfileScreenState();
}

class _DeliveryBoyProfileScreenState extends State<DeliveryBoyProfileScreen> {
  bool isOnline = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DeliveryOrdersProvider>(context, listen: false)
          .fetchDeliveryBoyProfileSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title: Text("Profile"),
      // ),
      appBar: DefaultCommonAppBar(
        activityName: "Your Profile",
        backgroundColor: AppColors.deliveryPrimary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
          child: Column(
            children: [
              // Container(
              //   width: double.infinity,
              //   child: Card(
              //     color: Colors.white,
              //     elevation: 3,
              //     shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(10)),
              //     child: Padding(
              //       padding: EdgeInsets.all(16),
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             StorageHelper().getDeliveryBoyName() ?? "N/A",
              //             style: TextStyle(
              //                 fontSize: 22, fontWeight: FontWeight.bold),
              //           ),
              //           SizedBox(height: 8),
              //           Text(
              //             "Email: ${StorageHelper().getDeliveryBoyEmail() ?? "N/A"}",
              //             style: TextStyle(fontSize: 16),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1, color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${StorageHelper().getDeliveryBoyName() ?? "N/A"}",
                              style: AppTextStyles.heading1(context,
                                  overrideStyle: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  )),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "${StorageHelper().getDeliveryBoyEmail() ?? "N/A"}",
                              style: AppTextStyles.bodyText1(context,
                                  overrideStyle: new TextStyle(
                                    fontSize: 14,
                                  )),
                            ),
                          ],
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/svg/sales_boy.svg",
                        width: 70,
                        height: 70,
                        // colorFilter: ColorFilter.mode(AppColors.deliveryPrimary, BlendMode.srcIn),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () {
                    print("Complete order ");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeliveryOrderListScreen(
                          status: "completed",
                        ),
                      ),
                    );
                  },
                  child: _buildMenuItem(
                      "Total Home Collection", Icons.check_circle_outline)),
              SizedBox(height: 20),

              /// Summary Cards
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     _buildSummaryCard(
              //         "\$16.0", "Due Amount", Colors.red.shade100),
              //     _buildSummaryCard(
              //         "231", "Orders Delivered", Colors.green.shade100),
              //     _buildSummaryCard(
              //         "\$118.0", "Total Earning", Colors.yellow.shade100),
              //   ],
              // ),

              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: ResponsiveHelper.containerWidth(context, 30),
                  height: ResponsiveHelper.containerWidth(context, 8),
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
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Text(title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          Spacer(),
          Icon(icon, size: 18, color: Colors.black),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String value, String label, Color bgColor) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Text(label,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 0),
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
                      Provider.of<DeliveryBoyAuthApiProvider>(context,
                              listen: false)
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 0),
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
}
