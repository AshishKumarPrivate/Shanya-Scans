// import 'package:flutter/material.dart';
//
// class DeliveryDashboardScreen extends StatefulWidget {
//   @override
//   State<DeliveryDashboardScreen> createState() => _DeliveryDashboardScreenState();
// }
//
// class _DeliveryDashboardScreenState extends State<DeliveryDashboardScreen> {
//   bool isOnline = true;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Dashboard"),
//         leading: Icon(Icons.menu),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.notifications_none),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             /// Profile Card
//             Card(
//               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text("John Doe", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//                           SizedBox(height: 4),
//                           Text("johndoe@webkul.com", style: TextStyle(color: Colors.grey[700])),
//                           SizedBox(height: 2),
//                           Text("+919876543210", style: TextStyle(color: Colors.grey[700])),
//                           SizedBox(height: 12),
//                           Row(
//                             children: [
//                               Text("Your Presence Online", style: TextStyle(fontSize: 14)),
//                               Spacer(),
//                               Switch(
//                                 value: isOnline,
//                                 onChanged: (val) {
//                                   setState(() {
//                                     isOnline = val;
//                                   });
//                                 },
//                                 activeColor: Colors.green,
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                     Image.asset(
//                       'assets/images/delivery.png',
//                       height: 60,
//                       width: 60,
//                     )
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//
//             /// Menu Options
//             _buildMenuItem("Accept Orders", Icons.arrow_forward_ios),
//             _buildMenuItem("Pending Orders", Icons.access_time),
//             _buildMenuItem("Completed Orders", Icons.check_circle_outline),
//             SizedBox(height: 20),
//
//             /// Summary Cards
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 _buildSummaryCard("\$16.0", "Due Amount", Colors.red.shade100),
//                 _buildSummaryCard("231", "Orders Delivered", Colors.green.shade100),
//                 _buildSummaryCard("\$118.0", "Total Earning", Colors.yellow.shade100),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildMenuItem(String title, IconData icon) {
//     return Container(
//       margin: EdgeInsets.only(bottom: 12),
//       padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Row(
//         children: [
//           Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
//           Spacer(),
//           Icon(icon, size: 18, color: Colors.black),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildSummaryCard(String value, String label, Color bgColor) {
//     return Expanded(
//       child: Container(
//         margin: EdgeInsets.symmetric(horizontal: 4),
//         padding: EdgeInsets.all(12),
//         decoration: BoxDecoration(
//           color: bgColor,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           children: [
//             Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             SizedBox(height: 4),
//             Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
//           ],
//         ),
//       ),
//     );
//   }
// }
