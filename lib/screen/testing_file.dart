// import 'package:animated_text_kit/animated_text_kit.dart';
// import 'package:carousel_slider/carousel_slider.dart'; // Unused, can be removed
// import 'package:flutter/material.dart';
// import 'package:shanya_scans/screen/cart/cart_list_screen.dart';
// import 'package:shanya_scans/ui_helper/responsive_helper.dart';
// import 'package:shanya_scans/ui_helper/app_colors.dart';
// import 'package:shanya_scans/ui_helper/app_text_styles.dart';
// import 'package:provider/provider.dart';
//
// import '../../../bottom_navigation_screen.dart';
// import '../../../ui_helper/storage_helper.dart';
// import '../../../util/config.dart'; // Import the updated ConfigUtils
// import '../../cart/controller/cart_list_api_provider.dart';
//
// class HomeToolbarSection extends StatefulWidget {
//   @override
//   State<HomeToolbarSection> createState() => _HomeToolbarSectionState();
// }
//
// class _HomeToolbarSectionState extends State<HomeToolbarSection> {
//   // int currentIndex = 0; // Unused
//   // final CarouselSliderController _controller = CarouselSliderController(); // Unused
//
//   String userName = StorageHelper().getUserName();
//   String userAddress = "Fetching location...";
//
//   // Get the singleton instance of ConfigUtils
//   final ConfigUtils _configUtils = ConfigUtils();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _loadUserAddress(); // Initial load
//
//       // Listen for changes in location service status
//       _configUtils.locationServiceStatusNotifier.addListener(_onLocationServiceStatusChanged);
//     });
//   }
//
//   @override
//   void dispose() {
//     _configUtils.locationServiceStatusNotifier.removeListener(_onLocationServiceStatusChanged);
//     super.dispose();
//   }
//
//   void _onLocationServiceStatusChanged() {
//     // This callback fires when location service status changes (e.g., enabled/disabled)
//     if (_configUtils.locationServiceStatusNotifier.value) {
//       // If location services are now enabled, try to get the address again
//       print("Location service status changed to ENABLED. Re-fetching address...");
//       _loadUserAddress(); // Re-attempt to get location
//     } else {
//       // If location services are disabled, update UI to reflect it
//       setState(() {
//         userAddress = "Location services disabled";
//       });
//     }
//   }
//
//   Future<void> _loadUserAddress() async {
//     final storageHelper = StorageHelper();
//     String? storedAddress = storageHelper.getUserLiveAddress();
//
//     if (storedAddress != null && storedAddress.isNotEmpty) {
//       setState(() {
//         userAddress = storedAddress;
//       });
//     } else {
//       await _fetchUserAddress();
//     }
//   }
//
//   Future<void> _fetchUserAddress() async {
//     final storageHelper = StorageHelper();
//     bool alreadyAcceptedDisclosure = storageHelper.isUserLocationDisclosureAccepted();
//
//     // Show disclosure dialog only if not accepted previously
//     if (!alreadyAcceptedDisclosure) {
//       bool accepted = await _showLocationDisclosureDialog(context);
//       if (!accepted) {
//         setState(() {
//           userAddress = "Location access denied";
//         });
//         return; // User denied disclosure, stop here.
//       }
//       await storageHelper.setUserLocationDisclosureAccepted(true);
//     }
//
//     // Attempt to get location using ConfigUtils
//     Map<String, dynamic> locationData = await _configUtils.getSingleLocation();
//
//     if (locationData.isNotEmpty && locationData.containsKey("address")) {
//       String address = locationData["address"];
//       storageHelper.setUserLiveAddress(address);
//       setState(() {
//         userAddress = address;
//       });
//     } else {
//       // ConfigUtils will have printed specific error messages.
//       // Here, we update the UI to a general "Unable to fetch" message.
//       setState(() {
//         // If locationServiceStatusNotifier is false, it means services are off or permission denied.
//         if (!_configUtils.locationServiceStatusNotifier.value) {
//           userAddress = "Location services off or denied";
//         } else {
//           userAddress = "Unable to fetch address";
//         }
//       });
//     }
//   }
//
//   Future<bool> _showLocationDisclosureDialog(BuildContext context) async {
//     bool userAccepted = false;
//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext ctx) {
//         return AlertDialog(
//           title: Text("Location Permission Required"),
//           content: Text(
//               "We use your device’s location to display your current address and improve your service experience. This data is used only while the app is open and will not be shared with third parties."
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 userAccepted = false;
//                 Navigator.of(ctx).pop();
//               },
//               child: Text("Deny"),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 userAccepted = true;
//                 Navigator.of(ctx).pop();
//               },
//               child: Text("Accept"),
//             ),
//           ],
//         );
//       },
//     );
//     return userAccepted;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: AppColors.primary,
//       child: Padding(
//         padding: ResponsiveHelper.padding(context, 3, 0.5),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: Padding(
//                     padding:  EdgeInsets.only(left: 5.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 "Hello, ${userName}",
//                                 style: AppTextStyles.heading1(
//                                   context,
//                                   overrideStyle: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.w900,
//                                       fontSize:
//                                       ResponsiveHelper.fontSize(context, 14)),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             Icon(
//                               Icons.location_pin,
//                               size: 18,
//                               color: Colors.white,
//                             ),
//                             SizedBox(
//                               width: 5,
//                             ),
//                             Expanded(
//                               child: Text(
//                                 userAddress,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                                 style: AppTextStyles.heading1(context,
//                                     overrideStyle: TextStyle(
//                                         color: Colors.white,
//                                         fontSize:
//                                         ResponsiveHelper.fontSize(context, 10))),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => CartListScreen(),
//                           ),
//                         );
//                       },
//                       child: Consumer<CartProvider>(
//                         builder: (context, cartProvider, child) {
//                           return Stack(
//                             children: [
//                               Container(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Icon(
//                                     color: Colors.white,
//                                     Icons.shopping_cart_checkout_outlined,
//                                     size: ResponsiveHelper.iconSize(
//                                         context, 24),
//                                   ),
//                                 ),
//                               ),
//                               if (cartProvider.cartItems.isNotEmpty)
//                                 Positioned(
//                                   right: 2,
//                                   top: -5,
//                                   child: Container(
//                                     padding: EdgeInsets.all(5),
//                                     decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       shape: BoxShape.circle,
//                                     ),
//                                     child: Text(
//                                       cartProvider.cartItems.length.toString(),
//                                       style: TextStyle(
//                                           color: Colors.white, fontSize: 10),
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             ResponsiveHelper.sizeBoxHeightSpace(context, 1.5),
//             // Search Bar
//             Center(
//               child: GestureDetector(
//                 onTap: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) =>BottomNavigationScreen(initialPageIndex: 1),
//                     ),
//                   );
//                 },
//                 child: Container(
//                   width: double.infinity,
//                   height: ResponsiveHelper.containerWidth(context, 10),
//                   padding: EdgeInsets.symmetric(horizontal: 10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10.0),
//                     border: Border.all(
//                         width: 0.4, color: AppColors.txtLightGreyColor),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.3),
//                         blurRadius: 1.0,
//                         offset: Offset(0, 2),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     children: [
//                       Icon(Icons.search, color: Colors.grey),
//                       SizedBox(width: 10),
//                       Expanded(
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.pushReplacement(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) =>
//                                     BottomNavigationScreen(initialPageIndex: 1),
//                               ),
//                             );
//                           },
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                               Padding(
//                                 padding: EdgeInsets.only(top: 0),
//                                 child: DefaultTextStyle(
//                                   style: TextStyle(
//                                     color: Colors.grey,
//                                     fontSize:
//                                     ResponsiveHelper.fontSize(context, 14),
//                                     fontWeight: FontWeight.bold,
//                                     height: 1.2,
//                                   ),
//                                   child: AnimatedTextKit(
//                                     repeatForever: true,
//                                     isRepeatingAnimation: true,
//                                     pause: Duration(milliseconds: 0),
//                                     animatedTexts: [
//                                       RotateAnimatedText( transitionHeight: 30.0,
//                                           duration: Duration(milliseconds: 2000),
//                                           'Search for CBC, X-ray, etc.'),
//                                       RotateAnimatedText( transitionHeight: 30.0,
//                                           duration: Duration(milliseconds: 2000),
//                                           'Find Lab Tests, MRI, CT Scan...'),
//                                       RotateAnimatedText( transitionHeight: 30.0,
//                                           duration: Duration(milliseconds: 2000),
//                                           'Search Your Health Test Here...'),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             ResponsiveHelper.sizeBoxHeightSpace(context, 0.5),
//           ],
//         ),
//       ),
//     );
//   }
// }