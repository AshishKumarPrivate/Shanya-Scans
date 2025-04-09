import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shanya_scans/screen/nav/nav_home/slider/controller/home_banner_api_provider.dart';
import 'package:shanya_scans/ui_helper/responsive_helper.dart';
import 'package:provider/provider.dart';
import 'package:shanya_scans/util/image_loader_util.dart';
import 'package:shimmer/shimmer.dart';

import '../../../bottom_navigation_screen.dart';

class HomeSlider2Section extends StatefulWidget {
  @override
  State<HomeSlider2Section> createState() => _HomeSlider2SectionState();
}

class _HomeSlider2SectionState extends State<HomeSlider2Section> {
  int currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.microtask(() {
      Provider.of<HomeBannerApiProvider>(context, listen: false)
          .loadCachedBanners1();
    });
  }

  void _navigateToBottomNav(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BottomNavigationScreen(initialPageIndex: index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeBannerApiProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading  && provider.homeBanner2ListModel== null ) {
          return HomeSliderShimmer();
        } else if (provider.errorMessage.isNotEmpty) {
          return SizedBox();// API error case: Hide section

          //   Center(
          //   child: SizedBox(
          //     width: ResponsiveHelper.containerWidth(context, 50),
          //     height: ResponsiveHelper.containerWidth(context, 50),
          //     child: Image.asset(
          //       "assets/images/img_error.jpg",
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // );
        }

        final homeBannerList = provider.homeBanner2ListModel?.data ?? [];

        if (homeBannerList.isEmpty) {
          return SizedBox(); // **No data case: Hide section**
            Center(
            child: SizedBox(
              width: ResponsiveHelper.containerWidth(context, 50),
              height: ResponsiveHelper.containerWidth(context, 50),
              child: Image.asset(
                "assets/images/img_error.jpg",
                fit: BoxFit.cover,
              ),
            ),
          );
        }

        return Container(
          padding: ResponsiveHelper.padding(context, 0, 0.8),
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFede7f6),
                Color(0xFFb3e5fc),

              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              ResponsiveHelper.sizeBoxHeightSpace(context, 1),
              CarouselSlider(
                items: homeBannerList.map((item) {
                  return Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: GestureDetector(
                      onTap: () {
                        // int targetIndex = int.tryParse(item.index.toString()) ?? 0;
                        int targetIndex = (int.tryParse(item.index.toString()) ?? 1) - 1;

                        print("click banner2 index= ${targetIndex}");
                        if (targetIndex >= 1 && targetIndex <= 5) {
                          _navigateToBottomNav(targetIndex);
                        }
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: ImageLoaderUtil.cacheNetworkImage(item.photo!.secureUrl.toString())
                        // CachedNetworkImage(
                        //   imageUrl: item.photo!.secureUrl.toString(),
                        //   fit: BoxFit.fill,
                        //   placeholder: (context, url) =>
                        //       Center(
                        //         child: Image.asset(
                        //             "assets/images/img_placeholder.jpeg"), // Placeholder while loading
                        //       ),
                        //   errorWidget:
                        //       (context, url, error) =>
                        //   const Icon(
                        //     Icons.error,
                        //     color: Colors
                        //         .red, // Show error icon if image fails
                        //   ),
                        //   fadeInDuration: const Duration(
                        //       milliseconds: 500),
                        //   // Smooth fade-in effect
                        //   fadeOutDuration: const Duration(
                        //       milliseconds: 300),
                        // ),



                        // Image.network(
                        //   item.photo!.secureUrl.toString(),
                        //   fit: BoxFit.fill,
                        //   width: double.infinity,
                        //   errorBuilder: (context, error, stackTrace) =>
                        //       Image.asset("assets/images/img_error.jpg"),
                        // ),




                      ),
                    ),
                  );
                }).toList(),
                carouselController: _controller,
                options: CarouselOptions(
                  autoPlay: true,
                  viewportFraction: 0.89,
                  height: ResponsiveHelper.containerHeight(context, 20),
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
              ResponsiveHelper.sizeBoxHeightSpace(context, 1),
            ],
          ),
        );
      },
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
