import 'package:flutter/material.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:provider/provider.dart';
import '../../screen/cart/cart_list_screen.dart';
import '../../screen/cart/controller/cart_list_api_provider.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';

class NavCommonAppBar extends StatefulWidget {
  final String aciviyName;
  final bool isCartScreen;
  final bool isNavigation;
  final bool searchBarVisible;
  final Color backgroundColor; // ✅ New Parameter Added
  final Function(String)? onSearchChanged; // ✅ Add search callback

  NavCommonAppBar({
    required this.aciviyName,
    this.isCartScreen = false, // Default value is false
    this.isNavigation = false, // Default value is false
    this.searchBarVisible = false, // Default value is false
    this.backgroundColor = Colors.white, // Default color white
    this.onSearchChanged, // ✅ Optional search callback
  });

  @override
  State<NavCommonAppBar> createState() => _NavCommonAppBarState();
}

class _NavCommonAppBarState extends State<NavCommonAppBar> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(); // ✅ Added FocusNode
  @override
  void dispose() {
    searchController.dispose();
    _searchFocusNode.dispose(); // ✅ Dispose FocusNode to prevent memory leaks
    super.dispose();
  }

  void _unfocusKeyboard() {
    FocusScope.of(context).unfocus(); // ✅ Hide keyboard
  }

  @override
  Widget build(BuildContext context) {
    // final TextEditingController searchController = TextEditingController();

    return Container(
      color: widget.backgroundColor, // ✅ Set Background Color
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: !widget.isNavigation,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.arrow_back_ios),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.aciviyName,
                          style: AppTextStyles.heading1(context,
                              overrideStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      ResponsiveHelper.fontSize(context, 14))),
                          overflow: TextOverflow.ellipsis, // Prevent overflow
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // Icon(
                    //   Icons.share,
                    //   size: 22.0,
                    //   color: Colors.white,
                    // ),
                    // SizedBox(width: 15.0),
                    // Icon(
                    //   Icons.notification_important_outlined,
                    //   size: 22.0,
                    //   color: Colors.white,
                    // ),

                    SizedBox(width: widget.isCartScreen ? 0.0 : 15.0),
                    Visibility(
                      visible: !widget.isCartScreen,
                      // Hide if isCartScreen is true
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
                                  child: Icon(
                                    Icons.shopping_cart_checkout_outlined,
                                    color: Colors.white,
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
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                      constraints: BoxConstraints(
                                        minWidth: 15,
                                        minHeight: 15,
                                      ),
                                      child: Center(
                                        child: Text(
                                          cartProvider.cartItems.length
                                              .toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
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
                    SizedBox(width: 5.0),
                  ],
                ),
              ],
            ),
            ResponsiveHelper.sizeBoxHeightSpace(context, 1),
            widget.searchBarVisible
                ? Padding(
              padding: EdgeInsets.only(left: 5, right: 5,top: 5,bottom: 0),
              child: Container(
                height: ResponsiveHelper.containerHeight(context, 4.5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 0.4, color: AppColors.txtLightGreyColor),
                ),
                child: Center(
                  child: TextField(
                    controller: searchController,
                    onTap: _unfocusKeyboard,
                    onChanged: widget.onSearchChanged,
                    textAlignVertical: TextAlignVertical.center,
                    style: AppTextStyles.bodyText1(
                      context,
                      overrideStyle: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveHelper.fontSize(context, 14),
                      ),
                    ),
                    cursorColor: AppColors.primary,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      prefixIcon: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Icon(Icons.search_sharp, color: Colors.grey,size: 24,),
                      ),
                      hintText: "Enter your test here",
                      hintStyle: TextStyle(color: Colors.black54),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            )

          : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
