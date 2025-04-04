import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthians/base_widgets/loading_indicator.dart';
import 'package:healthians/deliveryBoy/controller/DeliveryOrdersProvider.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:provider/provider.dart';
import '../../base_widgets/outlined_rounded_button.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../ui_helper/responsive_helper.dart';
import '../../ui_helper/storage_helper.dart';
import '../../util/StringUtils.dart';
import '../../util/date_formate.dart';
import 'SalesTrackingScreen.dart';
import 'UserTrackingScreen.dart';

class DeliveryBoyOrderDetailScreen extends StatefulWidget {
  final String orderId;

  const DeliveryBoyOrderDetailScreen({Key? key, required this.orderId})
      : super(key: key);

  @override
  _DeliveryBoyOrderDetailScreenState createState() =>
      _DeliveryBoyOrderDetailScreenState();
}

class _DeliveryBoyOrderDetailScreenState
    extends State<DeliveryBoyOrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.deliveryPrimary,
      statusBarIconBrightness: Brightness.light,
    ));
    Future.microtask(() {
      final provider =
          Provider.of<DeliveryOrdersProvider>(context, listen: false);
      provider.fetchDeliveryBoyOrderDetails(widget.orderId);
    });
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.deliveryPrimary,
      statusBarIconBrightness: Brightness.light,
    ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColors.deliveryPrimary,
        statusBarIconBrightness: Brightness.light, // Ensure light icons
      ));
    });

    final provider = Provider.of<DeliveryOrdersProvider>(context);
    final orderDetail = provider.orderDetail;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, // Change this to your desired color
        ),
        title: Text(
          "Order Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.deliveryPrimary,
      ),
      body: provider.isLoading
          ? Center(child: loadingIndicator(color: AppColors.deliveryPrimary))
          : provider.errorMessage.isNotEmpty
              ? Center(child: Text(provider.errorMessage))
              : orderDetail == null
                  ? Center(child: Text("No order details found"))
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(0.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: const BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      color: Colors.grey, width: 0.5)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order ID - ${orderDetail.data!.sId.toString()}',
                                  style: AppTextStyles.bodyText1(
                                    context,
                                    overrideStyle: TextStyle(
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${orderDetail.data!.orderName.toString()}',
                                            style: AppTextStyles.heading1(
                                              context,
                                              overrideStyle: TextStyle(
                                                fontSize:
                                                    ResponsiveHelper.fontSize(
                                                        context, 16),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            'Collection Type: ${StringUtils.capitalizeEachWord(orderDetail.data!.orderType.toString())}',
                                            style: AppTextStyles.bodyText1(
                                              context,
                                              overrideStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    ResponsiveHelper.fontSize(
                                                        context, 12),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      "\u20B9 ", // Rupee Symbol with space
                                                  style: AppTextStyles.heading1(
                                                    context,
                                                    overrideStyle: TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: ResponsiveHelper
                                                          .fontSize(
                                                              context, 16),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: orderDetail
                                                      .data!.orderPrice
                                                      .toString(),
                                                  style: AppTextStyles.heading1(
                                                    context,
                                                    overrideStyle: TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: ResponsiveHelper
                                                          .fontSize(
                                                              context, 16),
                                                    ),
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      " /-", // Smaller "/-" Sign
                                                  style: AppTextStyles.heading1(
                                                    context,
                                                    overrideStyle: TextStyle(
                                                      color: AppColors.primary,
                                                      fontSize: ResponsiveHelper
                                                          .fontSize(context,
                                                              14), // Smaller font size
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),

                                          // Text(
                                          //   '₹${orderDetail.data!.orderPrice}/-',
                                          //   style: AppTextStyles.heading1(
                                          //     context,
                                          //     overrideStyle: TextStyle(
                                          //       color: AppColors.primary,
                                          //       fontSize:
                                          //           ResponsiveHelper.fontSize(
                                          //               context, 16),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                    // Expanded(
                                    //   flex: 1,
                                    //   child: Image.network(
                                    //     'https://via.placeholder.com/100',
                                    //     height: 60,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Container(
                          //   padding: const EdgeInsets.all(16),
                          //   decoration: BoxDecoration(
                          //     color: AppColors.lightBlueColor,
                          //     border: Border(
                          //         bottom: BorderSide(
                          //             color: Colors.grey, width: 0.5)),
                          //   ),
                          //   child: Row(
                          //     children: const [
                          //       Icon(Icons.check_circle, color: Colors.green),
                          //       SizedBox(width: 8),
                          //       Text('Delivery was made with OTP verification'),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.green),
                                    SizedBox(width: 8),
                                    Text(
                                        'Order Date,Time,  ${DateUtil.formatISODate(orderDetail.data!.bookingDate.toString())}, ${DateUtil.formatISOTime(orderDetail.data!.bookingDate.toString())}'),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.green),
                                    SizedBox(width: 8),
                                    Text(
                                        'Test Confirmed,  ${DateUtil.formatISODate(orderDetail.data!.bookingDate.toString())}'),
                                  ],
                                ),
                                // const SizedBox(height: 16),
                                Visibility(
                                  visible: orderDetail.data!.bookingStatus ==
                                          "completed"
                                      ? true
                                      : false,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 16),
                                      Row(
                                        children: [
                                          Icon(Icons.check_circle,
                                              color: Colors.green),
                                          SizedBox(width: 8),
                                          Text(
                                              'Collected On ${DateUtil.formatISODate(orderDetail.data!.bookingDate.toString())}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Container(
                            padding: const EdgeInsets.all(16),
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Patient Details',
                                  style: AppTextStyles.heading1(
                                    context,
                                    overrideStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${orderDetail.data!.patientName.toString()}',
                                  style: AppTextStyles.bodyText1(
                                    context,
                                    overrideStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 12),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Visibility(
                                  visible: orderDetail
                                      .data?.patientAddress?.isNotEmpty ??
                                      false,
                                  child: Text(
                                    orderDetail.data?.patientAddress ?? '',
                                    style: AppTextStyles.bodyText1(
                                      context,
                                      overrideStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 12),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: orderDetail
                                      .data
                                      ?.patientSelectedAddress
                                      ?.isNotEmpty ??
                                      false,
                                  child: Text(
                                    orderDetail.data?.patientSelectedAddress ??
                                        '',
                                    style: AppTextStyles.bodyText1(
                                      context,
                                      overrideStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4),
                                Visibility(
                                  visible: orderDetail
                                      .data
                                      ?.patientSelectedAddress
                                      ?.isNotEmpty ??
                                      false,
                                  child: Text(
                                    " Phone Number ${orderDetail.data?.patientSelectedAddress ?? ''}",
                                    style: AppTextStyles.bodyText1(
                                      context,
                                      overrideStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: ResponsiveHelper.fontSize(
                                            context, 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(),
                          Visibility(
                            visible:
                                orderDetail.data!.bookingStatus == "completed"
                                    ? false
                                    : true,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Visibility(
                                    visible: orderDetail.data!.bookingStatus ==
                                            "ongoing"
                                        ? true
                                        : false,
                                    child: Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: () {
                                          StorageHelper().setUserOrderId(
                                              orderDetail.data!.sId.toString());
                                          StorageHelper().setUserLat(double.parse(
                                              orderDetail.data!.lat.toString()));
                                          StorageHelper().setUserLong(
                                              double.parse(orderDetail.data!.lng
                                                  .toString()));

                                          // Start live tracking
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SalesLiveTrackingScreen(orderDetail.data!.patientName.toString()),
                                            ),
                                          );

                                          /// Stop tracking (if needed)
                                          //    ConfigUtils().stopTracking();
                                        },
                                        icon:
                                            Icon(Icons.location_pin, color: Colors.white),
                                        label: Text(
                                          "Track Order",
                                          // "${orderDetail.data!.userId?.phoneNumber ?? "N/A"}",
                                          style: AppTextStyles.heading1(
                                            context,
                                            overrideStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: ResponsiveHelper.fontSize(
                                                  context, 14),
                                            ),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            backgroundColor: Colors.green),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  Expanded(
                                    child: StatefulBuilder(
                                      builder: (context, setState) {
                                        bool isUpdatingStatus =
                                            false; // Local state for button loader

                                        return ElevatedButton.icon(
                                          onPressed: () async {
                                            if (orderDetail.data != null) {
                                              String currentStatus = orderDetail
                                                      .data!.bookingStatus ??
                                                  "";
                                              String newStatus = "";

                                              if (currentStatus == "confirmed") {
                                                newStatus = "ongoing";
                                              } else if (currentStatus ==
                                                  "ongoing") {
                                                newStatus = "completed";
                                              } else {
                                                return; // Do nothing if already completed
                                              }

                                              // Show loader on button
                                              setState(() {
                                                isUpdatingStatus = true;
                                              });

                                              // Call API to update the status
                                              bool success = await Provider.of<
                                                          DeliveryOrdersProvider>(
                                                      context,
                                                      listen: false)
                                                  .changeOrderStatus(
                                                      newStatus, widget.orderId);

                                              if (success) {
                                                // Fetch updated order details only for the button state
                                                await Provider.of<
                                                            DeliveryOrdersProvider>(
                                                        context,
                                                        listen: false)
                                                    .fetchDeliveryBoyOrderDetails(
                                                        widget.orderId);

                                                // Update only button status
                                                setState(() {
                                                  orderDetail.data!
                                                      .bookingStatus = newStatus;
                                                });
                                              }

                                              // Hide loader after API call
                                              setState(() {
                                                isUpdatingStatus = false;
                                              });
                                            }
                                          },
                                          icon: isUpdatingStatus
                                              ? SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                    strokeWidth: 2,
                                                  ),
                                                )
                                              : Icon(Icons.navigation,
                                                  color: Colors.white),
                                          label: Text(
                                            orderDetail.data!.bookingStatus ==
                                                    "confirmed"
                                                ? "Click to start riding"
                                                : orderDetail.data!
                                                            .bookingStatus ==
                                                        "ongoing"
                                                    ? "Ongoing"
                                                    : orderDetail.data!
                                                                .bookingStatus ==
                                                            "completed"
                                                        ? "Completed"
                                                        : "",
                                            style: AppTextStyles.heading1(
                                              context,
                                              overrideStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ResponsiveHelper.fontSize(
                                                        context, 14),
                                              ),
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5))),
                                            backgroundColor: Colors.blue,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
    );
  }

  Widget _buildInfoRow(String title, String value,
      {bool status = false, bool price = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700]),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: status
                ? BoxDecoration(
                    color: _getStatusColor(value),
                    borderRadius: BorderRadius.circular(6),
                  )
                : null,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: price ? FontWeight.bold : FontWeight.w400,
                color: status ? Colors.white : Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.call, color: Colors.white),
          label: Text("Call Customer"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(Icons.navigation, color: Colors.white),
          label: Text("Navigate"),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;
      case "ongoing":
        return Colors.blue;
      case "delivered":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
