import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthians/base_widgets/common/custom_nav_scan_app_bar.dart';
import 'package:healthians/base_widgets/common/scans_service_shimmer.dart';
import 'package:healthians/screen/service/service_detail_list.dart';
import 'package:healthians/ui_helper/responsive_helper.dart';
import 'package:provider/provider.dart';

import '../../base_widgets/common/home_service_shimmer.dart';
import '../../base_widgets/common/nav_common_app_bar.dart';
import '../../ui_helper/app_colors.dart';
import '../../ui_helper/app_text_styles.dart';
import '../../base_widgets/common/common_app_bar.dart';
import '../nav/nav_home/home_slider_setion.dart';
import '../service/controller/service_scans_provider.dart';

class ScanScreen extends StatefulWidget {
  ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final List<Map<String, String>> items = [
    {'image': 'assets/images/digitalpetct.png', 'title': 'Digital PET CT'},
    {'image': 'assets/images/thyroid_service.png', 'title': 'Thyroid'},
    {'image': 'assets/images/ct_scan.png', 'title': 'CT Scan'},
    {'image': 'assets/images/digitalgamma.png', 'title': 'Digital Gamma'},
    {'image': 'assets/images/dexascan.png', 'title': 'Dexa Scan'},
    {'image': 'assets/images/mammography.png', 'title': 'Mammography'},
    {'image': 'assets/images/theranostics.png', 'title': 'Theranostics'},
    {'image': 'assets/images/ultrasound_service.png', 'title': 'Ultrasound'},
    {'image': 'assets/images/cardioimaging.png', 'title': 'Cardio Imaging'},
    {'image': 'assets/images/neuro.png', 'title': 'Neuro Imaging'},
    {'image': 'assets/images/xray_service.png', 'title': 'Digital X-Ray '},
    {'image': 'assets/images/pathalogy.png', 'title': 'Pathalogy'},
  ];

  @override
  void initState() {
    super.initState();
    // Fetch API data when the widget is initialized
    // Future.microtask(() =>
    //     Provider.of<ServiceApiProvider>(context, listen: false)
    //         .checkCachedData());
    Future.microtask(() =>
        Provider.of<ServiceApiProvider>(context, listen: false)
            .loadCachedPackages());
  }

  @override
  Widget build(BuildContext context) {
    final double radius = ResponsiveHelper.containerWidth(context, 13);
    final double circleRadius = radius;
    final provider = Provider.of<ServiceApiProvider>(context);
    // final services = provider.homeServiceListModel?.data ?? []; // API response
    final services = provider.scanList;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
          child: Column(
            children: [
              // Header Row
              // CommonAppBar(
              //   aciviyName: "X-Rays & Scans",
              //   isNavigation: true,
              // ),
              NavCommonAppBar(
                aciviyName: "X-Rays & Scans",
                isNavigation: true,
                backgroundColor: AppColors.primary, // ✅ Change Background Color
                searchBarVisible: false,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Container(
                          width: double.infinity,
                          height: 200,
                          // height: ResponsiveHelper.containerHeight(context, 21),
                          // decoration: BoxDecoration(
                          //   gradient: LinearGradient(
                          //     colors: [
                          //       // Color(0xFFe3f2fd), // Light Color
                          //       // Color(0xFFe3f2fd), // Soft Blue Shade
                          //       // Color(0xFFe0f7fa), // Light Cyan Blue
                          //       // Color(0xFFb2ebf2), // Sky Blue
                          //
                          //       //// is somthing best
                          //       Color(0xFFe0f2f1), // Light Teal
                          //       Color(0xFFb2dfdb), // Mint Green-Teal
                          //       // its something best
                          //
                          //       // its so looking good
                          //       // Color(0xFFede7f6), // Light Purple
                          //       // Color(0xFFb3e5fc), // Soft Blue
                          //       /// looking good
                          //     ],
                          //     begin: Alignment.topLeft,
                          //     end: Alignment.bottomRight,
                          //   ),
                          // ),
                          child: HomeSliderSection(bannerImageHeight: 160,),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: provider.isLoading && services.isEmpty
                            ? ScansServiceShimmer(
                                itemCount:
                                    10) // ✅ Show shimmer only when no cache
                            : provider.errorMessage.isNotEmpty
                                ? Center(child: Text(provider.errorMessage))
                                : GridView.builder(
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3, // 3 columns
                                      crossAxisSpacing:
                                          8.0, // Space between columns
                                      mainAxisSpacing:
                                          0.0, // Removed spacing between rows
                                    ),
                                    // itemCount: provider.scanList.length,
                                    itemCount: services.length,
                                    itemBuilder: (context, index) {
                                      final item = services[index];
                                      return InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  AllServicesDetailListScreen(
                                                serviceSlug: item.slug ?? "",
                                                serviceName:
                                                    item.serviceDetailName ??
                                                        "",
                                                serviceDescription:
                                                    item.serviceDetail ?? "",
                                                servicePhoto: item
                                                    .servicePhoto!.secureUrl
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        splashColor: AppColors.whiteColor,
                                        highlightColor: AppColors.whiteColor,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: AppColors.whiteColor,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: Colors.white,
                                                width: 0,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  blurRadius: 10,
                                                  offset: Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                ResponsiveHelper
                                                    .sizeBoxHeightSpace(
                                                        context, 0.5),
                                                // Circular image
                                                Material(
                                                  elevation: 2,
                                                  // Add elevation for shadow effect
                                                  shape: CircleBorder(),
                                                  child: Container(
                                                    width: circleRadius,
                                                    height: circleRadius,
                                                    decoration:
                                                        const ShapeDecoration(
                                                      shape: CircleBorder(),
                                                      color: Colors.white,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5),
                                                      child: CachedNetworkImage(
                                                        imageUrl: item
                                                            .iconPhoto!
                                                            .secureUrl
                                                            .toString(),
                                                        fit: BoxFit.fill,
                                                        placeholder:
                                                            (context, url) =>
                                                                Center(
                                                          child: Image.asset(
                                                              "assets/images/img_placeholder.jpeg"), // Placeholder while loading
                                                        ),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Center(
                                                          child: Image.asset(
                                                              "assets/images/img_placeholder.jpeg"), // Placeholder while loading
                                                        ),
                                                        fadeInDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    500),
                                                        // Smooth fade-in effect
                                                        fadeOutDuration:
                                                            const Duration(
                                                                milliseconds:
                                                                    300),
                                                      ),

                                                      // DecoratedBox(
                                                      //   decoration: ShapeDecoration(
                                                      //     shape:
                                                      //         const CircleBorder(),
                                                      //     image: DecorationImage(
                                                      //       fit: BoxFit.fill,
                                                      //       image: NetworkImage(item
                                                      //           .iconPhoto!
                                                      //           .secureUrl
                                                      //           .toString()),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 8.0),
                                                // Space between image and text
                                                // Title text
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5.0),
                                                  child: Text(
                                                    "${item.serviceDetailName.toString()}",
                                                    style: AppTextStyles.heading1(
                                                        context,
                                                        overrideStyle: TextStyle(
                                                            fontSize:
                                                                ResponsiveHelper
                                                                    .fontSize(
                                                                        context,
                                                                        11))),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
