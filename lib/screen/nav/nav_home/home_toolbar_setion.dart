import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:healthians/screen/cart/cart_list_screen.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:healthians/ui_helper/app_text_styles.dart';
import 'package:provider/provider.dart';

import '../../../bottom_navigation_screen.dart';
import '../../../ui_helper/storage_helper.dart';
import '../../../util/config.dart';
import '../../cart/controller/cart_list_api_provider.dart';

class HomeToolbarSection extends StatefulWidget {
  @override
  State<HomeToolbarSection> createState() => _HomeToolbarSectionState();
}

class _HomeToolbarSectionState extends State<HomeToolbarSection> {
  int currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  String userName = StorageHelper().getUserName(); // Fetch stored email
  String userAddress = "Lucknow,Uttar Pradesh";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUserAddress();
    });
  }

  void getUserAddress() async {
    final ConfigUtils _configUtils = ConfigUtils();
    _configUtils.startTracking();

    Map<String, dynamic> locationData = await _configUtils.locationStream.first;
    String latitude = locationData["latitude"].toString();
    String longitude = locationData["longitude"].toString();
    String address = locationData["address"];

    StorageHelper().setUserLiveAddress(address);
    setState(() {
      userAddress = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: ResponsiveHelper.padding(context, 3, 0.5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // SizedBox(width: 20,),
                        Expanded(
                          child: Text(
                            "Hello, ${userName}",
                            style: AppTextStyles.heading1(
                              context,
                              overrideStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize:
                                      ResponsiveHelper.fontSize(context, 14)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_pin,
                          size: 18,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Text(
                            userAddress,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.heading1(context,
                                overrideStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize:
                                        ResponsiveHelper.fontSize(context, 10))),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
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
                          children: [
                            Container(
                              // color: Colors.black,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(
                                  color: Colors.white,
                                  Icons.shopping_cart_checkout_outlined,
                                  size: ResponsiveHelper.iconSize(
                                      context, 24), // 24 is base size,
                                ),
                              ),
                            ),
                            if (cartProvider.cartItems
                                .isNotEmpty) // Show badge if cart has items
                              Positioned(
                                right: 2,
                                top: -5,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text(
                                    cartProvider.cartItems.length.toString(),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),

                    // Container(
                    //   // color: Colors.black,
                    //   child: Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: Icon(
                    //       color: Colors.white,
                    //       Icons.shopping_cart_checkout_outlined,
                    //       size: ResponsiveHelper.iconSize(
                    //           context, 24), // 24 is base size,
                    //     ),
                    //   ),
                    // ),
                  ),
                ],
              ),
            ],
          ),
          ResponsiveHelper.sizeBoxHeightSpace(context, 1.5),
          // Search Bar
          Center(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BottomNavigationScreen(initialPageIndex: 1),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                height: ResponsiveHelper.containerWidth(context, 10),
                // Fixed height
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                      width: 0.4, color: AppColors.txtLightGreyColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      blurRadius: 1.0,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10), // Space between icon and text
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BottomNavigationScreen(initialPageIndex: 1),
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 0),
                              // Adjust for alignment
                              child: DefaultTextStyle(
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize:
                                      ResponsiveHelper.fontSize(context, 14),
                                  fontWeight: FontWeight.bold,
                                  height: 1.2, // Maintain line height
                                ),
                                child: AnimatedTextKit(
                                  repeatForever: true,
                                  animatedTexts: [
                                    RotateAnimatedText(
                                        'Search for CBC, X-ray, etc.'),
                                    RotateAnimatedText(
                                        'Find Lab Tests, MRI, CT Scan...'),
                                    RotateAnimatedText(
                                        'Search Your Health Test Here...'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Icon(Icons.keyboard_voice, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ),
          ResponsiveHelper.sizeBoxHeightSpace(context, 0.5),
        ],
      ),
    );
  }
}
