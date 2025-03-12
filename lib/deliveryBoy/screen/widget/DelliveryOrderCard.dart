import 'package:flutter/material.dart';
import 'package:healthians/deliveryBoy/model/DeliveryOrderLIstModel.dart';

class DeliveryOrderCard extends StatelessWidget {
  final DeliveryBoyOrderListModel order;

  const DeliveryOrderCard({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
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
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order ID & Status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Order ID: ${order.id}",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  _buildStatusBadge(order.status),
                ],
              ),
              SizedBox(height: 6),
              // Customer & Address
              Text(
                "Customer: ${order.customerName}",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),

              SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    "Test Name: ",
                    style: TextStyle(fontSize: 13, color: Colors.black),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "Kidney Liver Test",
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.red, size: 18),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      order.address,
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "Payment Mode:",
                    style: TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      "Cash on delivery ",
                      style: TextStyle(fontSize: 13, color: Colors.black,fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),

              // Call & Navigate Buttons (Replaced ElevatedButton with TextButton)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      // Call action
                    },
                    icon: Icon(Icons.call, color: Colors.green),
                    label: Text(
                      "Call Customer",
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      // Navigation action
                    },
                    label: Text(
                      "\u20B9 1200",
                      style: TextStyle(color: Colors.blue,fontSize: 18, fontWeight: FontWeight.w600),
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
      case "Pending":
        badgeColor = Colors.orange;
        break;
      case "Ongoing":
        badgeColor = Colors.blue;
        break;
      case "Delivered":
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
        status,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
