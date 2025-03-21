import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthians/base_widgets/loading_indicator.dart';
import 'package:healthians/deliveryBoy/controller/DeliveryOrdersProvider.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:provider/provider.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../ui_helper/responsive_helper.dart';
import '../../util/date_formate.dart';

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
      appBar: AppBar(
        title: Text("Order Details"),
        backgroundColor: AppColors.deliveryPrimary,
      ),
      body: provider.isLoading
          ? Center(child: loadingIndicator(color: AppColors.deliveryPrimary))
          : provider.errorMessage.isNotEmpty
              ? Center(child: Text(provider.errorMessage))
              : orderDetail == null
                  ? Center(child: Text("No order details found"))
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16.0),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildInfoRow("Order Name",
                                  orderDetail.data!.orderName.toString()),
                              _buildInfoRow("Status",
                                  orderDetail.data!.bookingStatus.toString(),
                                  status: true),
                              _buildInfoRow("Patient Name",
                                  orderDetail.data!.patientName.toString()),
                              _buildInfoRow(
                                  "Date",
                                  DateUtil.formatISODate(orderDetail
                                      .data!.bookingDate
                                      .toString())),
                              _buildInfoRow(
                                  "Time",
                                  DateUtil.formatISOTime(orderDetail
                                      .data!.bookingTime
                                      .toString())),
                              _buildInfoRow(
                                  "Address",
                                  DateUtil.formatISOTime(orderDetail
                                      .data!.bookingTime
                                      .toString())),

                              _buildInfoRow(
                                  "Report Status",
                                  orderDetail.data!.reportStatus == "not ready"
                                      ? "Not Ready"
                                      : "Pending"),
                              _buildInfoRow("Total Price",
                                  "₹ ${orderDetail.data!.orderPrice}",
                                  price: true),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    icon: Icon(Icons.call, color: Colors.white),
                                    label: Text(
                                      "${orderDetail.data!.userId!.phoneNumber}",
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
                                        backgroundColor: Colors.green),
                                  ),
                                  StatefulBuilder(
                                    builder: (context, setState) {
                                      bool isUpdatingStatus = false; // Local state for button loader

                                      return ElevatedButton.icon(
                                        onPressed: () async {
                                          if (orderDetail.data != null) {
                                            String currentStatus = orderDetail.data!.bookingStatus ?? "";
                                            String newStatus = "";

                                            if (currentStatus == "confirmed") {
                                              newStatus = "ongoing";
                                            } else if (currentStatus == "ongoing") {
                                              newStatus = "completed";
                                            } else {
                                              return; // Do nothing if already completed
                                            }

                                            // Show loader on button
                                            setState(() {
                                              isUpdatingStatus = true;
                                            });

                                            // Call API to update the status
                                            bool success = await Provider.of<DeliveryOrdersProvider>(context, listen: false)
                                                .changeOrderStatus(newStatus,widget.orderId);

                                            if (success) {
                                              // Fetch updated order details only for the button state
                                              await Provider.of<DeliveryOrdersProvider>(context, listen: false)
                                                  .fetchDeliveryBoyOrderDetails(widget.orderId);

                                              // Update only button status
                                              setState(() {
                                                orderDetail.data!.bookingStatus = newStatus;
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
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 2,
                                          ),
                                        )
                                            : Icon(Icons.navigation, color: Colors.white),
                                        label: Text(
                                          orderDetail.data!.bookingStatus == "confirmed"
                                              ? "Pending"
                                              : orderDetail.data!.bookingStatus == "ongoing"
                                              ? "Ongoing"
                                              : orderDetail.data!.bookingStatus == "completed"
                                              ? "Completed"
                                              : "",
                                          style: AppTextStyles.heading1(
                                            context,
                                            overrideStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: ResponsiveHelper.fontSize(context, 14),
                                            ),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                                      );
                                    },
                                  ),


                                ],
                              )
                            ],
                          ),
                        ),
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
