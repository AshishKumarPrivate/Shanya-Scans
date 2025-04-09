import 'package:flutter/material.dart';
import 'package:shanya_scans/deliveryBoy/model/DeliveryOrderLIstModel.dart';
import 'package:shanya_scans/ui_helper/app_colors.dart';
import 'package:shanya_scans/util/date_formate.dart';

import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/responsive_helper.dart';
import '../deleivery_boy_order_detail_screen.dart';

class DeliveryOrderCard extends StatelessWidget {
  final OrderDetails order;

  const DeliveryOrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("Navigating to order details with ID: ${order.sId}");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  DeliveryBoyOrderDetailScreen(orderId: order.sId.toString(),)),
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
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            fontSize: ResponsiveHelper.fontSize(context, 12),
                          ),
                        ),
                      ),
                      Text(
                        "${order.patientName.toString()}",
                        style: AppTextStyles.bodyText1(
                          context,
                          overrideStyle: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 12),
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
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
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
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
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
                  // Text(
                  //   "\u20B9 ${order.orderPrice}",
                  //   style: TextStyle(
                  //       color: Colors.blue,
                  //       fontSize: 18,
                  //       fontWeight: FontWeight.w600),
                  // ),

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
                          text:order.orderPrice.toString(),
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








                ],
              ),
            ],
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
        // "${status == "confirmed" ? "Pending" : ""}",
        status== "confirmed"
            ? "Pending"
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
