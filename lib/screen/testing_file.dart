// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
// import 'package:shimmer/shimmer.dart';
// import '../../ui_helper/app_colors.dart';
// import '../controller/DeliveryOrdersProvider.dart';
// import 'widget/DeliveryOrderList.dart';
//
// class DeliveryBoyDashboardScreen extends StatefulWidget {
//   @override
//   _DeliveryBoyDashboardScreenState createState() => _DeliveryBoyDashboardScreenState();
// }
//
// class _DeliveryBoyDashboardScreenState extends State<DeliveryBoyDashboardScreen>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: AppColors.deliveryPrimary,
//       statusBarIconBrightness: Brightness.light,
//     ));
//
//     final provider = Provider.of<DeliveryOrdersProvider>(context, listen: false);
//     provider.initializeSocket();
//     _tabController = TabController(length: 3, vsync: this);
//     _fetchOrdersForTab(0);
//   }
//
//   @override
//   void dispose() {
//     Provider.of<DeliveryOrdersProvider>(context, listen: false).disconnectSocket();
//     _tabController.dispose();
//     super.dispose();
//   }
//
//   void _fetchOrdersForTab(int index) {
//     final provider = Provider.of<DeliveryOrdersProvider>(context, listen: false);
//     String status = index == 0 ? "confirmed" : index == 1 ? "ongoing" : "completed";
//     provider.fetchDeliveryBoyOrderList(status);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.deliveryPrimary,
//       body: SafeArea(
//         child: NestedScrollView(
//           headerSliverBuilder: (context, innerBoxIsScrolled) => [
//             SliverToBoxAdapter(
//               child: Consumer<DeliveryOrdersProvider>(
//                 builder: (context, provider, _) {
//                   return _buildOrderSummary(provider.newOrderAssigned, provider);
//                 },
//               ),
//             ),
//             SliverToBoxAdapter(child: _buildDashboardSummary()),
//             SliverPersistentHeader(
//               pinned: true,
//               delegate: _SliverAppBarDelegate(
//                 TabBar(
//                   controller: _tabController,
//                   labelColor: Colors.white,
//                   indicatorColor: Colors.white,
//                   tabs: [
//                     Tab(text: "Pending"),
//                     Tab(text: "Ongoing"),
//                     Tab(text: "Delivered"),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//           body: TabBarView(
//             controller: _tabController,
//             children: [
//               DeliveryOrderList(status: "confirmed"),
//               DeliveryOrderList(status: "ongoing"),
//               DeliveryOrderList(status: "completed"),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildDashboardSummary() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: GridView.count(
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         crossAxisCount: 2,
//         crossAxisSpacing: 12,
//         mainAxisSpacing: 12,
//         childAspectRatio: 1.5,
//         children: [
//           _buildSummaryCard("Completed", "27", Icons.check_circle, Colors.green.shade100),
//           _buildSummaryCard("Pending", "10", Icons.timer, Colors.yellow.shade100),
//           _buildSummaryCard("Cancelled", "05", Icons.cancel, Colors.red.shade100),
//           _buildSummaryCard("Returned", "16", Icons.replay, Colors.blue.shade100),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSummaryCard(String title, String count, IconData icon, Color color) {
//     return Container(
//       decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 30, color: Colors.black54),
//           SizedBox(height: 8),
//           Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//           SizedBox(height: 4),
//           Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildOrderSummary(bool newOrderAssigned, DeliveryOrdersProvider provider) {
//     return Visibility(
//       visible: newOrderAssigned,
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(12),
//         margin: EdgeInsets.all(10),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.blue.shade700, Colors.purple.shade400],
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//           ),
//           borderRadius: BorderRadius.circular(16),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text("New Order Assigned!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//                 IconButton(icon: Icon(Icons.close, color: Colors.white), onPressed: () => provider.resetNewOrderNotification()),
//               ],
//             ),
//             SizedBox(height: 10),
//             Shimmer.fromColors(
//               baseColor: Colors.white,
//               highlightColor: Colors.yellowAccent,
//               child: Row(
//                 children: [
//                   Icon(Icons.delivery_dining, color: Colors.greenAccent, size: 22),
//                   SizedBox(width: 6),
//                   Text("You have a new delivery order!", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
//   final TabBar tabBar;
//
//   _SliverAppBarDelegate(this.tabBar);
//
//   @override
//   double get minExtent => tabBar.preferredSize.height;
//   @override
//   double get maxExtent => tabBar.preferredSize.height;
//
//   @override
//   Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
//     return Container(
//       color: AppColors.deliveryPrimary,
//       child: tabBar,
//     );
//   }
//
//   @override
//   bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
//     return false;
//   }
// }
