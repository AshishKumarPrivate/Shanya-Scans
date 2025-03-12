import 'package:flutter/material.dart';
import 'package:healthians/deliveryBoy/screen/widget/DelliveryOrderCard.dart';
import 'package:healthians/ui_helper/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/DeliveryOrdersProvider.dart';
import '../model/DeliveryOrderLIstModel.dart';

class DeliveryBoyDashboardScreen extends StatefulWidget {
  @override
  _DeliveryBoyDashboardScreenState createState() =>
      _DeliveryBoyDashboardScreenState();
}

class _DeliveryBoyDashboardScreenState extends State<DeliveryBoyDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    Provider.of<DeliveryOrdersProvider>(context, listen: false).fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Custom Header with Summary & Tabs
            _buildHeader(),

            // Tab Views (Expands to full screen)
            Expanded(
              child: Consumer<DeliveryOrdersProvider>(
                builder: (context, orderProvider, child) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildOrderList(orderProvider.pendingOrders),
                      _buildOrderList(orderProvider.ongoingOrders),
                      _buildOrderList(orderProvider.deliveredOrders),
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

  /// 🔹 **Custom Header**
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBar(
          title: Text(
            "Delivery Dashboard",
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: AppColors.primary,
        ),
        _buildOrderSummary(),
        TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Pending"),
            Tab(text: "Ongoing"),
            Tab(text: "Delivered"),
          ],
        ),
      ],
    );
  }

  /// 🔹 **Order Summary Container**
  Widget _buildOrderSummary() {
    return Consumer<DeliveryOrdersProvider>(
      builder: (context, orderProvider, child) {
        int totalOrders = orderProvider.pendingOrders.length +
            orderProvider.ongoingOrders.length +
            orderProvider.deliveredOrders.length;

        // Get the latest pending order (if available)
        DeliveryBoyOrderListModel? latestOrder =
            orderProvider.pendingOrders.isNotEmpty
                ? orderProvider.pendingOrders.first
                : null;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade700, Colors.purple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.blue.shade900,
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: Offset(2, 3)),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔔 Pulsating Notification Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Orders: $totalOrders",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  _buildPulsatingIcon(), // Animated Notification Icon
                ],
              ),
              SizedBox(height: 10),

              // 🚀 Shimmer Effect for New Order
              if (latestOrder != null)
                Shimmer.fromColors(
                  baseColor: Colors.white,
                  highlightColor: Colors.yellowAccent,
                  child: Row(
                    children: [
                      Icon(Icons.delivery_dining,
                          color: Colors.greenAccent, size: 22),
                      SizedBox(width: 6),
                      Text(
                        "New Order Assigned!",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 8),

              // 📦 Order Details with Icons
              if (latestOrder != null) ...[
                // mai.js
                _buildOrderDetail(
                    Icons.receipt_long, "Order ID: ${latestOrder.id}323d322"),
                _buildOrderDetail(
                    Icons.location_on, "Address: ${latestOrder.address}",
                    isExpanded: true),
                _buildOrderDetail(
                    Icons.access_time, "Sample Collection: 20 minutes"),
              ] else
                Center(
                  child: Text(
                    "No New Orders Assigned.",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white70),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  /// 🔹 **Reusable Order Detail Row**
  Widget _buildOrderDetail(IconData icon, String text,
      {bool isExpanded = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 22),
          SizedBox(width: 6),
          isExpanded
              ? Expanded(
                  child: Text(text,
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      overflow: TextOverflow.ellipsis))
              : Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  /// 🔔 **Animated Pulsating Notification Icon**
  Widget _buildPulsatingIcon() {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 1, end: 1.4),
      duration: Duration(seconds: 1),
      curve: Curves.easeInOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      onEnd: () {
        // Reverse animation for continuous effect
        _buildPulsatingIcon();
      },
      child: Icon(Icons.notifications_active, color: Colors.yellow, size: 28),
    );
  }

  /// 🔹 **Order List Builder**
  Widget _buildOrderList(List<DeliveryBoyOrderListModel> orders) {
    if (orders.isEmpty) {
      return Center(child: Text("No Orders Found"));
    }
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return DeliveryOrderCard(order: orders[index]);
      },
    );
  }
}
