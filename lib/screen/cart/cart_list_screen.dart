import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:healthians/base_widgets/common/custom_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:healthians/screen/cart/controller/cart_list_api_provider.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../base_widgets/common/common_app_bar.dart';
import '../../base_widgets/solid_rounded_button.dart';
import '../../base_widgets/custom_rounded_container.dart';
import '../../ui_helper/responsive_helper.dart';
import '../checkout/CheckoutScreen.dart';
import '../checkout/controller/checkout_api_provider.dart';
import '../order/model/OrderItem.dart';

import 'package:html/parser.dart'; // Import required package

class CartListScreen extends StatefulWidget {
  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).loadCartItems();
    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar:

      PreferredSize(
        preferredSize: Size.fromHeight(60), // Adjust height as needed
        child: CustomAppBar(
          activityName: "Cart",
          isCartScreen: true,
          backgroundColor: AppColors.primary,
        ),
      ),

      body: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ CommonAppBar moved outside Consumer
            // CommonAppBar(
            //   aciviyName: "Cart",
            //   isCartScreen: true,
            //   backgroundColor: AppColors.primary,
            // ),

            Expanded(
              child: Consumer<CartProvider>(
                builder: (context, cartProvider, child) {
                  if (cartProvider.cartItems.isEmpty) {
                    // ✅ If cart is empty, show empty cart message
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.remove_shopping_cart,
                              size: 80, color: Colors.grey),
                          SizedBox(height: 20),
                          Text(
                            "Your Cart is Empty",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  // ✅ Calculate dynamic cart total
                  double cartTotal = cartProvider.cartItems.fold(
                      0, (sum, item) => sum + (item.price * item.quantity));
                  double discount = 399.00;
                  double orderTotal = cartTotal - discount;

                  return Stack(
                    children: [
                      // 🟢 Cart Content (Scrollable)
                      SingleChildScrollView(
                        padding: EdgeInsets.only(bottom: 80),
                        // Space for fixed button
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 🟢 Cart Items List
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: cartProvider.cartItems.length,
                              itemBuilder: (context, index) {
                                final cartItem = cartProvider.cartItems[index];

                                return Container(
                                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: AppColors.lightBlueColor!, width: 5)),
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      // 🟢 Image Section
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          width: ResponsiveHelper.containerWidth(context, 20),
                                          height: ResponsiveHelper.containerWidth(context, 20),
                                          child: Image.network(cartItem.imageUrl, fit: BoxFit.cover),
                                        ),
                                      ),
                                      SizedBox(width: 10),

                                      // 🟢 Details Section (Title + HTML + Price + Quantity Selector)
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cartItem.name,
                                              maxLines: 1,
                                              style: AppTextStyles.heading1(
                                                context,
                                                overrideStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: ResponsiveHelper.fontSize(context, 12),
                                                ),
                                              ),
                                            ),

                                            // 🟢 HTML Content - Completely Removing All Spacing
                                            Html(
                                              data: cartItem.packageDetail,
                                              shrinkWrap: true,
                                              style: {
                                                "body": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                                                "p": Style(
                                                  textAlign: TextAlign.start,
                                                  alignment: Alignment.topLeft,
                                                  maxLines: 2,
                                                  color: AppColors.txtGreyColor,
                                                  fontSize: FontSize(ResponsiveHelper.fontSize(context, 10)),
                                                  margin: Margins.zero,
                                                  padding: HtmlPaddings.zero,
                                                  lineHeight: LineHeight(1.4),
                                                ),
                                                "pre": Style(margin: Margins.zero, padding: HtmlPaddings.zero, lineHeight: LineHeight(1)),
                                                "div": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                                                "span": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                                                "ul": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                                                "li": Style(margin: Margins.zero, padding: HtmlPaddings.zero),
                                              },
                                            ),

                                            ResponsiveHelper.sizeBoxHeightSpace(context, 0.5),

                                            // 🟢 Price + Quantity Controls in Row
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Moves quantity to the end
                                              children: [
                                                // 🟢 Price Text (Left side)
                                                Text(
                                                  "₹${cartItem.price}",
                                                  style: AppTextStyles.heading1(
                                                    context,
                                                    overrideStyle: TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),

                                                // 🟢 Quantity Control (Moved to end)
                                                Container(
                                                  height: 20,
                                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        onPressed: () => cartProvider.decreaseQuantity(context,cartItem.id),
                                                        icon: Icon(Icons.remove, color: Colors.black, size: 16),
                                                        padding: EdgeInsets.zero,
                                                        constraints: BoxConstraints(minWidth: 28, minHeight: 28),
                                                        style: IconButton.styleFrom(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                                          backgroundColor: AppColors.lightYellowColor,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                                        child: Text(
                                                          "${cartItem.quantity}",
                                                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () => cartProvider.increaseQuantity(context, cartItem.id),
                                                        icon: Icon(Icons.add, color: Colors.black, size: 16),
                                                        padding: EdgeInsets.zero,
                                                        constraints: BoxConstraints(minWidth: 28, minHeight: 28),
                                                        style: IconButton.styleFrom(
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
                                                          backgroundColor: AppColors.lightYellowColor,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),

                                      // 🟢 Delete Button
                                      Column(
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.delete_outline, color: Colors.red),
                                            onPressed: () {
                                              cartProvider.removeFromCart(context, cartItem.id);
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                                ;
                              },
                            ),

                            SizedBox(height: 16),

                            // 🟢 Cart Summary
                            Container(
                              // color: AppColors.lightBlueColor,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: CustomRoundedContainer(
                                borderRadius: 0,
                                borderColor: Colors.transparent,
                                borderWidth: 0,
                                elevation: 0,
                                backgroundColor: Colors.white,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SummaryRow(
                                          label: 'Cart Value',
                                          value: '₹$cartTotal'),
                                      SummaryRow(
                                          label: 'Coupon Discount',
                                          value: '-₹$discount'),
                                      SummaryRow(
                                          label: 'Sample Collection Charges',
                                          value: '₹250.00 Free'),
                                      Divider(),
                                      SummaryRow(
                                          label: 'Amount Payable',
                                          value: '₹$orderTotal',
                                          isBold: true),
                                      SizedBox(height: 8),
                                      Text(
                                        'Total Savings of ₹${cartTotal - orderTotal} on this order',
                                        style: AppTextStyles.heading2(
                                          context,
                                          overrideStyle: TextStyle(
                                            color: Colors.green,
                                            fontSize: ResponsiveHelper.fontSize(
                                                context, 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ✅ Fixed "Proceed" Button at Bottom
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(18.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1), // Shadow color
                                spreadRadius: 0, // No extra spread
                                blurRadius: 10, // Blur effect for smooth shadow
                                offset: Offset(0, -3), // Moves shadow **above** the container
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // 🟢 Amount Payable Section
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '₹$orderTotal',
                                      style: AppTextStyles.heading2(
                                        context,
                                        overrideStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: ResponsiveHelper.fontSize(
                                                context, 16)),
                                      ),
                                    ),
                                    Text(
                                      '₹$orderTotal',
                                      style: AppTextStyles.bodyText1(context,
                                          overrideStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  ResponsiveHelper.fontSize(
                                                      context, 12))),
                                    ),
                                  ],
                                ),
                              ),

                              // 🟢 "Proceed" Button
                              Flexible(
                                child: Center(
                                  child: SolidRoundedButton(
                                    text: 'Proceed',
                                    color: AppColors.primary,
                                    borderRadius: 10.0,
                                    onPressed: () {
                                      print('Proceed button clicked!');

                                      final cartListPr =   Provider.of<CartProvider>(context, listen: false);
                                      final services = cartListPr.cartItems;


                                      /// Function to extract plain text from an HTML string
                                      String extractPlainText(String htmlString) {
                                        var document = parse(htmlString);
                                        return document.body?.text ?? "";
                                      }

                                      List<OrderItem> orderItems = services.map((cartItem) {
                                        return OrderItem(
                                          id: cartItem.id ?? "", // Use actual ID from cart item
                                          name: cartItem.name,
                                          category: cartItem.category ?? "", // Ensure category is available
                                          price:  double.parse(cartItem.price.toString()),
                                          imageUrl: cartItem.imageUrl ?? OrderItem.defaultImage, // Use default if missing
                                          packageDetail: extractPlainText(cartItem.packageDetail), // Extract text from HTML
                                          quantity: cartItem.quantity,
                                        );
                                      }).toList();

                                      // ✅ Add all orderItems to CheckoutProvider before navigating
                                      Provider.of<CheckoutProvider>(context, listen: false).addMultipleToCheckout(context, orderItems);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CheckoutScreen(
                                                categoryName: "serviceName",
                                                name: "packageName",
                                                price: "packageRate",
                                              ),
                                        ),
                                      );

                                    },
                                    textStyle: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 🟢 SummaryRow Widget
class SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const SummaryRow(
      {required this.label, required this.value, this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.heading2(
              context,
              overrideStyle: TextStyle(
                  color: Colors.black,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  fontSize: ResponsiveHelper.fontSize(context, 14)),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.heading1(
              context,
              overrideStyle: TextStyle(
                fontSize: ResponsiveHelper.fontSize(context, 14),
                color: Colors.black,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
