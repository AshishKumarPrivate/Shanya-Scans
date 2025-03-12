import 'package:flutter/material.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:provider/provider.dart';
import '../../screen/cart/cart_list_screen.dart';
import '../../screen/cart/controller/cart_list_api_provider.dart';
import '../../ui_helper/app_text_styles.dart';

class CommonAppBar extends StatelessWidget {
  final String aciviyName;
  final bool isCartScreen;
  final bool isNavigation;
  final Color backgroundColor; // ✅ New Parameter Added

  CommonAppBar({
    required this.aciviyName,
    this.isCartScreen = false, // Default value is false
    this.isNavigation = false, // Default value is false
    this.backgroundColor = Colors.white, // Default color white
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor, // ✅ Set Background Color
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        // 🛠 Proper padding added
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Visibility(
                    visible: !isNavigation,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        // 🛠 Increased tap target
                        child: Icon(Icons.arrow_back_ios,color: Colors.white,),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      aciviyName,
                      style: AppTextStyles.heading1(context,
                          overrideStyle: TextStyle(
                          color: Colors.white,
                              fontSize: ResponsiveHelper.fontSize(context, 14))),
                      overflow: TextOverflow.ellipsis, // Prevent overflow
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(Icons.share, size: 22.0,color: Colors.white),
                SizedBox(width: 15.0),
                Icon(Icons.notification_important_outlined, size: 22.0,color: Colors.white),
                SizedBox(width: isCartScreen ? 0.0 : 15.0),
                Visibility(
                  visible: !isCartScreen, // Hide if isCartScreen is true
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CartListScreen(),
                        ),
                      );
                    },
                    child: Consumer<CartProvider>(
                      builder: (context, cartProvider, child) {
                        return Stack(
                          clipBehavior: Clip.none, // 🛠 Allow overflow
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              // 🛠 Extra padding for better spacing
                              child: Icon(
                              color: Colors.white,
                                Icons.shopping_cart_checkout_outlined,
                                size: ResponsiveHelper.iconSize(
                                    context, 22), // Slightly larger icon
                              ),
                            ),
                            if (cartProvider.cartItems
                                .isNotEmpty) // Show badge if cart has items
                              Positioned(
                                right: -3, // 🛠 Adjusted position
                                top: -10, // 🛠 Lifted up slightly
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  // 🛠 Increased padding
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 15,
                                    // 🛠 Minimum size for better visibility
                                    minHeight: 15,
                                  ),
                                  child: Center(
                                    child: Text(
                                      cartProvider.cartItems.length.toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12, // 🛠 Increased font size
                                        fontWeight: FontWeight
                                            .bold, // 🛠 Bold for better readability
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
