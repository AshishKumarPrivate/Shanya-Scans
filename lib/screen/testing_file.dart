// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../ui_helper/responsive_helper.dart';
// import '../../../ui_helper/app_colors.dart';
// import '../../../ui_helper/app_text_styles.dart';
// import '../../../base_widgets/common/home_service_shimmer.dart';
// import 'package:healthians/screen/service/controller/service_scans_provider.dart';
// import 'package:healthians/screen/service/service_detail_list.dart';
//
// class HomeServicesSection extends StatefulWidget {
//   final String? sectionHeading;
//
//   const HomeServicesSection({
//     Key? key,
//     this.sectionHeading,
//   }) : super(key: key);
//
//   @override
//   State<HomeServicesSection> createState() => _HomeServicesSectionState();
// }
//
// class _HomeServicesSectionState extends State<HomeServicesSection> {
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final provider = Provider.of<ServiceApiProvider>(context, listen: false);
//     if (provider.scanList.isEmpty) {
//       provider.loadCachedPackages();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final double screenWidth = MediaQuery.of(context).size.width;
//     final double screenHeight = MediaQuery.of(context).size.height;
//     final double radius = ResponsiveHelper.containerWidth(context, 13);
//     final double circleRadius = radius;
//
//     // Dynamically determine columns based on available screen width & height
//     int columns;
//     if (screenHeight < 500) {
//       columns = 1; // Reduce columns in split-screen or small screens
//     } else if (ResponsiveHelper.isDesktop(context)) {
//       columns = 3;
//     } else if (ResponsiveHelper.isTablet(context)) {
//       columns = 2;
//     } else {
//       columns = screenWidth < 600 ? 2 : 3;
//     }
//
//     double childAspectRatio = ResponsiveHelper.isMobile(context) ? 0.92 : 1.1;
//
//     return Container(
//       color: AppColors.lightBlueColor,
//       padding: const EdgeInsets.all(8.0),
//       child: Container(
//         color: AppColors.whiteColor,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             ResponsiveHelper.sizeBoxHeightSpace(context, 2),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 5.0),
//               child: Text(
//                 widget.sectionHeading ?? "",
//                 style: AppTextStyles.heading1(
//                   context,
//                   overrideStyle: TextStyle(
//                     fontSize: ResponsiveHelper.fontSize(context, 14),
//                   ),
//                 ),
//               ),
//             ),
//             ResponsiveHelper.sizeBoxHeightSpace(context, 1),
//
//             Consumer<ServiceApiProvider>(
//               builder: (context, provider, child) {
//                 final services = provider.scanList;
//
//                 return LayoutBuilder(
//                   builder: (context, constraints) {
//                     return Flexible(
//                       child: SizedBox(
//                         height: constraints.maxHeight, // Dynamically adjust height
//                         child: provider.isLoading && services.isEmpty
//                             ? HomeServiceShimmer(itemCount: 10)
//                             : provider.errorMessage.isNotEmpty
//                             ? Center(
//                           child: SizedBox(
//                             width: ResponsiveHelper.containerWidth(context, 50),
//                             height: ResponsiveHelper.containerWidth(context, 50),
//                             child: Image.asset(
//                               "assets/images/img_error.jpg",
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         )
//                             : GridView.builder(
//                           shrinkWrap: true,
//                           physics: const ClampingScrollPhysics(),
//                           scrollDirection: Axis.horizontal,
//                           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                             crossAxisCount: columns,
//                             crossAxisSpacing: 8.0,
//                             mainAxisSpacing: 8.0,
//                             childAspectRatio: childAspectRatio,
//                           ),
//                           itemCount: services.length,
//                           itemBuilder: (context, index) {
//                             final item = services[index];
//                             return _buildGridItem(context, item, circleRadius, screenWidth);
//                           },
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//
//             ResponsiveHelper.sizeBoxHeightSpace(context, 1),
//           ],
//         ),
//       ),
//     );
//   }
//
//   /// Builds individual grid items
//   Widget _buildGridItem(BuildContext context, dynamic item, double circleRadius, double screenWidth) {
//     return Stack(
//       alignment: Alignment.topCenter,
//       children: <Widget>[
//         Padding(
//           padding: EdgeInsets.only(top: circleRadius / 2.0),
//           child: Padding(
//             padding: const EdgeInsets.only(bottom: 8.0),
//             child: InkWell(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => AllServicesDetailListScreen(
//                       serviceName: item.serviceDetailName.toString(),
//                       serviceSlug: item.slug ?? "",
//                       serviceDescription: item.serviceDetail ?? "",
//                       servicePhoto: item.servicePhoto!.secureUrl ?? "",
//                     ),
//                   ),
//                 );
//               },
//               splashColor: AppColors.primary.withOpacity(0.2),
//               highlightColor: AppColors.primary.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(10),
//               child: Container(
//                 width: screenWidth * 0.5,
//                 height: screenWidth * 0.25,
//                 decoration: BoxDecoration(
//                   color: AppColors.whiteColor,
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: Colors.white, width: 0),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 10,
//                       offset: const Offset(0, 2),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     SizedBox(height: ResponsiveHelper.containerHeight(context, 4.2)),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 5.0),
//                       child: Text(
//                         item.serviceDetailName.toString(),
//                         style: AppTextStyles.heading2(
//                           context,
//                           overrideStyle: TextStyle(
//                             fontSize: ResponsiveHelper.fontSize(context, 11),
//                             color: Colors.black,
//                           ),
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//         Material(
//           elevation: 2,
//           shape: const CircleBorder(),
//           child: Container(
//             width: circleRadius,
//             height: circleRadius,
//             decoration: const ShapeDecoration(
//               shape: CircleBorder(),
//               color: Colors.white,
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(3),
//               child: ClipOval(
//                 child: CachedNetworkImage(
//                   imageUrl: item.iconPhoto!.secureUrl.toString(),
//                   fit: BoxFit.cover,
//                   placeholder: (context, url) => Center(
//                     child: Image.asset("assets/images/img_placeholder.jpeg"),
//                   ),
//                   errorWidget: (context, url, error) => const Icon(
//                     Icons.error,
//                     color: Colors.red,
//                   ),
//                   fadeInDuration: const Duration(milliseconds: 500),
//                   fadeOutDuration: const Duration(milliseconds: 300),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
