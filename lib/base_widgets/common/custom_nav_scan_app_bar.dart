import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:provider/provider.dart';
import '../../screen/cart/cart_list_screen.dart';
import '../../screen/cart/controller/cart_list_api_provider.dart';
import '../../screen/other/screen/search_screen.dart';
import '../../screen/packages/controller/health_package_list_api_provider.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';

class NavScanAppBar extends StatefulWidget {
  final String aciviyName;
  final bool isCartScreen;
  final bool isNavigation;
  final bool searchBarVisible;
  final Color backgroundColor; // ✅ New Parameter Added
  final Function(String)? onSearchChanged; // ✅ Add search callback

  NavScanAppBar({
    required this.aciviyName,
    this.isCartScreen = false, // Default value is false
    this.isNavigation = false, // Default value is false
    this.searchBarVisible = false, // Default value is false
    this.backgroundColor = Colors.white, // Default color white
    this.onSearchChanged, // ✅ Optional search callback
  });

  @override
  State<NavScanAppBar> createState() => _NavScanAppBarState();
}

class _NavScanAppBarState extends State<NavScanAppBar> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // ✅ Added FocusNode

  final Color scanStatusBarColor = Color(0xFFFFE8E2);
  final Color defaultStatusBarColor = AppColors.primary;

  final List<Map<String, String>> services = [
    {
      'image': "assets/images/labtest.png",
      'title': "Lab Test",
      'color': "0xFFFFE8E2",
      'textColor': "0xffFD6E87"
    }
  ];

  bool get isScanScreen =>
      widget.aciviyName == "Scan"; // ✅ Identify Scan Screen

  @override
  void didChangeDependencies() {
    if (isScanScreen) {
      _updateStatusBarColor();
    }
    super.didChangeDependencies();
  }

  void _updateStatusBarColor() {
    if (isScanScreen) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: scanStatusBarColor,
          statusBarIconBrightness: Brightness.dark,
        ),
      );
    }
  }

  void _resetStatusBarColor() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: defaultStatusBarColor,
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _resetStatusBarColor(); // ✅ Reset only if Scan Screen
    searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _updateStatusBarColor();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isScanScreen) _updateStatusBarColor();
    });

    return Container(
      color: widget.backgroundColor, // ✅ Set Background Color
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: services.map((service) {
          return Expanded(
            child: InkWell(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0.0),
                    child: Stack(
                      clipBehavior: Clip.none, // Allows the image to overflow
                      alignment: Alignment.center,
                      children: [
                        // Background Container
                        InkWell(
                          splashColor: Colors.black.withOpacity(0.2),
                          // Ripple effect color
                          borderRadius: BorderRadius.circular(30),
                          // Matches the container shape
                          child: Material(
                            color: Colors.transparent,
                            elevation: 0,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                            child: Container(
                              // width: ResponsiveText.containerWidth(context, 400),
                              height:
                                  ResponsiveHelper.containerWidth(context, 13),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.8),
                                    blurRadius: 15,
                                    spreadRadius: 5,
                                  ),
                                ],
                                color: Color(int.parse(service['color']!)),
                                // color: Colors.amber[50], // Background color
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(0),
                                  topRight: Radius.circular(0),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                              ),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, left: 10, right: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Visibility(
                                              visible: !widget.isNavigation,
                                              child: InkWell(
                                                onTap: () {
                                                  _resetStatusBarColor(); // ✅ Reset before navigating
                                                  Navigator.pop(context);
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Icon(
                                                      Icons.arrow_back_ios),
                                                ),
                                              ),
                                            ),
                                            SizedBox(width: 10),
                                            Expanded(
                                              child: Text(
                                                widget.aciviyName,
                                                style: AppTextStyles.heading1(
                                                    context,
                                                    overrideStyle: TextStyle(
                                                        color: Color(int.parse(
                                                            service[
                                                                'textColor']!)),
                                                        fontSize:
                                                            ResponsiveHelper
                                                                .fontSize(
                                                                    context,
                                                                    14))),
                                                overflow: TextOverflow
                                                    .ellipsis, // Prevent overflow
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.share,
                                            size: 22.0,
                                            color: Color(int.parse(
                                                service['textColor']!)),
                                          ),
                                          SizedBox(width: 15.0),
                                          Icon(
                                            Icons
                                                .notification_important_outlined,
                                            size: 22.0,
                                            color: Color(int.parse(
                                                service['textColor']!)),
                                          ),
                                          SizedBox(
                                              width: widget.isCartScreen
                                                  ? 0.0
                                                  : 15.0),
                                          Visibility(
                                            visible: !widget.isCartScreen,
                                            // Hide if isCartScreen is true
                                            child: InkWell(
                                              onTap: () {
                                                _resetStatusBarColor(); // ✅ Reset before navigating
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CartListScreen(),
                                                  ),
                                                );
                                              },
                                              child: Consumer<CartProvider>(
                                                builder: (context, cartProvider,
                                                    child) {
                                                  return Stack(
                                                    clipBehavior: Clip.none,
                                                    // 🛠 Allow overflow
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 0.0),
                                                        child: Icon(
                                                          Icons
                                                              .shopping_cart_checkout_outlined,
                                                          color: Color(
                                                              int.parse(service[
                                                                  'textColor']!)),
                                                          size: ResponsiveHelper
                                                              .iconSize(context,
                                                                  22), // Slightly larger icon
                                                        ),
                                                      ),
                                                      if (cartProvider.cartItems
                                                          .isNotEmpty) // Show badge if cart has items
                                                        Positioned(
                                                          right: -3,
                                                          // 🛠 Adjusted position
                                                          top: -10,
                                                          // 🛠 Lifted up slightly
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    2),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.red,
                                                              shape: BoxShape
                                                                  .circle,
                                                            ),
                                                            constraints:
                                                                BoxConstraints(
                                                              minWidth: 15,
                                                              minHeight: 15,
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                cartProvider
                                                                    .cartItems
                                                                    .length
                                                                    .toString(),
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
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
                              ),
                            ),
                          ),
                        ),

                        // Positioned Image at Bottom Center
                        Positioned(
                          bottom: -35,
                          // Moves the image downwards (adjust as needed)
                          child: Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                // BoxShadow(
                                //   color: Colors.grey.withAlpha(0),
                                //   blurRadius: 0,
                                //   spreadRadius: 0,
                                //   offset: Offset(0,0), // Shadow position
                                // ),
                              ],
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                service['image']!,
                                width: ResponsiveHelper.iconSize(context, 66),
                                height: ResponsiveHelper.iconSize(context, 75),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // const SizedBox(height: 25),
                  // Text(
                  //   service['title']!,
                  //   style: AppTextStyles.heading2(context,
                  //       overrideStyle: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: ResponsiveText.fontSize(context, 12),
                  //       )),
                  // ),

                  ResponsiveHelper.sizeBoxHeightSpace(context, 3),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
