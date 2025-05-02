import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/order/screen/order_history_detail.dart';
import 'package:provider/provider.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/util/image_loader_util.dart';
import '../../../base_widgets/common/default_common_app_bar.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/responsive_helper.dart';
import '../../../util/date_formate.dart';
import '../controller/order_provider.dart';
import '../model/MyOrderHistoryListModel.dart';
import 'package:shanya_scans/base_widgets/loading_indicator.dart';

class OrderListScreen extends StatefulWidget {
  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final orderProvider =
          Provider.of<OrderApiProvider>(context, listen: false);
      orderProvider.getOrderHistory(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(
        activityName: "Your Orders",
        backgroundColor: AppColors.primary,
      ),
      body: Consumer<OrderApiProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return loadingIndicator();
          } else if (orderProvider.errorMessage.isNotEmpty) {
            return Center(
              child: SizedBox(
                width: ResponsiveHelper.containerWidth(context, 50),
                height: ResponsiveHelper.containerWidth(context, 50),
                child:ImageLoaderUtil.assetImage(
                  "assets/images/img_error.jpg",
                ),
              ),
            );
          } else {
            final orderHistoryList =orderProvider.myOrderHistoryListModel?.data;
            if (orderHistoryList == null || orderHistoryList.isEmpty) {
              return Center(
                child: Text(
                  "No Orders Found",
                    style: AppTextStyles.bodyText1(
                      context,
                      overrideStyle: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(
                            context, 16),
                      ),
                    ),
                ),
              );
            }

            return ListView.builder(
              itemCount: orderHistoryList.length,
              itemBuilder: (context, index) {
                final order = orderHistoryList[index];
                return OrderCard(order: order);
              },
            );
          }
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Data order;
  final Random _random = Random();

  OrderCard({Key? key, required this.order}) : super(key: key);

  final List<Color> _statusColors = [
    Colors.green.shade500,
    Colors.orange.shade500,
    Colors.red.shade500,
    Colors.blue.shade500,
    Colors.purple.shade500,
    Colors.teal.shade500,
  ];

  Color _getRandomStatusColor() {
    return _statusColors[_random.nextInt(_statusColors.length)];
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = _getRandomStatusColor();

    return Padding(
      padding: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 5, right: 5),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: InkWell(
          onTap: () {
            print("Navigating to order history detail with ID: ${order.sId}");
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => UserOrderHistoryDetailScreen(
                        orderId: order.sId.toString(),
                      )),
              // MaterialPageRoute(builder: (context) =>  OrderDetailsPage(orderId: order.sId.toString(),)),
            );
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              // commit just check
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Order ID & Status
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "${order.orderName}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                          maxLines: 2, // Limits to 2 lines
                          overflow: TextOverflow
                              .ellipsis, // Adds "..." if text is too long
                        ),
                      ),
                      _buildStatusBadge(order.bookingStatus.toString()),
                    ],
                  ),

                  SizedBox(height: 6),
                  // Customer & Address
                  Row(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Patient Name: ",
                            style: AppTextStyles.bodyText1(
                              context,
                              overrideStyle: TextStyle(
                                color: Colors.black,
                                fontSize:
                                    ResponsiveHelper.fontSize(context, 12),
                              ),
                            ),
                          ),
                          Text(
                            "${order.patientName.toString()}",
                            style: AppTextStyles.bodyText1(
                              context,
                              overrideStyle: TextStyle(
                                fontSize:
                                    ResponsiveHelper.fontSize(context, 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(height: 5),
                  Row(
                    children: [
                      Text(
                        "Date:",
                        style: AppTextStyles.bodyText1(
                          context,
                          overrideStyle: TextStyle(
                            color: Colors.black,
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${DateUtil.formatISODate(order.bookingDate.toString())}",
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[700]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        "Time:",
                        style: TextStyle(fontSize: 13, color: Colors.black),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "${DateUtil.formatISOTime(order.bookingTime.toString())}",
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[700]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  // SizedBox(height: 10),

                  // Row(
                  //   children: [
                  //     Icon(Icons.location_on, color: Colors.red, size: 18),
                  //     SizedBox(width: 4),
                  //     Expanded(
                  //       child: Text(
                  //         "Lucknow",
                  //         style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  //         maxLines: 2,
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // SizedBox(height: 10),
                  // Row(
                  //   children: [
                  //     Text(
                  //       "Payment Mode:",
                  //       style: TextStyle(
                  //           fontSize: 13,
                  //           color: Colors.black,
                  //           fontWeight: FontWeight.bold),
                  //       maxLines: 2,
                  //       overflow: TextOverflow.ellipsis,
                  //     ),
                  //     SizedBox(width: 4),
                  //     Expanded(
                  //       child: Text(
                  //         "Cash on delivery ",
                  //         style: TextStyle(
                  //             fontSize: 13,
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.bold),
                  //         maxLines: 2,
                  //         overflow: TextOverflow.ellipsis,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  // Call & Navigate Buttons (Replaced ElevatedButton with TextButton)
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Report: ${order.reportStatus == "not ready" ? "Not Ready" : "Pending"}",
                        style: TextStyle(
                            color: Colors.green, fontWeight: FontWeight.w600),
                      ),
                      // InkWell(
                      //   onTap: (){
                      //     // double lat = double.parse(order.lat.toString());
                      //     // double long = double.parse(order.lng.toString());
                      //     //
                      //     // StorageHelper().setUserLat(lat);
                      //     // StorageHelper().setUserLong(long);
                      //     // // set the order id for tracking
                      //     // StorageHelper().setUserOrderId(order.sId.toString());
                      //     //
                      //     //
                      //     // Navigator.push(
                      //     //   context,
                      //     //   MaterialPageRoute(
                      //     //     builder: (context) => UserLiveTrackingScreen(),
                      //     //   ),
                      //     // );
                      //
                      //   },
                      //   child: Container(
                      //     padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      //     decoration: BoxDecoration(
                      //       color: statusColor.withAlpha(200),
                      //       borderRadius: BorderRadius.circular(8),
                      //     ),
                      //     child: Text("Track Order", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      //
                      //
                      //   ),
                      // ),
                      Text(
                        "\u20B9 ${order.orderPrice}",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Status Badge Design
  Widget _buildStatusBadge(String status) {
    Color badgeColor;
    switch (status) {
      case "confirmed":
        badgeColor = Colors.orange;
        break;
      case "ongoing":
        badgeColor = AppColors.primary;
        break;
      case "completed":
        badgeColor = Colors.green;
        break;
      default:
        badgeColor = Colors.grey;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        // status== "confirmed"
        //     ? "Pending"
        //     : status == "ongoing"
        //     ? "Ongoing"
        //     : status == "completed"
        //     ? "Completed"
        //     : "",

        status == "confirmed"
            ? "Confirmed"
            : status == "ongoing"
                ? "Ongoing"
                : status == "completed"
                    ? "Completed"
                    : "",

        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
