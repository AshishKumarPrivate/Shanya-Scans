import 'package:flutter/material.dart';
import 'package:healthians/base_widgets/loading_indicator.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:provider/provider.dart';
import '../../controller/DeliveryOrdersProvider.dart';
import 'DelliveryOrderCard.dart';

class DeliveryOrderList extends StatelessWidget {
  final String status;

  const DeliveryOrderList({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DeliveryOrdersProvider>(
      builder: (context, orderProvider, child) {
        if (orderProvider.isLoading) {
          return loadingIndicator(color: AppColors.deliveryPrimary);
        }

        if (orderProvider.orderList.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text("No Orders Found",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await orderProvider.fetchDeliveryBoyOrderList(status);
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            itemCount: orderProvider.orderList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  top: index == 0 ? 10 : 5,
                  bottom: index == orderProvider.orderList.length - 1 ? 10 : 5,
                ),
                child: DeliveryOrderCard(order: orderProvider.orderList[index]),
              );
            },
          ),
        );
      },
    );
  }
}
