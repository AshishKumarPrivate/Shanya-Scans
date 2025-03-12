import 'package:flutter/material.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:provider/provider.dart';
import '../../screen/cart/cart_list_screen.dart';
import '../../screen/cart/controller/cart_list_api_provider.dart';
import '../../ui_helper/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String activityName;
  final VoidCallback? onBack;
  final bool isCartScreen;
  final bool isNavigation;
  final Color backgroundColor;

  const CustomAppBar({
    Key? key,
    required this.activityName,
    this.onBack,
    this.isCartScreen = false,
    this.isNavigation = false,
    this.backgroundColor = const Color(0xFF58a9c7),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      title: Text(
        activityName,
        style: AppTextStyles.heading2(
          context,
          overrideStyle: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      leading: !isNavigation
          ? IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: onBack ?? () => Navigator.pop(context),
      )
          : null,
      actions: [
        const Icon(Icons.share, size: 22.0, color: Colors.white),
        const SizedBox(width: 15.0),
        const Icon(Icons.notifications_outlined, size: 22.0, color: Colors.white),
        const SizedBox(width: 15.0),
        if (!isCartScreen)
          Consumer<CartProvider>(
            builder: (context, cartProvider, child) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.shopping_cart_outlined,
                      color: Colors.white,
                      size: ResponsiveHelper.iconSize(context, 22),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) =>  CartListScreen()),
                    ),
                  ),
                  if (cartProvider.cartItems.isNotEmpty)
                    Positioned(
                      right: 5,
                      top: 5,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 15,
                          minHeight: 15,
                        ),
                        child: Center(
                          child: Text(
                            cartProvider.cartItems.length.toString(),
                            style: const TextStyle(
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
        const SizedBox(width: 10),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
