import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/nav/nav_home/slider/controller/home_banner_api_provider.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../../base_widgets/custom_rounded_container.dart';
import '../../../ui_helper/app_colors.dart';
import '../../../ui_helper/app_text_styles.dart';

class HomeStatsSection extends StatefulWidget {
  @override
  State<HomeStatsSection> createState() => _HomeStatsSectionState();
}

class _HomeStatsSectionState extends State<HomeStatsSection> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();



  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<HomeBannerApiProvider>(context, listen: false)
          .loadCachedBanners();
    });
  }

  @override
  Widget build(BuildContext context) {
    // return Consumer<HomeBanner2ApiProvider>(
    //   builder: (context, provider, child) {
    //     if (provider.isLoading) {
    //       return HomeSliderShimmer();
    //     } else if (provider.errorMessage.isNotEmpty) {
    //       return Center(
    //           child: Text(provider.errorMessage,
    //               style: TextStyle(color: Colors.red)));
    //     }
    //
    //     final homeBannerList =
    //         provider.homeBanner2ListModel?.data ?? [];
    //
    //     if (homeBannerList.isEmpty) {
    //       return Center(child: Text("No health concerns available"));
    //     }
    //
    //     return Container(
    //       padding: ResponsiveHelper.padding(context, 0, 0.8),
    //       width: double.infinity,
    //       child: Column(
    //         children: [
    //
    //         ],
    //       ),
    //     );
    //   },
    // );

    return Container(
      color: AppColors.lightBlueColor,
      padding: ResponsiveHelper.padding(context, 0, 0.8),
      height: ResponsiveHelper.containerWidth(context, 50),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    // color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0),
                          child: CustomRoundedContainer(
                            // onTap: () => openWhatsApp(),
                            borderRadius: 5,
                            borderColor: AppColors.whiteColor,
                            borderWidth: 0,
                            elevation: 0,
                            backgroundColor: Colors.white,
                            child: SizedBox(
                              width: ResponsiveHelper.containerWidth(
                                  context, 10),
                              height: ResponsiveHelper.containerWidth(
                                  context, 10),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Image.asset(
                                  "assets/images/navicon/nav_lab_fill.png",
                                  fit: BoxFit.cover,
                                  color: Colors.pink,
                                  // width: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                "50000+",
                                style: AppTextStyles.bodyText2(context,
                                    overrideStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 18),
                                    )),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "Tests Conducted",
                                style: AppTextStyles.bodyText2(context,
                                    overrideStyle: TextStyle(
                                      color: Colors.blue,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 14),
                                    )),
                              ),

                            ],
                          ),
                        ),
                        // const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    // color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0),
                          child: CustomRoundedContainer(
                            // onTap: () => openWhatsApp(),
                            borderRadius: 5,
                            borderColor: AppColors.whiteColor,
                            borderWidth: 0,
                            elevation: 0,
                            backgroundColor: Colors.white,
                            child: SizedBox(
                              width: ResponsiveHelper.containerWidth(
                                  context, 10),
                              height: ResponsiveHelper.containerWidth(
                                  context, 10),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Image.asset(
                                  "assets/images/navicon/nav_lab_fill.png",
                                  fit: BoxFit.cover,
                                  color: Colors.pink,
                                  // width: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                "2+",
                                style: AppTextStyles.bodyText2(context,
                                    overrideStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 18),
                                    )),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "Years of Excellence",
                                style: AppTextStyles.bodyText2(context,
                                    overrideStyle: TextStyle(
                                      color: Colors.blue,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 14),
                                    )),
                              ),

                            ],
                          ),
                        ),
                        // const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    // color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5.0),
                          child: CustomRoundedContainer(
                            // onTap: () => openWhatsApp(),
                            borderRadius: 5,
                            borderColor: AppColors.whiteColor,
                            borderWidth: 0,
                            elevation: 0,
                            backgroundColor: Colors.white,
                            child: SizedBox(
                              width: ResponsiveHelper.containerWidth(
                                  context, 10),
                              height: ResponsiveHelper.containerWidth(
                                  context, 10),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Image.asset(
                                  "assets/images/navicon/nav_lab_fill.png",
                                  fit: BoxFit.cover,
                                  color: Colors.pink,
                                  // width: 50,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                "1500+",
                                style: AppTextStyles.bodyText2(context,
                                    overrideStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 18),
                                    )),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "Tests Available",
                                style: AppTextStyles.bodyText2(context,
                                    overrideStyle: TextStyle(
                                      color: Colors.blue,
                                      fontSize: ResponsiveHelper.fontSize(
                                          context, 14),
                                    )),
                              ),

                            ],
                          ),
                        ),
                        // const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ])
        ],
      ),
    );
  }
}

class HomeSliderShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      width: double.infinity,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFffff),
              Color(0xFFffff),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0.4, 0.7],
            tileMode: TileMode.repeated,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: ResponsiveHelper.containerWidth(context, 30),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    width: ResponsiveHelper.containerWidth(context, 100),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: ResponsiveHelper.containerWidth(
                                    context, 17),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.white.withAlpha(150),
                                      blurRadius: 10,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: double.infinity,
                                    height: ResponsiveHelper.containerWidth(
                                        context, 30),
                                    color: Colors.grey[300],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
