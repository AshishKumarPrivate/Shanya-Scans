import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../base_widgets/common/default_common_app_bar.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../ui_helper/responsive_helper.dart';
import '../controller/order_provider.dart';
import '../model/MyOrderHistoryListModel.dart';
import 'package:healthians/base_widgets/loading_indicator.dart';

class OrderListScreen extends StatefulWidget {
  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<OrderApiProvider>(context, listen: false)
        .getOrderHistory(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: DefaultCommonAppBar(activityName: "Your Orders"),
      body: Consumer<OrderApiProvider>(
        builder: (context, orderProvider, child) {
          if (orderProvider.isLoading) {
            return loadingIndicator();
          } else if (orderProvider.errorMessage.isNotEmpty) {
            return Center(
                child: Text(orderProvider.errorMessage,
                    style: TextStyle(color: Colors.red)));
          } else {
            final orderHistoryList =
                orderProvider.myOrderHistoryListModel?.data?.orderDetails;
            if (orderHistoryList == null || orderHistoryList.isEmpty) {
              return Center(
                child: Text("No orders found",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
  final OrderDetails order;
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
      padding:
          const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 10, right: 10),
      child: Material(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                order.name.toString(),
                style: AppTextStyles.heading1(context,
                    overrideStyle: TextStyle(
                        fontSize: ResponsiveHelper.fontSize(context, 14))),
              ),
              SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    "Booking Date",
                    style: AppTextStyles.bodyText1(context,
                        overrideStyle: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 12))),
                  ),
                  SizedBox(width: 5,),
                  Text(
                    "${order.bod.toString()}",
                    style: AppTextStyles.bodyText1(context,
                        overrideStyle: TextStyle(
                            fontSize: ResponsiveHelper.fontSize(context, 12))),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor.withAlpha(200),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(order.status.toString(),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                  Text("\u20B9${order.price.toString()}",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
