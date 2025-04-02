// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:healthians/util/StringUtils.dart';
// import 'package:provider/provider.dart';
//
// import '../base_widgets/loading_indicator.dart';
// import '../base_widgets/outlined_rounded_button.dart';
// import '../base_widgets/solid_rounded_button.dart';
// import '../deliveryBoy/controller/DeliveryOrdersProvider.dart';
// import '../deliveryBoy/screen/UserTrackingScreen.dart';
// import '../ui_helper/app_colors.dart';
// import '../ui_helper/app_text_styles.dart';
// import '../ui_helper/responsive_helper.dart';
// import '../ui_helper/storage_helper.dart';
// import '../util/date_formate.dart';
//
// class OrderDetailsPage extends StatefulWidget {
//   final String orderId;
//
//   const OrderDetailsPage({Key? key, required this.orderId}) : super(key: key);
//
//   // const OrderDetailsPage({Key? key}) : super(key: key);
//
//   @override
//   State<OrderDetailsPage> createState() => _OrderDetailsPageState();
// }
//
// class _OrderDetailsPageState extends State<OrderDetailsPage> {
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: AppColors.primary,
//       statusBarIconBrightness: Brightness.light,
//     ));
//     Future.microtask(() {
//       final provider =
//           Provider.of<DeliveryOrdersProvider>(context, listen: false);
//       provider.fetchDeliveryBoyOrderDetails(widget.orderId);
//     });
//
//     // requestPermissions();
//     // getToken();
//   }
//
//   @override
//   void dispose() {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: AppColors.primary,
//       statusBarIconBrightness: Brightness.light,
//     ));
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Future.microtask(() {
//       SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//         statusBarColor: AppColors.primary,
//         statusBarIconBrightness: Brightness.light, // Ensure light icons
//       ));
//     });
//
//     final provider = Provider.of<DeliveryOrdersProvider>(context);
//     final orderDetail = provider.orderDetail;
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         iconTheme: IconThemeData(
//           color: Colors.white, // Change this to your desired color
//         ),
//         title: Text(
//           "Order Details",
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: AppColors.primary,
//       ),
//       body: provider.isLoading
//           ? loadingIndicator(color: AppColors.primary)
//           : provider.errorMessage.isNotEmpty
//               ? Center(child: Text("Something went wrong"))
//               : orderDetail == null
//                   ? Center(child: Text("No order details found"))
//                   : SingleChildScrollView(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 16, vertical: 8),
//                             decoration: const BoxDecoration(
//                               border: Border(
//                                   bottom: BorderSide(
//                                       color: Colors.grey, width: 0.5)),
//                             ),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Order ID - ${orderDetail.data!.sId.toString()}',
//                                   style: AppTextStyles.bodyText1(
//                                     context,
//                                     overrideStyle: TextStyle(
//                                       fontSize: ResponsiveHelper.fontSize(
//                                           context, 12),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Expanded(
//                                       flex: 3,
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             '${orderDetail.data!.orderName.toString()}',
//                                             style: AppTextStyles.heading1(
//                                               context,
//                                               overrideStyle: TextStyle(
//                                                 fontSize:
//                                                     ResponsiveHelper.fontSize(
//                                                         context, 16),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 5),
//                                           Text(
//                                             'Collection Type: ${StringUtils.capitalizeFirstLetter(orderDetail.data!.orderType.toString())}',
//                                             style: AppTextStyles.bodyText1(
//                                               context,
//                                               overrideStyle: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize:
//                                                     ResponsiveHelper.fontSize(
//                                                         context, 12),
//                                               ),
//                                             ),
//                                           ),
//                                           SizedBox(height: 5),
//                                           RichText(
//                                             text: TextSpan(
//                                               children: [
//                                                 TextSpan(
//                                                   text: "\u20B9 ", // Rupee Symbol with space
//                                                   style: AppTextStyles.heading1(
//                                                     context,
//                                                     overrideStyle: TextStyle(
//                                                       color: AppColors.primary,
//                                                       fontSize: ResponsiveHelper.fontSize(context, 16),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 TextSpan(
//                                                   text: orderDetail.data!.orderPrice.toString(),
//                                                   style: AppTextStyles.heading1(
//                                                     context,
//                                                     overrideStyle: TextStyle(
//                                                       color: AppColors.primary,
//                                                       fontSize: ResponsiveHelper.fontSize(context, 16),
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 TextSpan(
//                                                   text: " /-", // Smaller "/-" Sign
//                                                   style: AppTextStyles.heading1(
//                                                     context,
//                                                     overrideStyle: TextStyle(
//                                                       color: AppColors.primary,
//                                                       fontSize: ResponsiveHelper.fontSize(context, 14), // Smaller font size
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//
//                                           // Text(
//                                           //   '₹${orderDetail.data!.orderPrice}/-',
//                                           //   style: AppTextStyles.heading1(
//                                           //     context,
//                                           //     overrideStyle: TextStyle(
//                                           //       color: AppColors.primary,
//                                           //       fontSize:
//                                           //           ResponsiveHelper.fontSize(
//                                           //               context, 16),
//                                           //     ),
//                                           //   ),
//                                           // ),
//
//
//
//
//
//
//                                         ],
//                                       ),
//                                     ),
//                                     // Expanded(
//                                     //   flex: 1,
//                                     //   child: Image.network(
//                                     //     'https://via.placeholder.com/100',
//                                     //     height: 60,
//                                     //   ),
//                                     // ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           // Container(
//                           //   padding: const EdgeInsets.all(16),
//                           //   decoration: BoxDecoration(
//                           //     color: AppColors.lightBlueColor,
//                           //     border: Border(
//                           //         bottom: BorderSide(
//                           //             color: Colors.grey, width: 0.5)),
//                           //   ),
//                           //   child: Row(
//                           //     children: const [
//                           //       Icon(Icons.check_circle, color: Colors.green),
//                           //       SizedBox(width: 8),
//                           //       Text('Delivery was made with OTP verification'),
//                           //     ],
//                           //   ),
//                           // ),
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Icon(Icons.check_circle,
//                                         color: Colors.green),
//                                     SizedBox(width: 8),
//                                     Text(
//                                         'Order Date,Time,  ${DateUtil.formatISODate(orderDetail.data!.bookingDate.toString())}, ${DateUtil.formatISOTime(orderDetail.data!.bookingDate.toString())}'),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Row(
//                                   children: [
//                                     Icon(Icons.check_circle,
//                                         color: Colors.green),
//                                     SizedBox(width: 8),
//                                     Text(
//                                         'Test Confirmed,  ${DateUtil.formatISODate(orderDetail.data!.bookingDate.toString())}'),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 16),
//                                 Row(
//                                   children: const [
//                                     Icon(Icons.check_circle,
//                                         color: Colors.green),
//                                     SizedBox(width: 8),
//                                     Text('Delivered, Mar 18'),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const Divider(),
//                           Container(
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Your details',
//                                   style: AppTextStyles.bodyText1(
//                                     context,
//                                     overrideStyle: TextStyle(
//                                       color: Colors.black,
//                                       fontSize: ResponsiveHelper
//                                           .fontSize(context, 12),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(height: 10),
//                                 Text(
//                                     '${orderDetail.data!.patientName.toString()}',
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold)),
//                                 SizedBox(height: 4),
//                                 Text('615/617, Parvati Bhavan'),
//                                 Text('Sitapur Road, Madiyava, Navbasta puliya'),
//                                 Text('Lucknow'),
//                                 Text('Uttar Pradesh - 226021'),
//                                 SizedBox(height: 4),
//                                 Text('Phone number: 7985600652, 8009711121'),
//                               ],
//                             ),
//                           ),
//                           const Divider(),
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Flexible(
//                                   flex: 1,
//                                   child: OutlinedRoundedButton(
//                                     borderRadius: 10,
//                                     borderWidth: 1,
//                                     borderColor: AppColors.deliveryPrimary,
//                                     text: 'Track Order',
//                                     onPressed: () {
//                                       double lat = double.parse(
//                                           orderDetail.data!.lat.toString());
//                                       double long = double.parse(
//                                           orderDetail.data!.lng.toString());
//
//                                       StorageHelper().setUserLat(lat);
//                                       StorageHelper().setUserLong(long);
//                                       // set the order id for tracking
//                                       StorageHelper().setUserOrderId(
//                                           orderDetail.data!.sId.toString());
//
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               UserLiveTrackingScreen(),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 // const SizedBox(width: 10),
//                                 // Flexible(
//                                 //   flex: 1,
//                                 //   child: StatefulBuilder(
//                                 //     builder: (context, setState) {
//                                 //       bool isUpdatingStatus =
//                                 //           false; // Local state for button loader
//                                 //
//                                 //       return SolidRoundedButton(
//                                 //           onPressed: () async {
//                                 //             if (orderDetail.data != null) {
//                                 //               String currentStatus =
//                                 //                   orderDetail.data!.bookingStatus ??
//                                 //                       "";
//                                 //               String newStatus = "";
//                                 //
//                                 //               if (currentStatus == "confirmed") {
//                                 //                 newStatus = "ongoing";
//                                 //               } else if (currentStatus ==
//                                 //                   "ongoing") {
//                                 //                 newStatus = "completed";
//                                 //               } else {
//                                 //                 return; // Do nothing if already completed
//                                 //               }
//                                 //
//                                 //               // Show loader on button
//                                 //               setState(() {
//                                 //                 isUpdatingStatus = true;
//                                 //               });
//                                 //
//                                 //               // Call API to update the status
//                                 //               bool success = await Provider.of<
//                                 //                           DeliveryOrdersProvider>(
//                                 //                       context,
//                                 //                       listen: false)
//                                 //                   .changeOrderStatus(
//                                 //                       newStatus, widget.orderId);
//                                 //
//                                 //               if (success) {
//                                 //                 // Fetch updated order details only for the button state
//                                 //                 await Provider.of<
//                                 //                             DeliveryOrdersProvider>(
//                                 //                         context,
//                                 //                         listen: false)
//                                 //                     .fetchDeliveryBoyOrderDetails(
//                                 //                         widget.orderId);
//                                 //
//                                 //                 // Update only button status
//                                 //                 setState(() {
//                                 //                   orderDetail.data!.bookingStatus =
//                                 //                       newStatus;
//                                 //                 });
//                                 //               }
//                                 //
//                                 //               // Hide loader after API call
//                                 //               setState(() {
//                                 //                 isUpdatingStatus = false;
//                                 //               });
//                                 //             }
//                                 //           },
//                                 //           text: orderDetail.data!.bookingStatus ==
//                                 //                   "confirmed"
//                                 //               ? "Pending"
//                                 //               : orderDetail.data!.bookingStatus ==
//                                 //                       "ongoing"
//                                 //                   ? "Ongoing"
//                                 //                   : orderDetail.data!
//                                 //                               .bookingStatus ==
//                                 //                           "completed"
//                                 //                       ? "Completed"
//                                 //                       : "",
//                                 //           color: AppColors.primary,
//                                 //           borderRadius: 10.0,
//                                 //           textStyle: AppTextStyles.heading1(
//                                 //             context,
//                                 //             overrideStyle: TextStyle(
//                                 //               color: Colors.white,
//                                 //               fontSize: ResponsiveHelper.fontSize(
//                                 //                   context, 14),
//                                 //             ),
//                                 //           ));
//                                 //     },
//                                 //   ),
//                                 // ),
//                               ],
//                             ),
//                           ),
//                           // const Divider(),
//                           // Container(
//                           //   padding: const EdgeInsets.all(16),
//                           //   child: Column(
//                           //     crossAxisAlignment: CrossAxisAlignment.start,
//                           //     children: [
//                           //       const Text('Price Details',
//                           //           style:
//                           //               TextStyle(fontWeight: FontWeight.bold)),
//                           //       const SizedBox(height: 16),
//                           //       Row(
//                           //         mainAxisAlignment:
//                           //             MainAxisAlignment.spaceBetween,
//                           //         children: const [
//                           //           Text('List price'),
//                           //           Text('₹499'),
//                           //         ],
//                           //       ),
//                           //       const SizedBox(height: 8),
//                           //       Row(
//                           //         mainAxisAlignment:
//                           //             MainAxisAlignment.spaceBetween,
//                           //         children: const [
//                           //           Text('Selling price'),
//                           //           Text('₹240'),
//                           //         ],
//                           //       ),
//                           //       const SizedBox(height: 8),
//                           //       Row(
//                           //         mainAxisAlignment:
//                           //             MainAxisAlignment.spaceBetween,
//                           //         children: const [
//                           //           Text('Extra Discount'),
//                           //           Text('- ₹16',
//                           //               style: TextStyle(color: Colors.green)),
//                           //         ],
//                           //       ),
//                           //       const SizedBox(height: 8),
//                           //       Row(
//                           //         mainAxisAlignment:
//                           //             MainAxisAlignment.spaceBetween,
//                           //         children: const [
//                           //           Text('Special Price'),
//                           //           Text('₹224'),
//                           //         ],
//                           //       ),
//                           //       const SizedBox(height: 8),
//                           //       Row(
//                           //         mainAxisAlignment:
//                           //             MainAxisAlignment.spaceBetween,
//                           //         children: const [
//                           //           Text('Platform fee'),
//                           //           Text('₹3'),
//                           //         ],
//                           //       ),
//                           //       const SizedBox(height: 16),
//                           //       Row(
//                           //         mainAxisAlignment:
//                           //             MainAxisAlignment.spaceBetween,
//                           //         children: const [
//                           //           Text('Total Amount',
//                           //               style: TextStyle(
//                           //                   fontWeight: FontWeight.bold)),
//                           //           Text('₹227',
//                           //               style: TextStyle(
//                           //                   fontWeight: FontWeight.bold)),
//                           //         ],
//                           //       ),
//                           //       const SizedBox(height: 16),
//                           //       Row(
//                           //         children: const [
//                           //           Icon(Icons.circle, size: 6),
//                           //           SizedBox(width: 8),
//                           //           Text('UPI: ₹227.0'),
//                           //         ],
//                           //       ),
//                           //     ],
//                           //   ),
//                           // ),
//                         ],
//                       ),
//                     ),
//     );
//   }
// }
