import 'package:flutter/material.dart';
import 'package:healthians/deliveryBoy/screen/widget/DeliveryOrderList.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../ui_helper/app_colors.dart';
import '../controller/DeliveryOrdersProvider.dart';

class DeliveryBoyDashboardScreen extends StatefulWidget {
  @override
  _DeliveryBoyDashboardScreenState createState() =>
      _DeliveryBoyDashboardScreenState();
}

class _DeliveryBoyDashboardScreenState extends State<DeliveryBoyDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? lastBackPressedTime;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Fetch orders based on tab selection
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fetchOrdersForTab(_tabController.index);
      }
    });

    // Fetch initial tab orders (Pending by default)
    _fetchOrdersForTab(0);
  }

  void _fetchOrdersForTab(int index) {
    final provider = Provider.of<DeliveryOrdersProvider>(context, listen: false);
    if (index == 0) {
      provider.fetchDeliveryBoyOrderList("confirmed");
    } else if (index == 1) {
      provider.fetchDeliveryBoyOrderList("ongoing");
    } else if (index == 2) {
      provider.fetchDeliveryBoyOrderList("completed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Colors.grey[200], // Subtle background
        body: SafeArea(
          child: Column(
            children: [
              _buildOrderSummary(),
              _buildTabs(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    DeliveryOrderList(status: "confirmed"),
                    DeliveryOrderList(status: "ongoing"),
                    DeliveryOrderList(status: "completed"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// **Custom Header with Order Summary Above Tabs**
  Widget _buildOrderSummary() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(12),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade700, Colors.purple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade900.withOpacity(0.5),
            blurRadius: 6,
            spreadRadius: 2,
            offset: Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔔 Notification Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Orders: 10",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              _buildPulsatingIcon(),
            ],
          ),
          SizedBox(height: 10),

          // Shimmer effect for new orders
          Shimmer.fromColors(
            baseColor: Colors.white,
            highlightColor: Colors.yellowAccent,
            child: Row(
              children: [
                Icon(Icons.delivery_dining, color: Colors.greenAccent, size: 22),
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

        ],
      ),
    );
  }

  /// **Build Tab Bar**
  Widget _buildTabs() {
    return Container(
      color: AppColors.deliveryPrimary,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        indicatorColor: Colors.white,
        tabs: [
          Tab(text: "Pending"),
          Tab(text: "Ongoing"),
          Tab(text: "Delivered",),
        ],
      ),
    );
  }

  /// **Reusable Order Detail Row**
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
              : Text(text,
              style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  /// **Animated Pulsating Notification Icon**
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

  /// **Handles Back Button Press**
  Future<bool> _onWillPop() async {
    final currentTime = DateTime.now();
    if (lastBackPressedTime == null ||
        currentTime.difference(lastBackPressedTime!) > Duration(seconds: 2)) {
      lastBackPressedTime = currentTime;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Press back again to exit the app")),
      );
      return false;
    }
    return true;
  }
}
