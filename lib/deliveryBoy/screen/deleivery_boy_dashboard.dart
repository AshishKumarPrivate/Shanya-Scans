import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthians/deliveryBoy/controller/delivery_boy_auth_provider.dart';
import 'package:healthians/deliveryBoy/screen/widget/DeliveryOrderList.dart';
import 'package:healthians/util/config.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../base_widgets/outlined_rounded_button.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../ui_helper/responsive_helper.dart';
import '../controller/DeliveryOrdersProvider.dart';
import 'SalesTrackingScreen.dart';

class DeliveryBoyDashboardScreen extends StatefulWidget {
  @override
  _DeliveryBoyDashboardScreenState createState() =>
      _DeliveryBoyDashboardScreenState();
}

class _DeliveryBoyDashboardScreenState extends State<DeliveryBoyDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  DateTime? lastBackPressedTime, _selectedDate;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.deliveryPrimary,
      statusBarIconBrightness: Brightness.light,
    ));

    final provider =
        Provider.of<DeliveryOrdersProvider>(context, listen: false);

    provider.fetchDeliveryBoyOrderSummary(); // Call API after build phase
    provider.initializeSocket(); // Initialize Socket.IO

    _tabController = TabController(length: 3, vsync: this);

    // Fetch orders based on tab selection
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _fetchOrdersForTab(_tabController.index);
      }
    });

    // Fetch initial tab orders (Pending by default)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchOrdersForTab(0); // Call API after build phase
    });
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: AppColors.deliveryPrimary,
      statusBarIconBrightness: Brightness.light,
    ));
    Provider.of<DeliveryOrdersProvider>(context, listen: false)
        .disconnectSocket();
    super.dispose();
  }

  void _fetchOrdersForTab(int index) {
    final provider =
        Provider.of<DeliveryOrdersProvider>(context, listen: false);
    if (index == 0) {
      provider.fetchDeliveryBoyOrderList("confirmed");
    } else if (index == 1) {
      provider.fetchDeliveryBoyOrderList("ongoing");
    } else if (index == 2) {
      provider.fetchDeliveryBoyOrderList("completed");
    }
  }

  // ✅ Handle Bottom Navigation Tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // ✅ List of Screens for Bottom Navigation
  final List<Widget> _screens = [
    DeliveryBoyDashboardScreen(), // Dashboard
    DeliveryBoyProfileScreen(), // Dashboard
    // Text("Orders Page"), // Replace with Orders Screen
    // Text("Profile Page"), // Replace with Profile Screen
  ];

  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColors.deliveryPrimary,
        statusBarIconBrightness: Brightness.light, // Ensure light icons
      ));
    });
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.deliveryPrimary, // Subtle background
        body: SafeArea(
          child: _selectedIndex == 0
              ? _buildDashboard() // Show Dashboard if selected
              : Center(child: _screens[_selectedIndex]), // Other screens
        ),

        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppColors.deliveryPrimary,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: "Dashboard"),
            BottomNavigationBarItem( icon: Icon(Icons.person), label: "Profile"),
            // BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return Container(
      color: Colors.white,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(
            child: Consumer<DeliveryOrdersProvider>(
              builder: (context, provider, _) {
                return _buildOrderSummary(provider.newOrderAssigned, provider);
              },
            ),
          ),
          SliverToBoxAdapter(child: _buildDashboardSummary()),
          // ✅ FIXED USAGE
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverAppBarDelegate(_buildTabs()),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            DeliveryOrderList(status: "confirmed"),
            DeliveryOrderList(status: "ongoing"),
            DeliveryOrderList(status: "completed"),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardSummary() {
    return Consumer<DeliveryOrdersProvider>(
      builder: (context, provider, _) {
        // Handle error message
        if (provider.errorMessage.isNotEmpty) {
          return Center(
            child: Text(provider.errorMessage,
                style: TextStyle(color: Colors.red)),
          );
        }

        final summary = provider.deliveryBoyOrderSummaryModel?.data;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            // Prevents GridView scrolling
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.5,
            children: [
              _buildSummaryCard(
                  "Pending Delivery",
                  summary?.todayOngoingBookings ?? "0",
                  Icons.timer,
                  Colors.yellow.shade100),
              _buildSummaryCard(
                  "Cancel Delivery",
                  summary?.todayOngoingBookings ?? "0",
                  Icons.cancel,
                  Colors.red.shade100),
              _buildSummaryCard(
                  "Return Delivery",
                  summary?.todayOngoingBookings ?? "0",
                  Icons.replay,
                  Colors.blue.shade100),
              _buildSummaryCard(
                  "Complete Delivered",
                  summary?.totalBookings ?? "0",
                  Icons.check_circle,
                  Colors.green.shade100),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSummaryCard(
      String title, dynamic count, IconData icon, Color color) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width = constraints.maxWidth;
        double cardPadding = width * 0.04; // Dynamic padding
        double iconSize = 25; // Responsive icon size
        double textSize = ResponsiveHelper.fontSize(context, 14);

        return InkWell(
          onTap: () {
            Provider.of<DeliveryOrdersProvider>(context, listen: false).callEmit();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SalesLiveTrackingScreen(),
              ),
            );
          },
          child: SizedBox(
            width: ResponsiveHelper.containerWidth(context, 1), // Adjust width dynamically
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10), // Responsive border radius
              ),
              padding: EdgeInsets.all(cardPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: iconSize, color: Colors.black54),
                  SizedBox(height: cardPadding * 0.5),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.heading1(
                      context,
                      overrideStyle: TextStyle(
                        fontSize: textSize,
                      ),
                    ),
                  ),
                  SizedBox(height: cardPadding * 0.3),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: Text(
                      count.toString(),
                      key: ValueKey(count),
                      style: AppTextStyles.heading1(
                        context,
                        overrideStyle: TextStyle(
                          fontSize: textSize,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  /// **Custom Header with Order Summary Above Tabs**
  /// **Custom Header with Order Summary Above Tabs**
  Widget _buildOrderSummary(
      bool newOrderAssigned, DeliveryOrdersProvider provider) {
    return Visibility(
      visible: newOrderAssigned, // Show only when new order is assigned
      child: Container(
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
            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "New Order Assigned!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    provider
                        .resetNewOrderNotification(); // Hide the notification
                  },
                ),
              ],
            ),
            SizedBox(height: 10),

            // Shimmer Notification Effect
            Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: Colors.yellowAccent,
              child: Row(
                children: [
                  Icon(Icons.delivery_dining,
                      color: Colors.greenAccent, size: 22),
                  SizedBox(width: 6),
                  Text(
                    "You have a new delivery order!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Build Tab Bar**
  TabBar _buildTabs() {
    return TabBar(
      dividerColor: Colors.white,
      controller: _tabController,
      labelColor: Colors.white,
      indicatorColor: Colors.transparent,
      unselectedLabelColor: Colors.black54,
      labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
      indicator: BoxDecoration(
        color: AppColors.deliveryPrimary,
        borderRadius: BorderRadius.circular(8),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: [
        Tab(text: "Pending"),
        Tab(text: "Ongoing"),
        Tab(text: "Delivered"),
      ],
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
              : Text(text, style: TextStyle(fontSize: 16, color: Colors.white)),
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
    SystemNavigator.pop(); // Close the app

    return false;
    // return true;
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverAppBarDelegate(this.tabBar);

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: Colors.white, // Background color for the TabBar
        padding: EdgeInsets.symmetric(horizontal: 8), // Adjust spacing
        child: tabBar, // Use the TabBar directly
      ),
    );
  }

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}

class DeliveryBoyProfileScreen extends StatefulWidget {
  @override
  _DeliveryBoyProfileScreenState createState() =>
      _DeliveryBoyProfileScreenState();
}

class _DeliveryBoyProfileScreenState extends State<DeliveryBoyProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DeliveryOrdersProvider>(context, listen: false)
          .fetchDeliveryBoyProfileSummary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: Consumer<DeliveryOrdersProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (userProvider.deliveryBoyProfileSummaryModel == null) {
            return Center(child: Text("No data available"));
          }

          var profile = userProvider.deliveryBoyProfileSummaryModel!.data;
          return SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User Info Card
                Container(
                  width: double.infinity,
                  child: Card(
                    color: Colors.white,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            profile?.name ?? "N/A",
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Email: ${profile?.email ?? "N/A"}",
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width:
                    ResponsiveHelper.containerWidth(context, 30),
                    height:
                    ResponsiveHelper.containerWidth(context, 8),
                    child: OutlinedRoundedButton(
                      text: 'Logout',
                      borderWidth: 0.2,
                      icon: Icon(
                        Icons.logout,
                        color: Colors.red,
                      ),
                      color: Colors.red,
                      borderColor: Colors.red,
                      borderRadius: 10.0,
                      onPressed: () {
                        showLogoutBottomSheet(context);
                        print('Button clicked!');
                      },
                      textStyle: TextStyle(fontSize: 18),
                      // icon: Icon(Icons.touch_app, color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Order List
                // Text(
                //   "Order History",
                //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                // ),
                // SizedBox(height: 8),
                Visibility(
                  visible: false,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: profile?.orderDetails?.length ?? 0,
                    itemBuilder: (context, index) {
                      var order = profile!.orderDetails![index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Order: ${order.orderName}",
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text("Patient: ${order.patientName}"),
                              Text("Age: ${order.patientAge}"),
                              Text("Order Type: ${order.orderType}"),
                              Text("Price: ₹${order.orderPrice}"),
                              Text("Booking Status: ${order.bookingStatus}",
                                  style: TextStyle(
                                      color: order.bookingStatus == "completed"
                                          ? Colors.green
                                          : Colors.red)),
                              Text("Report Status: ${order.reportStatus}"),
                              Text("Order Date: ${order.orderDateTime}"),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showLogoutBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// **Red Warning Icon**
              Container(
                width: 100,
                height: 5,
                color: Colors.grey[400],
              ),

              Container(
                width: double.infinity,
                // color: Colors.grey,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 50,
                      ),
                      const SizedBox(height: 10),

                      /// **Sign Out Text**
                      Text(
                        "Sign out from Account",
                        style: AppTextStyles.bodyText1(context,
                            overrideStyle: new TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            )),
                      ),
                      const SizedBox(height: 8),

                      /// **Confirmation Message**
                      Text(
                        "Are you sure you would like to signout of your Account",
                        textAlign: TextAlign.start,
                        style: AppTextStyles.bodyText1(context,
                            overrideStyle: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            )),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              /// **Cancel & Logout Buttons**
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// **Cancel Button**
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.lightBrown_color,
                      // Light background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                    ),
                    child: Text(
                      "Cancel",
                      style: AppTextStyles.heading1(context,
                          overrideStyle: new TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                  ),

                  /// **Logout Button**
                  ElevatedButton(
                    onPressed: () async {
                      Provider.of<DeliveryBoyAuthApiProvider>(context, listen: false)
                          .logoutUser(context);
                      // **Storage se logout & async process complete hone ka wait karein**
                      // await StorageHelper().logout();
                      // // **Bottom Sheet Close karein**
                      // Navigator.pop(context);
                      // // **Navigate to LoginScreen & Remove All Screens**
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(builder: (context) => LoginScreen()),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange, // Orange button
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                    ),
                    child: Text(
                      "Logout",
                      style: AppTextStyles.heading1(context,
                          overrideStyle: new TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          )),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
