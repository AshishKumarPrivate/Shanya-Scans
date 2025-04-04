import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui_helper/responsive_helper.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';
import '../../../base_widgets/common/home_service_shimmer.dart';
import 'package:healthians/screen/service/controller/service_scans_provider.dart';
import 'package:healthians/screen/service/service_detail_list.dart';

class HomeServicesSection extends StatefulWidget {
  final String? sectionHeading;

  const HomeServicesSection({
    Key? key,
    this.sectionHeading,
  }) : super(key: key);

  @override
  State<HomeServicesSection> createState() => _HomeServicesSectionState();
}

class _HomeServicesSectionState extends State<HomeServicesSection> {
  // @override
  // void initState() {
  //   super.initState();
  //
  //   // Ensure API call is triggered only once when the screen is first opened
  //   Future.microtask(() {
  //     final provider = Provider.of<ServiceApiProvider>(context, listen: false);
  //     provider.loadCachedPackages();
  //   });
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final provider = Provider.of<ServiceApiProvider>(context, listen: false);
    if (provider.scanList.isEmpty) {

      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.loadCachedPackages(); // Ensure data is loaded
      });

      // provider.loadCachedPackages(); // Ensure data is loaded
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double radius = ResponsiveHelper.containerWidth(context, 13);
    final double circleRadius = radius;

    // Responsive column calculation using ResponsiveText helper
    int columns;
    if (ResponsiveHelper.isDesktop(context)) {
      columns = 3; // Desktop: 6 columns
    } else if (ResponsiveHelper.isTablet(context)) {
      columns = 2; // Tablet: 4 columns
      if (screenWidth > 1300 && screenWidth < 1880) {
        columns = 2; // Tablet: 4 columns
      }
      // columns = screenWidth >1300 && screenWidth <1880  ? 3 : ResponsiveText.isDesktop(context) ?  2  : 6        ;
    } else {
      // Mobile: further adjust based on screen width
      columns = screenWidth > 300 && screenWidth < 600
          ? 3
          : ResponsiveHelper.isDesktop(context)
              ? 2
              : 6;
    }

    // Responsive childAspectRatio adjustment
    double childAspectRatio = ResponsiveHelper.isMobile(context) ? 0.92 : 1.1;

    return Container(
      color: AppColors.lightBlueColor,
      padding: const EdgeInsets.all(8.0),
      child: Container(
        color: AppColors.whiteColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResponsiveHelper.sizeBoxHeightSpace(context, 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5.0),
              child: Text(
                widget.sectionHeading ?? "",
                style: AppTextStyles.heading1(
                  context,
                  overrideStyle: TextStyle(
                    fontSize: ResponsiveHelper.fontSize(context, 14),
                  ),
                ),
              ),
            ),

            ResponsiveHelper.sizeBoxHeightSpace(context, 1),

            // Consumer listens for provider changes and updates UI
            Consumer<ServiceApiProvider>(
              builder: (context, provider, child) {
                final services = provider.scanList;

                return SizedBox(
                  // this is the sizebox for the service main height
                  width: ResponsiveHelper.containerHeight(context, 100),
                  height: 360,
                  // height: ResponsiveHelper.containerHeight(context, 40),
                  child: provider.isLoading && services.isEmpty
                      ? HomeServiceShimmer(
                          itemCount: 10) // ✅ Show shimmer only when no cache
                      : provider.errorMessage.isNotEmpty // ✅ Error condition
                          ? Center(
                              child: SizedBox(
                                width: ResponsiveHelper.containerWidth(
                                    context, 50),
                                height: ResponsiveHelper.containerWidth(
                                    context, 50),
                                child: Image.asset(
                                  "assets/images/img_error.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          // : services.isEmpty // ✅ Handle empty list separately
                          //     ? Center(
                          //         child: SizedBox(
                          //           width: ResponsiveHelper.containerWidth(
                          //               context, 50),
                          //           height: ResponsiveHelper.containerWidth(
                          //               context, 50),
                          //           child: Image.asset(
                          //             "assets/images/img_error.jpg",
                          //             fit: BoxFit.cover,
                          //           ),
                          //         ),
                          //       )
                          : GridView.builder(
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                crossAxisSpacing: 8.0,
                                mainAxisSpacing: 8.0,
                                childAspectRatio: childAspectRatio,
                              ),
                              itemCount: services.length,
                              itemBuilder: (context, index) {
                                final item = services[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>  AllServicesDetailListScreen(
                                          serviceName: item.serviceDetailName! .toString(),
                                          serviceSlug: item.slug! ?? "",
                                          serviceDescription: item.serviceDetail! ?? "",
                                          servicePhoto: item.servicePhoto!.secureUrl! ??
                                                  "",
                                        ),
                                      ),
                                    );
                                  },
                                  splashColor: AppColors.primary.withAlpha(50),
                                  highlightColor:
                                      AppColors.primary.withAlpha(50),
                                  borderRadius: BorderRadius.circular(10),
                                  child: Stack(
                                    alignment: Alignment.topCenter,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            top: circleRadius / 2.0),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 8.0),
                                          child: Container(
                                            width: screenWidth * 0.5,
                                            height: screenWidth * 0.25,
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
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                            child: Column(
                                              children: [
                                                // SizedBox( height: ResponsiveHelper .containerHeight( context, 4.2)),
                                                SizedBox(height: 35),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 5.0),
                                                  child: Text(
                                                    "${item.serviceDetailName.toString()}",
                                                    style:
                                                        AppTextStyles.heading2(
                                                      context,
                                                      overrideStyle: TextStyle(
                                                        fontSize:
                                                            ResponsiveHelper
                                                                .fontSize(
                                                                    context,
                                                                    11),
                                                        color: Colors.black,
                                                      ),
                                                    ),
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
                                      ),
                                      Material(
                                        elevation: 2,
                                        shape: const CircleBorder(),
                                        child: Container(
                                          width: circleRadius,
                                          height: circleRadius,
                                          decoration: const ShapeDecoration(
                                            shape: CircleBorder(),
                                            color: Colors.white,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(3),
                                            child: ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: item
                                                    .iconPhoto!.secureUrl
                                                    .toString(),
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child: Image.asset(
                                                      "assets/images/img_placeholder.jpeg"), // Placeholder while loading
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(
                                                  Icons.error,
                                                  color: Colors
                                                      .red, // Show error icon if image fails
                                                ),
                                                fadeInDuration: const Duration(
                                                    milliseconds: 500),
                                                // Smooth fade-in effect
                                                fadeOutDuration: const Duration(
                                                    milliseconds: 300),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                );
              },
            ),

            ResponsiveHelper.sizeBoxHeightSpace(context, 1),
          ],
        ),
      ),
    );
  }
}
